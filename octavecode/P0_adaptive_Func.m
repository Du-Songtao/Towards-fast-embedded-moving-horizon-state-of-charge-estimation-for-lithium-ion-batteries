function P0 = P0_adaptive_Func(P0,Q,R,xnow,u,OCVCoefficient,RsCoefficient,R1Coefficient,C1Coefficient,tDelta)
    nx=size(P0,1);

    %% A, C
    [A,C]=linear_eq(xnow,u,OCVCoefficient,RsCoefficient,R1Coefficient,C1Coefficient,tDelta);
    
    %% update P0
    %% 先测量更新，再预测
    K=P0*C'*inv(C*P0*C'+R);
    P0_=(eye(nx)-K*C)*P0; %P0_=(P0_+P0_')/2;
    P0=Q+A*P0_*A';
    P0=(P0+P0')/2;
end