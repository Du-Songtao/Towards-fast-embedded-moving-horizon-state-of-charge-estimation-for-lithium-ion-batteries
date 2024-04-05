function[SOCEst,SOC,SOCRMSE,meanTime,maxTime,objValue] = fastMHE(P0,Q,R,I,y,SOC,V1, ...
                                                        OCVCoefficient,RsCoefficient, ...
                                                        R1Coefficient,C1Coefficient,tDelta, ...
                                                        errorInitialEstimation,Cn,N,nIter)
    rng('default');

    invQ = inv(Q);
    invR = inv(R);

    T=size(SOC,1);

    X0 = [SOC(1)-errorInitialEstimation; V1(1); 0; 0; 0]; % 估计初值

    XEst = zeros([size(X0),T]); % MHE在时间段T内的估计结果
    solveTime = zeros(1,T); % MHE每次优化所用时间
    objValue = zeros(1,T); % MHE每次优化得到的目标函数值

    for k=1:T
        tic; % 记录当前系统时间
    
        if k==1
            XSolve = solver_first_horizon(X0,I(1),y(1),tDelta,OCVCoefficient,RsCoefficient,R1Coefficient,C1Coefficient,P0,R,nIter);
            XEst(:,:,k) = XSolve;
%             objValue(k) = obj_first_horizon(XSolve,I(1),y(1),OCVCoefficient,RsCoefficient,X0,P0,R);
        end
    
        if k>=2 && k<=N
            X0 = XSolve;
            X0(:,:,k) = state_eq(XSolve(:,:,k-1),I(k-1),tDelta,Cn,R1Coefficient,C1Coefficient);
            horizonSize=k;
            XSolve = solver(X0,I(1:k),y(1:k),tDelta,Cn,horizonSize,OCVCoefficient,RsCoefficient,R1Coefficient,C1Coefficient,P0,Q,R,nIter);
            XEst(:,:,k) = XSolve(:,:,end);
%             objValue(k) = obj(XSolve,I(1:k),y(1:k),tDelta, ...
%                                 Cn,horizonSize,OCVCoefficient, ...
%                                 RsCoefficient,R1Coefficient, ...
%                                 C1Coefficient,X0(:,:,1),P0,Q,R);
        end
        
        if k>N 
            P0=P0_adaptive_Func(P0,Q,R,XSolve(:,:,1),I(k-N),OCVCoefficient,RsCoefficient,R1Coefficient,C1Coefficient,tDelta);
            X0 = XSolve(:,:,2:end);
            X0(:,:,N) = state_eq(XSolve(:,:,end),I(k-1),tDelta,Cn,R1Coefficient,C1Coefficient);
            horizonSize=N;
            XSolve = solver(X0,I(k-N+1:k),y(k-N+1:k),tDelta,Cn,horizonSize,OCVCoefficient,RsCoefficient,R1Coefficient,C1Coefficient,P0,Q,R,nIter);
            XEst(:,:,k) = XSolve(:,:,end);
%             objValue(k) = obj(XSolve,I(k-N+1:k),y(k-N+1:k), ...
%                                 tDelta,Cn,horizonSize,OCVCoefficient, ...
%                                 RsCoefficient,R1Coefficient,C1Coefficient, ...
%                                 X0(:,:,1),P0,Q,R); 
        end 
        solveTime(k) = toc; % 单次优化所用的时间
    end

    SOCEst = reshape(XEst(1,:,:),size(SOC));
    SOCRMSE =sqrt(mean((SOCEst-SOC).^2)); % 估计精度

    meanTime = mean(solveTime); % 平均计算时间
    maxTime = max(solveTime); % 最大计算时间
end

% 第一个时刻的求解器
function XSolve = solver_first_horizon(X0,u,y,tDelta,OCVCoefficient,RsCoefficient,R1Coefficient,C1Coefficient,P0,R,nIter)
    XBar = X0;
    xPrior = X0(:,:,1);
    invP0 = inv(P0);
    invR = inv(R);

    for i = 1:nIter
        [~,C] = linear_eq(XBar,u,OCVCoefficient,RsCoefficient,R1Coefficient,C1Coefficient,tDelta);
        hessen = invP0 + C' * invR * C;
        xRes = XBar-xPrior;
        ry = y - ob_eq(XBar,u,OCVCoefficient,RsCoefficient);
        rd = - invP0 * xRes + C' * invR * ry;

        dx = hessen\rd;

        XBar = XBar + dx;
    end

    XSolve = XBar;
