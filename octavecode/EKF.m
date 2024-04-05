function [SOCEst,SOC,SOCRMSE,meanTime,maxTime] = EKF(P0,Q,R,I,y,SOC,V1, ...
                                                                OCVCoefficient,RsCoefficient, ...
                                                                R1Coefficient,C1Coefficient,Cn, ...
                                                                tDelta,errorInitialEstimation)
    rng('default');
    T=size(SOC,1);
 
    X0 = [SOC(1)-errorInitialEstimation; V1(1); 0; 0; 0]; % 估计初值

    XEst = zeros([5,T]); % EKF在时间段T内的估计结果
    solveTime = zeros(1,T); % EKF每次优化所用时间

    tic; % 记录当前系统时间

    % first step
    [~,C] = linear_eq(X0,I(1),OCVCoefficient,RsCoefficient,R1Coefficient,C1Coefficient,tDelta);
    K = P0 * C' * inv(C * P0 * C' + R);
    XEst(:,1) = X0 + K * (y(1) - ob_eq(X0,I(1),OCVCoefficient,RsCoefficient));
    P0 = (eye(5) - K * C) * P0; P0=(P0+P0')/2;

    solveTime(1) = toc; % 单次优化所用的时间

%     As = zeros(5,5,T);
%     Cs = zeros(T,5);
%     Cs(1,:) = C;
%     deltaA = zeros(1,T);
%     deltaC = zeros(1,T);
%     deltaX = zeros(1,T);
    for k=2:T
        tic;
        % 预测
        [A,~] = linear_eq(XEst(:,k-1),I(k-1), ...
                            OCVCoefficient,RsCoefficient, ...
                            R1Coefficient,C1Coefficient,tDelta);

        P0 = A * P0 * A' + Q; P0=(P0+P0')/2;
        xPredict = state_eq(XEst(:,k-1),I(k-1),tDelta,Cn,R1Coefficient,C1Coefficient);

        % 修正
        [~,C] = linear_eq(xPredict,I(k), ...
                            OCVCoefficient,RsCoefficient, ...
                            R1Coefficient,C1Coefficient,tDelta);
        K = P0 * C' * inv(C * P0 * C' + R);
        XEst(:,k) = xPredict + K*(y(k) - ob_eq(xPredict,I(k),OCVCoefficient,RsCoefficient));
        P0 = (eye(5) - K * C) * P0; P0=(P0+P0')/2;

        solveTime(k) = toc; % 单次优化所用的时间

%         As(:,:,k) = A;
%         Cs(k,:) = C;
%         deltaA(k) = abs( norm(As(:,:,k)-As(:,:,k-1),'fro') )/norm( As(:,:,k-1), 'fro' );
%         deltaC(k) = abs( norm(Cs(k,:)-Cs(k-1,:),'fro') )/norm( Cs(k-1,:), 'fro' );
%         deltaX(k) = abs( norm(XEst(:,k)-XEst(:,k-1),'fro') )/norm( XEst(:,k-1), 'fro' );
    end

    SOCEst = XEst(1,:)';
    SOCRMSE =sqrt(mean((SOCEst-SOC).^2)); % 估计精度

    meanTime = mean(solveTime); % 平均计算时间
    maxTime = max(solveTime); % 最大计算时间
end
