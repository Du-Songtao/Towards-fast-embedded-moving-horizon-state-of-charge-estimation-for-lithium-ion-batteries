close all;
clearvars;
clc;
rng('default');

Cn = 2*3600;

% 最佳ECM参数
OCVCoefficient = [6.22208224936665	-19.9093874725356	23.9813888880365	-12.6566652398929	3.29470483945726	3.24331426757604];
R0Coefficient = [-0.638251334079213	1.62884941926457	-1.60428494575084	0.773847519249399	-0.186716766043422	0.0893053439242714];
R1Coefficient = [7.74165845426853	-16.8812971745625	12.9989511660378	-4.16803502790232	0.507411992417779	0.00269896090704541];
C1Coefficient = [124589.171014214	-203175.870591128	92495.5796502545	-644.923846321636	-6863.33743847574	1877.25503452128];

tDelta = 1;
errorInitialEstimation = 0.4; %

P0 = diag([1E-2 1E-3 1E-6 1E-6 1E-6]);
Q = diag([1E-6 1E-2 1E-6 1E-6 1E-6]);
R = 1E-6;

%% BJDST EKF
load("BJDSTdata.mat");
% 数据预处理
data=BJDSTdata;
I = data(:,1); % 电流
y = data(:,2); % 端电压
SOCreal = data(:,3); % SOC
OCV = polyval(OCVCoefficient,SOCreal); % OCV
R0 = polyval(R0Coefficient,SOCreal); % R0
V1 = OCV-y-I.*R0;
y = y + sqrt(R) * randn(size(y)); % 添加观测噪声

[SOCEst,SOC,SOCRMSE,meanTime,maxTime] = EKF(P0,Q,R,I,y,SOCreal,V1, ...
                                            OCVCoefficient,R0Coefficient, ...
                                            R1Coefficient,C1Coefficient,Cn, ...
                                            tDelta,errorInitialEstimation);
BJDSTRealSOC = SOC;
BJDSTEKFSOC = SOCEst;
BJDSTEKFSOCRMSE = SOCRMSE;
BJDSTEKFMeanTime = meanTime;
BJDSTEKFMaxTime = maxTime;


%% US06 EKF
load("US06data.mat");
% 数据预处理
data=US06data;
I = data(:,1); % 电流
y = data(:,2); % 端电压
SOCreal = data(:,3); % SOC
OCV = polyval(OCVCoefficient,SOCreal); % OCV
R0 = polyval(R0Coefficient,SOCreal); % R0
V1 = OCV-y-I.*R0;
y = y + sqrt(R) * randn(size(y)); % 添加观测噪声

[SOCEst,SOC,SOCRMSE,meanTime,maxTime] = EKF(P0,Q,R,I,y,SOCreal,V1, ...
                                            OCVCoefficient,R0Coefficient, ...
                                            R1Coefficient,C1Coefficient,Cn, ...
                                            tDelta,errorInitialEstimation);
US06RealSOC = SOC;
US06EKFSOC = SOCEst;
US06EKFSOCRMSE = SOCRMSE;
US06EKFMeanTime = meanTime;
US06EKFMaxTime = maxTime;


%% DST EKF
load("DSTdata.mat");
% 数据预处理
data=DSTdata;
I = data(:,1); % 电流
y = data(:,2); % 端电压
SOCreal = data(:,3); % SOC
OCV = polyval(OCVCoefficient,SOCreal); % OCV
R0 = polyval(R0Coefficient,SOCreal); % R0
V1 = OCV-y-I.*R0;
y = y + sqrt(R) * randn(size(y)); % 添加观测噪声

[SOCEst,SOC,SOCRMSE,meanTime,maxTime] = EKF(P0,Q,R,I,y,SOCreal,V1, ...
                                            OCVCoefficient,R0Coefficient, ...
                                            R1Coefficient,C1Coefficient,Cn, ...
                                            tDelta,errorInitialEstimation);
DSTRealSOC = SOC;
DSTEKFSOC = SOCEst;
DSTEKFSOCRMSE = SOCRMSE;
DSTEKFMeanTime = meanTime;
DSTEKFMaxTime = maxTime;


%% results
disp('EKF RMSE');
disp([US06EKFSOCRMSE BJDSTEKFSOCRMSE DSTEKFSOCRMSE]);
disp('EKF Average time');
disp([US06EKFMeanTime BJDSTEKFMeanTime DSTEKFMeanTime]);
disp('EKF Worst-case time');
disp([US06EKFMaxTime BJDSTEKFMaxTime DSTEKFMaxTime]);

figure
subplot(1,3,1)
hold on;box on
plot(BJDSTRealSOC)
plot(BJDSTEKFSOC)
title('BJDST');

subplot(1,3,2)
hold on;box on
plot(US06RealSOC)
plot(US06EKFSOC)
title('US06');

subplot(1,3,3)
hold on;box on
plot(DSTRealSOC)
plot(DSTEKFSOC)
title('DST');






