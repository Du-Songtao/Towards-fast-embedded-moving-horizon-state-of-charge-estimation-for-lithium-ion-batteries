function[SOCEst,SOC,SOCRMSE,meanTime,maxTime,relinFlag,diffVal,objValue] = fasterMHE(P0,Q,R,I,y,SOC,V1, ...
                                                        OCVCoefficient,RsCoefficient, ...
                                                        R1Coefficient,C1Coefficient,tDelta, ...
                                                        errorInitialEstimation,Cn, ...
                                                        N,nIter,difflinThreshold)
% not update P0
% event-triggered relinearization when the iteration number > 1

    rng('default');
    T = size(SOC,1);
    invP0 = inv(P0);
    invQ = inv(Q);
    invR = inv(R);

    X0 = [SOC(1)-errorInitialEstimation; V1(1); 0; 0; 0]; % 估计初值

    XEst = zeros([size(X0),T]); % MHE在时间段T内的估计结果
    solveTime = zeros(1,T); % MHE每次优化所用时间
    objValue = zeros(1,T); % MHE每次优化得到的目标函数值


    relinFlag = zeros(nIter,T);
    diffVal = zeros(nIter,T);
    for k=1:T
        tic; % 记录当前系统时间

        if k==1
            [XSolve,relinFlag(:,k),diffVal(:,k)] = solver_first_horizon(X0,I(1),y(1),tDelta,OCVCoefficient,RsCoefficient,R1Coefficient,C1Coefficient,P0,R,nIter,difflinThreshold);
            XEst(:,:,k) = XSolve;
            % objValue(k) = obj_first_horizon(XSolve,I(1),y(1),OCVCoefficient,RsCoefficient,X0,P0,R);
        end

        if k>=2 && k<=N
            X0 = XSolve;
            X0(:,:,k) = state_eq(XSolve(:,:,k-1),I(k-1),tDelta,Cn,R1Coefficient,C1Coefficient);
            horizonSize=k;
            [XSolve,XLin,relinFlag(:,k),KKTinv,SysLin,diffVal(:,k)] = solver2(X0,I(1:k),y(1:k),tDelta,Cn,horizonSize,OCVCoefficient,RsCoefficient,R1Coefficient,C1Coefficient,invP0,invQ,invR,nIter,difflinThreshold);
            XEst(:,:,k) = XSolve(:,:,end);
            % objValue(k) = obj(XSolve,I(1:k),y(1:k),tDelta, ...
            %                     Cn,horizonSize,OCVCoefficient, ...
            %                     RsCoefficient,R1Coefficient, ...
            %                     C1Coefficient,X0(:,:,1),P0,Q,R);
        end

        if k>N

##            P0=P0_adaptive_Func(P0,Q,R,XSolve(:,:,1),I(k-N),OCVCoefficient,RsCoefficient,R1Coefficient,C1Coefficient,tDelta);
##            invP0 = inv(P0);

            X0 = XSolve(:,:,2:end);
            X0(:,:,N) = state_eq(XSolve(:,:,end),I(k-1),tDelta,Cn,R1Coefficient,C1Coefficient);
            horizonSize=N;
            [XSolve,XLin,relinFlag(:,k),KKTinv,SysLin,diffVal(:,k)] = solver3(KKTinv,SysLin,XLin,X0,I(k-N+1:k),y(k-N+1:k),tDelta,Cn,horizonSize,OCVCoefficient,RsCoefficient,R1Coefficient,C1Coefficient,invP0,invQ,invR,nIter,difflinThreshold);
            XEst(:,:,k) = XSolve(:,:,end);
            % objValue(k) = obj(XSolve,I(k-N+1:k),y(k-N+1:k), ...
            %                     tDelta,Cn,horizonSize,OCVCoefficient, ...
            %                     RsCoefficient,R1Coefficient,C1Coefficient, ...
            %                     X0(:,:,1),P0,Q,R);
        end

        solveTime(k) = toc; % 单次优化所用的时间
    end

    SOCEst = reshape(XEst(1,:,:),size(SOC));
    SOCRMSE =sqrt(mean((SOCEst-SOC).^2)); % 估计精度

    meanTime = mean(solveTime); % 平均计算时间
    maxTime = max(solveTime); % 最大计算时间