end

% 求解器
function Xsolve = solver(X0,u,y,tDelta,Cn,horizonSize,OCVCoefficient,RsCoefficient,R1Coefficient,C1Coefficient,P0,Q,R,nIter)
    XBar = X0;
    xPrior = X0(:,:,1);

    for i = 1:nIter
        [Gamma,invSigma,rd] = KKTFunc(XBar,u,y,tDelta,Cn,horizonSize,OCVCoefficient,RsCoefficient,R1Coefficient,C1Coefficient,xPrior,P0,Q,R);
        X_delta = ForwardbackwardFunc(Gamma,invSigma,rd,horizonSize);

        XBar = XBar + X_delta;
    end

    Xsolve = XBar;
end

% 生成待求解的线性方程组Ax=b中的A,b
% 并对A进行LU分解
function[Gamma,invSigma,rd] = KKTFunc(XBar,u,y,tDelta,Cn,horizonSize,OCVCoefficient,RsCoefficient,R1Coefficient,C1Coefficient,xPrior,P0,Q,R)
    nx = size(XBar,1);
    ny = size(y,2);
    invP0 = inv(P0);
    invQ = inv(Q);
    invR = inv(R);
    
    % 生成A，C矩阵
    AA = zeros(nx,nx,horizonSize);
    CC = zeros(ny,nx,horizonSize);
    
    for i=1:horizonSize
        [AA(:,:,i),CC(:,:,i)] = linear_eq(XBar(:,:,i),u(i),OCVCoefficient,RsCoefficient,R1Coefficient,C1Coefficient,tDelta);
    end
    
    % 生成KKT矩阵
    % Gamma
    Gamma = zeros(nx,nx,horizonSize);
    
    for i=1:horizonSize-1
      Gamma(:,:,i) = invQ * AA(:,:,i);
    end
    
    % phi
    phi = zeros(nx,nx,horizonSize);
    
    phi(:,:,1) = invP0 + AA(:,:,1)' * invQ * AA(:,:,1)...
      + CC(:,:,1)' * invR * CC(:,:,1);
    
    for i=2:horizonSize-1
      phi(:,:,i) = invQ + AA(:,:,i)' * invQ * AA(:,:,i)...
          + CC(:,:,i)' * invR * CC(:,:,i);
    end
    
    phi(:,:,horizonSize) = invQ + CC(:,:,horizonSize)' * invR * CC(:,:,horizonSize);
    
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
    
    rd(:,:,1) = -invP0 * xRes...
            + AA(:,:,1)' * invQ * fi(:,:,1)...
            + CC(:,:,1)' * invR * ry(:,:,1);
    
    for i=2:horizonSize-1
        rd(:,:,i) = -invQ * fi(:,:,i-1)...
            + AA(:,:,i)' * invQ * fi(:,:,i)...
            + CC(:,:,i)' * invR * ry(:,:,i);
    end
    
    rd(:,:,horizonSize) = -invQ * fi(:,:,horizonSize-1)...
        + CC(:,:,horizonSize)' * invR * ry(:,:,horizonSize);

    % LU分解
    Sigma = zeros(nx,nx,horizonSize);
    invSigma = zeros(nx,nx,horizonSize);
    
    Sigma(:,:,1)=phi(:,:,1);
    invSigma(:,:,1)=inv(Sigma(:,:,1));
    
    for i=2:horizonSize
        Sigma(:,:,i)=phi(:,:,i)-Gamma(:,:,i-1)*invSigma(:,:,i-1)*Gamma(:,:,i-1)';
        invSigma(:,:,i)=inv(Sigma(:,:,i));
    end
end

function dx = ForwardbackwardFunc(Gamma,invSigma,rd,horizonSize)
    nx = size(rd,1);

    % forward recursion
    dx1 = zeros(nx,1,horizonSize);

    dx1(:,:,1)=invSigma(:,:,1)*rd(:,:,1);
    for i=2:horizonSize
        dx1(:,i)=invSigma(:,:,i)*(rd(:,:,i)+Gamma(:,:,i-1)*dx1(:,i-1));
    end

    % backward recursion
    dx = zeros(nx,1,horizonSize);

    dx(:,horizonSize)=dx1(:,horizonSize);
    for i=horizonSize-1:-1:1
        dx(:,i)=dx1(:,i)+invSigma(:,:,i)*Gamma(:,:,i)'*dx(:,i+1);
    end
end