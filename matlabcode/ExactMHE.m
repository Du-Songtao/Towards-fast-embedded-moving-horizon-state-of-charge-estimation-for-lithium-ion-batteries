function[SOCEst,SOC,SOCRMSE,meanTime,maxTime,nIter,objValue] = ExactMHE(P0,Q,R,I,y,SOC,V1,OCVCoefficient,RsCoefficient,R1Coefficient,C1Coefficient,tDelta,errorInitialEstimation,Cn,N,options)
    rng('default');

    invQ=inv(Q);
    invR=inv(R);

    T=size(SOC,1);

    X0 = [SOC(1) - errorInitialEstimation; V1(1); 0; 0; 0]; % 估计初值
    XEst = zeros(5,T); % MHE在时间段T内的估计结果
    solveTime = zeros(1,T); % MHE在每次优化所用时间
    objValue = zeros(1,T); % MHE每次优化得到的目标函数值
    nIter = zeros(1,T); % MHE每次优化的迭代次数

    for k=1:T
        tic; % 记录当前系统时间

        if k==1
            [XSolve,~,~,~,output] = lsqnonlin(@(X) funJacb_first_horizon(X,I(1),y(1),OCVCoefficient,RsCoefficient,X0,P0,R),X0,[],[],options);
            nIter(k) = output.iterations;
            XEst(:,k) = XSolve;
            % objValue(k) = obj_first_horizon(XSolve,I(1),y(1),OCVCoefficient,RsCoefficient,X0,P0,R);
        end

        if k>=2 && k<=N
            % warmstart: 初始点猜测=上一时刻的解+对当前时刻状态的预测
            X0 = [XSolve;state_eq(XSolve(end-4:end,:),I(k-1),tDelta,Cn,R1Coefficient,C1Coefficient)];
            [XSolve,~,~,~,output]=lsqnonlin(@(X) ...
                                  funJacb(X,I(1:k),y(1:k),tDelta,Cn,k,...
                                  OCVCoefficient,RsCoefficient,R1Coefficient,C1Coefficient,X0(1:5,:),P0,Q,R),...
                                  X0,[],[],options);
            nIter(k) = output.iterations;
            XEst(:,k)=XSolve(end-4:end,:);
            % objValue(k) = obj(XSolve,I(1:k),y(1:k), ...
            %                 tDelta,Cn,k,OCVCoefficient, ...
            %                 RsCoefficient,R1Coefficient, ...
            %                 C1Coefficient,X0(1:5,:),P0,Q,R);
        end

        if k>N
            P0=P0_adaptive_Func(P0,Q,R,XSolve(1:5,:),I(k-N),OCVCoefficient,RsCoefficient,R1Coefficient,C1Coefficient,tDelta);

            % warmstart: 初始点猜测=shifted上一时刻的解+对当前时刻状态的预测
            X0 = [XSolve(6:end,:);state_eq(XSolve(end-4:end,:),I(k-1),tDelta,Cn,R1Coefficient,C1Coefficient)];
            [XSolve,~,~,~,output]=lsqnonlin(@(X) ...
                      funJacb(X,I(k-N+1:k),y(k-N+1:k),tDelta,Cn,N,...
                      OCVCoefficient,RsCoefficient,R1Coefficient,C1Coefficient,X0(1:5,:),P0,Q,R),...
                      X0,[],[],options);

            nIter(k) = output.iterations;

            XEst(:,k)=XSolve(end-4:end,:);
            % objValue(k) = obj(XSolve,I(k-N+1:k),y(k-N+1:k), ...
            %                 tDelta,Cn,N,OCVCoefficient, ...
            %                 RsCoefficient,R1Coefficient, ...
            %                 C1Coefficient,X0(1:5,:),P0,Q,R);
        end

        solveTime(k) = toc; % 单次优化所用的时间
    end

    SOCEst = XEst(1,:)';
    SOCRMSE =sqrt(mean((SOCEst-SOC).^2)); % 估计精度

    meanTime = mean(solveTime); % 平均计算时间
    maxTime = max(solveTime); % 最大计算时间