end

%% 第一个时刻的求解器
function [XSolve,difflinFlag,diffval] = solver_first_horizon(X0,u,y,tDelta,OCVCoefficient,RsCoefficient,R1Coefficient,C1Coefficient,P0,R,nIter,difflinThreshold)
    XBar = X0;
    xPrior = X0(:,:,1);
    invP0 = inv(P0);
    invR = inv(R);

    difflinFlag = ones(nIter,1);
    diffval = zeros(nIter,1);

    for i = 1:nIter
        if i>1
           [difflinFlag(i),diffval(i)] = difflinFunc(XBar,u,XLin,difflinThreshold);
        end

        if difflinFlag(i) == 1 % relinearization; difflinFlag(1)=1 always holds
            XLin.x = XBar;
            XLin.u = u;
            [~,C] = linear_eq(XBar,u,OCVCoefficient,RsCoefficient,R1Coefficient,C1Coefficient,tDelta);
            hessen = invP0 + C' * invR * C;
        end

        xRes = XBar-xPrior;
        ry = y - ob_eq(XBar,u,OCVCoefficient,RsCoefficient);
        rd = - invP0 * xRes + C' * invR * ry;
        dx = hessen\rd;

        XBar = XBar + dx;
    end

    XSolve = XBar;
end

function fun = obj_first_horizon(X,u,y,OCVCoefficient, ...
                                    RsCoefficient,xPrior,P0,R)
    arrivalCostRes = X - xPrior;
    fun = arrivalCostRes' * inv(P0) * arrivalCostRes; % arrival cost

    obRes = y - ob_eq(X,u,OCVCoefficient,RsCoefficient);
    fun = fun + obRes' * inv(R) * obRes;
end

function fun = obj(X,u,y,tDelta,Cn,horizonSize, ...
                    OCVCoefficient,RsCoefficient, ...
                    R1Coefficient,C1Coefficient,xPrior,P0,Q,R)

    arrivalCostRes = X(:,:,1) - xPrior;
    fun = arrivalCostRes' * inv(P0) * arrivalCostRes; % arrival cost

    for i = 1:horizonSize
        obRes = y(i) - ob_eq(X(:,:,i),u(i),OCVCoefficient,RsCoefficient);
        fun = fun + obRes' * inv(R) * obRes;
    end

    for i = 1:horizonSize-1
        stateRes = X(:,:,i+1) - state_eq(X(:,:,i),u(i),tDelta,Cn,R1Coefficient,C1Coefficient);
        fun = fun + stateRes' * inv(Q) * stateRes;
    end
end

function [Xsolve,XLin,difflinFlag,KKTinv,SysLin,diffval] = solver2(X0,u,y,tDelta,Cn,horizonSize,OCVCoefficient,RsCoefficient,R1Coefficient,C1Coefficient,invP0,invQ,invR,nIter,difflinThreshold)
    XBar = X0;
    xPrior = X0(:,:,1);

    difflinFlag = ones(nIter,1);
    diffval = zeros(nIter,1);

%     difflinFlag = [1; zeros(nIter-1,1)];
    for i = 1:nIter
        if i > 1
           [difflinFlag(i),diffval(i)] = difflinFunc(XBar,u,XLin,difflinThreshold);
        end

        if difflinFlag(i)==1
           XLin.x = XBar;
           XLin.u = u;
           [KKTinv,SysLin] = KKTFunc(XBar,u,y,tDelta,horizonSize,OCVCoefficient,RsCoefficient,R1Coefficient,C1Coefficient,invP0,invQ,invR);
        end

        rd = rdFunc(XBar,xPrior,SysLin,u,y,tDelta,Cn,horizonSize,OCVCoefficient,RsCoefficient,R1Coefficient,C1Coefficient,invP0,invQ,invR);
        X_delta = ForwardbackwardFunc(rd,KKTinv,horizonSize);

        XBar = XBar + X_delta;
    end

    Xsolve = XBar;
