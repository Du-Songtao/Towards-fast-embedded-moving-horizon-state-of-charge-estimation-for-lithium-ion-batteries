function [A,C] = linear_eq(xnow,u,a_OCV,a_Rs,a_R1,a_C1,t_delta)
    SOC=xnow(1);
    V1=xnow(2);
%     beta1=xnow(3);
    beta2=xnow(4);
    beta3=xnow(5);
    
    soc_poly = [SOC^5;SOC^4;SOC^3;SOC^2;SOC;1];
    soc_deriv = [5*SOC^4;4*SOC^3;3*SOC^2;2*SOC;1;0];

%     OCV=a_OCV*soc_poly;
%     R0=beta1+a_Rs*soc_poly;
    R1=beta2+a_R1*soc_poly;
    C1=beta3+a_C1*soc_poly;
    tau=R1*C1; 

    R1_deriv=a_R1*soc_deriv; % R1对z的导数
    tau_deriv=a_C1*soc_deriv*R1+a_R1*soc_deriv*C1; % tau对z的导数
    OCV_deriv=a_OCV*soc_deriv; % OCV对z的导数
    R0_deriv=a_Rs*soc_deriv; % R0对z的导数

    A21=V1*exp(-t_delta/tau)*t_delta/tau^2*tau_deriv...
        +u*R1_deriv*(1-exp(-t_delta/tau))...
        -u*R1*exp(-t_delta/tau)*t_delta/tau^2*tau_deriv;

    A22=exp(-t_delta/(tau));          
    A24=V1*exp(-t_delta/tau)*t_delta*C1/tau^2+u*(1-exp(-t_delta/tau))-u*R1*exp(-t_delta/tau)*t_delta*C1/tau^2;
    A25=(V1-u*R1)*(exp(-t_delta/tau)*t_delta*R1/tau^2);

    A=[1 0 0 0 0;
    A21 A22 0 A24 A25;
    0 0 1 0 0;
    0 0 0 1 0;
    0 0 0 0 1];
    
    C=[OCV_deriv-R0_deriv*u -1 -u 0 0];
end
