function[SOCEst,SOC,SOCRMSE,meanTime,maxTime,nIter,objValue] = ExactMHE_casadi(P0,Q,R,I,y,SOC,V1, ...
                                                        OCVCoefficient,RsCoefficient, ...
                                                        R1Coefficient,C1Coefficient,tDelta, ...
                                                        errorInitialEstimation,Cn,N,options)
    rng('default');
    import casadi.*

    invQ=inv(Q);
    invR=inv(R);

    T=size(SOC,1);
    
    X0 = [SOC(1) - errorInitialEstimation; V1(1); 0; 0; 0]; % 估计初值
    XEst = zeros(5,T); % MHE在时间段T内的估计结果
    solveTime = zeros(1,T); % MHE在每次优化所用时间
    objValue = zeros(1,T); % MHE每次优化得到的目标函数值
    nIter = zeros(1,T); % MHE每次优化的迭代次数

    % 使用casadi定义窗口长度为1时的目标函数 fun_joint_MHE_1
    XSym = SX.sym('X',5,1);
    P0Sym = SX.sym('P0',5,5); % arrival cost
    XPriorSym = SX.sym('Xprior',5,1); % arrival cost

    h1 = ob_eq(XSym,I(1),OCVCoefficient,RsCoefficient);
    fun = [chol(inv(P0Sym)) * (XSym-XPriorSym); sqrt(invR) * (y(1)-h1)];
    
    % 输出：目标函数 + 雅可比矩阵
    fj = Function('fj',{XSym,P0Sym,XPriorSym},{fun,jacobian(fun,XSym)});
    fun_joint_MHE_1 = returntypes('full',fj);

    % 使用casadi定义窗口长度为N时的目标函数 fun_joint_MHE_N
    XSym = SX.sym('X',5,N);
    P0Sym = SX.sym('P0',5,5); % arrival cost
    XPriorSym = SX.sym('Xprior',5,1); % arrival cost
    ISym = SX.sym('I',1,N);
    ySym = SX.sym('y',1,N);
    
    fun = chol(inv(P0Sym))*(XSym(:,1)-XPriorSym);
    
    for i=1:N-1
        xnext = state_eq(XSym(:,i),ISym(i),tDelta,Cn,R1Coefficient,C1Coefficient);
        fun = [fun; sqrt(invQ) * (XSym(:,i+1) - xnext)];
    end
    
    for i=1:N
        hi = ob_eq(XSym(:,i),ISym(i),OCVCoefficient,RsCoefficient);
        fun = [fun ; sqrt(invR) * (ySym(i)-hi)];
    end
    
    % 输出：目标函数 + 雅可比矩阵
    fj = Function('fj',{XSym,P0Sym,XPriorSym,ISym,ySym},{fun,jacobian(fun,XSym)});
    fun_joint_MHE_N = returntypes('full',fj);

    for k=1:T
        tic; % 记录当前系统时间
        
        if k==1
            [XSolve,~,~,~,output] = lsqnonlin(@(X) fun_joint_MHE_1(X,P0,X0),X0,[],[],options);
            nIter(k) = output.iterations;
            XEst(:,k) = XSolve;
            objValue(k) = obj_first_horizon(XSolve,I(1),y(1),OCVCoefficient,RsCoefficient,X0,P0,R);
        end
        
        if k>=2 && k<=N
            % warmstart: 初始点猜测=上一时刻的解+对当前时刻状态的预测
            X0 = [XSolve,state_eq(XSolve(:,k-1),I(k-1),tDelta,Cn,R1Coefficient,C1Coefficient)];
            
            % 使用casadi定义窗口长度为k时的目标函数 fun_joint_MHE_k
            % k是一个变量，所以fun_joint_MHE_k随迭代次数变化

            XSym = SX.sym('X',5,k);
            P0Sym = SX.sym('P0',5,5); % arrival cost
            XPriorSym = SX.sym('X_prior',5,1); % arrival cost
            ISym = SX.sym('I',1,k);
            ySym = SX.sym('y',1,k);
            
            fun = chol(inv(P0Sym))*(XSym(:,1)-XPriorSym);
            
            for i=1:k-1
                xnext = state_eq(XSym(:,i),ISym(i),tDelta,Cn,R1Coefficient,C1Coefficient);
                fun = [fun; sqrt(inv(Q)) * (XSym(:,i+1) - xnext)];
            end
            
            for i=1:k
                hi = ob_eq(XSym(:,i),ISym(i),OCVCoefficient,RsCoefficient);
                fun = [fun; sqrt(inv(R)) * (ySym(i)-hi)];
            end
            
            fj = Function('fj',{XSym,P0Sym,XPriorSym,ISym,ySym},{fun,jacobian(fun,XSym)});
            fun_joint_MHE_k = returntypes('full',fj);
            
            [XSolve,~,~,~,output]=lsqnonlin(@(X) fun_joint_MHE_k(X,P0,X0(:,1),I(1:k),y(1:k)),X0,[],[],options);
            nIter(k) = output.iterations;
            XEst(:,k)=XSolve(:,end);
            objValue(k) = obj(XSolve,I(1:k),y(1:k), ...
                            tDelta,Cn,k,OCVCoefficient, ...
                            RsCoefficient,R1Coefficient, ...
                            C1Coefficient,X0(:,1),P0,Q,R);
        end
        
        if k>N
            P0=P0_adaptive_Func(P0,Q,R,XSolve(:,1),I(k-N),OCVCoefficient,RsCoefficient,R1Coefficient,C1Coefficient,tDelta);

            % warmstart: 初始点猜测=shifted上一时刻的解+对当前时刻状态的预测
            X0 = [XSolve(:,2:end),state_eq(XSolve(:,end),I(k-1),tDelta,Cn,R1Coefficient,C1Coefficient)]; 

            [XSolve,~,~,~,output]=lsqnonlin(@(X) fun_joint_MHE_N(X,P0,X0(:,1),I(k-N+1:k),y(k-N+1:k)),X0,[],[],options);

            nIter(k) = output.iterations;

            XEst(:,k)=XSolve(:,end);
            objValue(k) = obj(XSolve,I(k-N+1:k),y(k-N+1:k), ...
                            tDelta,Cn,N,OCVCoefficient, ...
                            RsCoefficient,R1Coefficient, ...
                            C1Coefficient,X0(:,1),P0,Q,R); 
        end

        solveTime(k) = toc; % 单次优化所用的时间
    end

    SOCEst = XEst(1,:)';
    SOCRMSE =sqrt(mean((SOCEst-SOC).^2)); % 估计精度

    meanTime = mean(solveTime); % 平均计算时间
    maxTime = max(solveTime); % 最大计算时间
end

function fun = obj(X,u,y,tDelta,Cn,horizonSize,OCVCoefficient,RsCoefficient,R1Coefficient,C1Coefficient,xPrior,P0,Q,R)    
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