end

function [Xsolve,XLin,difflinFlag,KKTinv,SysLin,diffval] = solver3(KKTinv,SysLin,XLin,X0,u,y,tDelta,Cn,horizonSize,OCVCoefficient,RsCoefficient,R1Coefficient,C1Coefficient,invP0,invQ,invR,nIter,difflinThreshold)
    XBar = X0;
    xPrior = X0(:,:,1);

    difflinFlag = ones(nIter,1);
    diffval = zeros(nIter,1);

%     difflinFlag = zeros(nIter,1);
    for i = 1:nIter
        [difflinFlag(i),diffval(i)] = difflinFunc(XBar,u,XLin,difflinThreshold);

        if difflinFlag(i)==1
            XLin.x = XBar;
            XLin.u = u;
            [KKTinv,SysLin] = KKTFunc(XBar,u,y,tDelta,horizonSize,OCVCoefficient,RsCoefficient,R1Coefficient,C1Coefficient,invP0,invQ,invR);
%             SysLin.AA(2,:,1)
        end

        rd = rdFunc(XBar,xPrior,SysLin,u,y,tDelta,Cn,horizonSize,OCVCoefficient,RsCoefficient,R1Coefficient,C1Coefficient,invP0,invQ,invR);
        X_delta = ForwardbackwardFunc(rd,KKTinv,horizonSize);

        XBar = XBar + X_delta;


    end

    Xsolve = XBar;
end

function[KKTinv,SysLin] = KKTFunc(XBar,u,y,tDelta,horizonSize,OCVCoefficient,RsCoefficient,R1Coefficient,C1Coefficient,invP0,invQ,invR)

    nx = size(XBar,1);
    ny = size(y,2);

    Sigma = zeros(nx,nx,horizonSize);
    KKTinv.invSigma = zeros(nx,nx,horizonSize);
    KKTinv.invSigma_GammaT = zeros(nx,nx,horizonSize);
    KKTinv.invSigma_Gamma = zeros(nx,nx,horizonSize);

    % 生成A，C矩阵
    SysLin.AA = zeros(nx,nx,horizonSize);
    SysLin.CC = zeros(ny,nx,horizonSize);
    SysLin.CR = zeros(ny,nx,horizonSize);
    SysLin.AQ = zeros(nx,nx,horizonSize);

    for i=1:horizonSize
        [SysLin.AA(:,:,i), SysLin.CC(:,:,i)] = linear_eq(XBar(:,:,i),u(i),OCVCoefficient,RsCoefficient,R1Coefficient,C1Coefficient,tDelta);
        SysLin.CR(:,:,i) = invR*SysLin.CC(:,:,i);
        SysLin.AQ(:,:,i) = invQ*SysLin.AA(:,:,i);
    end

    % phi matrix
    phi = zeros(nx,nx,horizonSize);
    phi(:,:,1) = invP0 + SysLin.AA(:,:,1)'*SysLin.AQ(:,:,1) + SysLin.CC(:,:,1)'*SysLin.CR(:,:,1);
    if horizonSize > 2
        for i=2:horizonSize-1
            phi(:,:,i) = invQ + SysLin.AA(:,:,i)'*SysLin.AQ(:,:,i) + SysLin.CC(:,:,i)'*SysLin.CR(:,:,i);
        end
    end
    phi(:,:,horizonSize) = invQ + SysLin.CC(:,:,horizonSize)'*SysLin.CR(:,:,horizonSize);

    % LU factorization
    Sigma(:,:,1)=phi(:,:,1);
    KKTinv.invSigma(:,:,1)=inv(Sigma(:,:,1));
    KKTinv.invSigma_GammaT(:,:,1) = KKTinv.invSigma(:,:,1)*SysLin.AQ(:,:,1)';
    for i=2:horizonSize
       Sigma(:,:,i)=phi(:,:,i)-SysLin.AQ(:,:,i-1)*KKTinv.invSigma(:,:,i-1)*SysLin.AQ(:,:,i-1)';
       KKTinv.invSigma(:,:,i)=inv(Sigma(:,:,i));
       KKTinv.invSigma_GammaT(:,:,i) = KKTinv.invSigma(:,:,i)*SysLin.AQ(:,:,i)';
       KKTinv.invSigma_Gamma(:,:,i) = KKTinv.invSigma(:,:,i)*SysLin.AQ(:,:,i-1);
    end
