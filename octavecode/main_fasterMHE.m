close all;
clc;
clear;
rng('default');

% 总rmse为0.0060
% US06 0.0018 BJDST 0.0024 DST 0.0019
P0 = diag([1E-2 1E-4 1E-6 1E-6 1E-6]);
Q = diag([1E-9 1E-1 1E-6 1E-6 1E-6]);
R = 1E-6;

MaxnHorizon = 3; % 窗口长度
nIter = 5; % 迭代次数
tDelta = 1; % 采样间隔
difflinThreshold = 1*1e-2; % 重线性化阈值

% 最佳ECM参数
OCVCoefficient = [6.22208224936665	-19.9093874725356	23.9813888880365	-12.6566652398929	3.29470483945726	3.24331426757604];
R0Coefficient = [-0.638251334079213	1.62884941926457	-1.60428494575084	0.773847519249399	-0.186716766043422	0.0893053439242714];
R1Coefficient = [7.74165845426853	-16.8812971745625	12.9989511660378	-4.16803502790232	0.507411992417779	0.00269896090704541];
C1Coefficient = [124589.171014214	-203175.870591128	92495.5796502545	-644.923846321636	-6863.33743847574	1877.25503452128];

Cn = 2*3600;

errorInitialEstimation = 0.4; % 初始估计SOC偏差（真实值SOC—初始估计值SOC）

% BJSTD faster MHE
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
T = size(SOCreal,1);

[SOCEst,SOC,SOCRMSE,meanTime,maxTime,relinFlag,diffVal,objValue] = fasterMHE(P0,Q,R,I,y,SOCreal,V1, ...
                                                        OCVCoefficient,R0Coefficient, ...
                                                        R1Coefficient,C1Coefficient,tDelta, ...
                                                        errorInitialEstimation,Cn, ...
                                                        MaxnHorizon,nIter,difflinThreshold);
BJDSTRealSOC = SOC;
BJDSTFasterMHESOC = SOCEst;
BJDSTFasterMHESOCRMSE = SOCRMSE;
BJDSTFasterMHEMeanTime = meanTime;
BJDSTFasterMHEMaxTime = maxTime;
BJDST_relinFlag = relinFlag;
BJDST_relinFreq = sum(sum(relinFlag))/(T*nIter);
BJDST_diffVal = mean(diffVal);


% US06 faster MHE
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
T = size(SOCreal,1);

[SOCEst,SOC,SOCRMSE,meanTime,maxTime,relinFlag,diffVal] = fasterMHE(P0,Q,R,I,y,SOCreal,V1, ...
                                                        OCVCoefficient,R0Coefficient, ...
                                                        R1Coefficient,C1Coefficient,tDelta, ...
                                                        errorInitialEstimation,Cn, ...
                                                        MaxnHorizon,nIter,difflinThreshold);
US06RealSOC = SOC;
US06FasterMHESOC = SOCEst;
US06FasterMHESOCRMSE = SOCRMSE;
US06FasterMHEMeanTime = meanTime;
US06FasterMHEMaxTime = maxTime;
US06_relinFlag = relinFlag;
US06_relinFreq = sum(sum(relinFlag))/(T*nIter);
US06_diffVal = diffVal;


% DST faster MHE
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
T = size(SOCreal,1);

[SOCEst,SOC,SOCRMSE,meanTime,maxTime,relinFlag,diffVal] = fasterMHE(P0,Q,R,I,y,SOCreal,V1, ...
                                                        OCVCoefficient,R0Coefficient, ...
                                                        R1Coefficient,C1Coefficient,tDelta, ...
                                                        errorInitialEstimation,Cn, ...
                                                        MaxnHorizon,nIter,difflinThreshold);
DSTRealSOC = SOC;
DSTFasterMHESOC = SOCEst;
DSTFasterMHESOCRMSE = SOCRMSE;
DSTFasterMHEMeanTime = meanTime;
DSTFasterMHEMaxTime = maxTime;
DST_relinFlag = relinFlag;
DST_diffVal = diffVal;
DST_relinFreq = sum(sum(relinFlag))/(T*nIter);


%% results
disp('Fast MHE-ETR RMSE');
disp([US06FasterMHESOCRMSE BJDSTFasterMHESOCRMSE DSTFasterMHESOCRMSE]);
disp('Average time');
disp([US06FasterMHEMeanTime BJDSTFasterMHEMeanTime DSTFasterMHEMeanTime]);
disp('Worst-case time');
disp([US06FasterMHEMaxTime BJDSTFasterMHEMaxTime DSTFasterMHEMaxTime]);

%%
figure;
subplot(1,3,1);
hold on;box on
plot(BJDSTRealSOC);
plot(BJDSTFasterMHESOC);
title('BJDST');

subplot(1,3,2);
hold on;box on
plot(US06RealSOC);
plot(US06FasterMHESOC);
title('US06');

subplot(1,3,3)
hold on;box on
plot(DSTRealSOC);
plot(DSTFasterMHESOC);
title('DST');