end

function fun = obj(X,u,y,tDelta,Cn,horizonSize,OCVCoefficient,RsCoefficient,R1Coefficient,C1Coefficient,xPrior,P0,Q,R)
    X = reshape(X,5,horizonSize);
    arrivalCostRes = X(:,1) - xPrior;
    fun = arrivalCostRes' * inv(P0) * arrivalCostRes; % arrival cost

    for i = 1:horizonSize
        obRes = y(i) - ob_eq(X(:,i),u(i),OCVCoefficient,RsCoefficient);
        fun = fun + obRes' * inv(R) * obRes;
    end

    for i = 1:horizonSize-1
        stateRes = X(:,i+1) - state_eq(X(:,i),u(i),tDelta,Cn,R1Coefficient,C1Coefficient);
        fun = fun + stateRes' * inv(Q) * stateRes;
    end
end

function fun = obj_first_horizon(X,u,y,OCVCoefficient,RsCoefficient,xPrior,P0,R)
    arrivalCostRes = X - xPrior;
    fun = arrivalCostRes' * inv(P0) * arrivalCostRes; % arrival cost

    obRes = y - ob_eq(X,u,OCVCoefficient,RsCoefficient);
    fun = fun + obRes' * inv(R) * obRes;
end

function [res,jacb] = funJacb_first_horizon(X,u,y,OCVCoefficient,RsCoefficient,xPrior,P0,R)
    arrivalCostRes = X - xPrior;
    res = chol(inv(P0)) * arrivalCostRes; % arrival cost

    obRes = y - ob_eq(X,u,OCVCoefficient,RsCoefficient);
    res = [res; sqrt(inv(R)) * obRes];

    jacb = chol(inv(P0));

    [~,C] = linear_eq(X,u,OCVCoefficient,RsCoefficient,zeros(1,6),zeros(1,6),0);

    jacb = [jacb; - sqrt(inv(R)) * C];
end

function [Res,jacb] = funJacb(X,u,y,tDelta,Cn,horizonSize,OCVCoefficient,RsCoefficient,R1Coefficient,C1Coefficient,xPrior,P0,Q,R)
    X = reshape(X,5,horizonSize);
    arrivalCostRes = X(:,1) - xPrior;

    Res = chol(inv(P0)) * arrivalCostRes; % arrival cost

    for i = 1:horizonSize-1
      stateRes = X(:,i+1) - state_eq(X(:,i),u(i),tDelta,Cn,R1Coefficient,C1Coefficient);
      Res = [Res; sqrt(inv(Q)) * stateRes];
    end

    for i = 1:horizonSize
        obRes = y(i) - ob_eq(X(:,i),u(i),OCVCoefficient,RsCoefficient);
        Res = [Res; sqrt(inv(R)) * obRes];
    end

    jacb = zeros(horizonSize*1+horizonSize*5,horizonSize*5);
    jacb = mat2cell(jacb,[5, 5*ones(1,horizonSize-1), ones(1,horizonSize)],5*ones(1,horizonSize));

    jacb{1,1} = chol(inv(P0));

    for i = 1:horizonSize-1
      [A,~] = linear_eq(X(:,i),u(i),OCVCoefficient,RsCoefficient,R1Coefficient,C1Coefficient,tDelta);
      jacb{1+i,i} = - sqrt(inv(Q)) * A;
      jacb{1+i,i+1} = sqrt(inv(Q)) * eye(5);
    end

    for i = 1:horizonSize
      [~,C] = linear_eq(X(:,i),u(i),OCVCoefficient,RsCoefficient,zeros(1,6),zeros(1,6),0);
      jacb{horizonSize+i,i} = - sqrt(inv(R)) * C;
    end

    jacb = cell2mat(jacb);
end