end

function rd = rdFunc(XBar,xPrior,SysLin,u,y,tDelta,Cn,horizonSize,OCVCoefficient,RsCoefficient,R1Coefficient,C1Coefficient,invP0,invQ,invR)

nx = size(XBar,1);
ny = size(y,2);

% fi
fi = zeros(nx,1,horizonSize);
for i=1:horizonSize-1
   fi(:,:,i) = XBar(:,:,i+1) - state_eq(XBar(:,:,i),u(i),tDelta,Cn,R1Coefficient,C1Coefficient);
end

% ry
ry = zeros(ny,1,horizonSize);
for i=1:horizonSize
   ry(:,:,i) = y(i) - ob_eq(XBar(:,:,i),u(i),OCVCoefficient,RsCoefficient);
end

% xres
xRes = XBar(:,:,1)-xPrior;

% rd
rd = zeros(nx,1,horizonSize);
rd(:,:,1) = -invP0*xRes...
            + SysLin.AQ(:,:,1)'*fi(:,:,1) + SysLin.CR(:,:,1)'*ry(:,:,1);
if horizonSize > 2
   for i=2:horizonSize-1
      rd(:,:,i) = -invQ*fi(:,:,i-1) + SysLin.AQ(:,:,i)'*fi(:,:,i)...
                  + SysLin.CR(:,:,i)'*ry(:,:,i);
   end
end
rd(:,:,horizonSize) = -invQ*fi(:,:,horizonSize-1)...
        + SysLin.CR(:,:,horizonSize)'*ry(:,:,horizonSize);

end

function dx = ForwardbackwardFunc(rd,KKTinv,horizonSize)
    nx = size(rd,1);

    % forward recursion
    dx1 = zeros(nx,1,horizonSize);
    dx1(:,:,1)=KKTinv.invSigma(:,:,1)*rd(:,:,1);
    for i=2:horizonSize
        dx1(:,i)=KKTinv.invSigma(:,:,i)*rd(:,:,i)+KKTinv.invSigma_Gamma(:,:,i)*dx1(:,i-1);
    end

    % backward recursion
    dx = zeros(nx,1,horizonSize);
    dx(:,horizonSize)=dx1(:,horizonSize);
    for i=horizonSize-1:-1:1
        dx(:,i)=dx1(:,i)+KKTinv.invSigma_GammaT(:,:,i)*dx(:,i+1);
    end
end

function [difflinFlag,diffmax] = difflinFunc(XBar, u, XLin, threshold)

m = size(XBar,3);
diff = zeros(1,m);
for i = 1:m
    slin = [XLin.x(:,:,i); XLin.u(i)];
    s = [XBar(:,:,i); u(i)];
%     slin = XLin.x(:,:,i);
%     s = XBar(:,:,i);
    diff(i) = norm(s-slin)/norm(slin);
%    diff(i) = norm(s-slin);
end
diffmax = max(diff);


% slin = zeros(6,m);
% s = zeros(6,m);
% for i = m
%     slin(:,i) = [XLin.x(:,:,i); XLin.u(i)];
%     s(:,i) = [XBar(:,:,i); u(i)];
% end
% diffmax = norm(s-slin,'fro')/norm(slin,'fro');

if diffmax >= threshold
    difflinFlag = 1;
else
    difflinFlag = 0;
end

end
