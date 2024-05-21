% plot soc estimaes under different conditions

close all; 
clearvars; 
clc; 
%% 初值0.6
% errorInitialEstimation = 0.2; % 初始估计SOC偏差（真实值SOC—初始估计值SOC）
% main_ekf; 
% main_optimalMHE;
% main_fastMHE;
load('.\data_plot\EKF_SOCinit0.6.mat');
load('.\data_plot\OMHE_SOCinit0.6_horizon3.mat');
load('.\data_plot\FMHE_SOCinit0.6_horizon3_iter3.mat');
load('.\data_plot\FMHE_ETR_SOCinit0.6_horizon3_iter3.mat');
US06_real_6 = [US06RealSOC(1);US06RealSOC];
US06_jointEKF_6 = [US06RealSOC(1)-errorInitialEstimation;US06EKFSOC];
US06_jointMHEX_6 = [US06RealSOC(1)-errorInitialEstimation;US06RealtimeMHESOC];
US06_jointMHE_6 = [US06RealSOC(1)-errorInitialEstimation;US06ExactMHESOC];
US06_jointMHEFaster_6 = [US06RealSOC(1)-errorInitialEstimation;US06FasterMHESOC];

BJDST_real_6 = [BJDSTRealSOC(1);BJDSTRealSOC];
BJDST_jointEKF_6 = [BJDSTRealSOC(1)-errorInitialEstimation;BJDSTEKFSOC];
BJDST_jointMHEX_6 = [BJDSTRealSOC(1)-errorInitialEstimation;BJDSTRealtimeMHESOC];
BJDST_jointMHE_6 = [BJDSTRealSOC(1)-errorInitialEstimation;BJDSTExactMHESOC];
BJDST_jointMHEFaster_6 = [BJDSTRealSOC(1)-errorInitialEstimation;BJDSTFasterMHESOC];

DST_real_6 = [DSTRealSOC(1);DSTRealSOC];
DST_jointEKF_6 = [DSTRealSOC(1)-errorInitialEstimation;DSTEKFSOC];
DST_jointMHEX_6 = [DSTRealSOC(1)-errorInitialEstimation;DSTRealtimeMHESOC];
DST_jointMHE_6 = [DSTRealSOC(1)-errorInitialEstimation;DSTExactMHESOC];
DST_jointMHEFaster_6 = [DSTRealSOC(1)-errorInitialEstimation;DSTFasterMHESOC];

%% 初值0.4
% errorInitialEstimation = 0.4; % 初始估计SOC偏差（真实值SOC—初始估计值SOC）
% main;
load('.\data_plot\EKF_SOCinit0.4.mat');
load('.\data_plot\OMHE_SOCinit0.4_horizon3.mat');
load('.\data_plot\FMHE_SOCinit0.4_horizon3_iter3.mat');
load('.\data_plot\FMHE_ETR_SOCinit0.4_horizon3_iter3.mat');
US06_real_4 = [US06RealSOC(1);US06RealSOC];
US06_jointEKF_4 = [US06RealSOC(1)-errorInitialEstimation;US06EKFSOC];
US06_jointMHEX_4=[US06RealSOC(1)-errorInitialEstimation;US06RealtimeMHESOC];
US06_jointMHE_4=[US06RealSOC(1)-errorInitialEstimation;US06ExactMHESOC];
US06_jointMHEFaster_4=[US06RealSOC(1)-errorInitialEstimation;US06FasterMHESOC];

BJDST_real_4 = [BJDSTRealSOC(1);BJDSTRealSOC];
BJDST_jointEKF_4 = [BJDSTRealSOC(1)-errorInitialEstimation;BJDSTEKFSOC];
BJDST_jointMHEX_4=[BJDSTRealSOC(1)-errorInitialEstimation;BJDSTRealtimeMHESOC];
BJDST_jointMHE_4=[BJDSTRealSOC(1)-errorInitialEstimation;BJDSTExactMHESOC];
BJDST_jointMHEFaster_4=[BJDSTRealSOC(1)-errorInitialEstimation;BJDSTFasterMHESOC];

DST_real_4 = [DSTRealSOC(1);DSTRealSOC];
DST_jointEKF_4 = [DSTRealSOC(1)-errorInitialEstimation;DSTEKFSOC];
DST_jointMHEX_4=[DSTRealSOC(1)-errorInitialEstimation;DSTRealtimeMHESOC];
DST_jointMHE_4=[DSTRealSOC(1)-errorInitialEstimation;DSTExactMHESOC];
DST_jointMHEFaster_4=[DSTRealSOC(1)-errorInitialEstimation;DSTFasterMHESOC];

%% 初值0.2
% errorInitialEstimation = 0.6; % 初始估计SOC偏差（真实值SOC—初始估计值SOC）
% main;
load('.\data_plot\EKF_SOCinit0.2.mat');
load('.\data_plot\OMHE_SOCinit0.2_horizon3.mat');
load('.\data_plot\FMHE_SOCinit0.2_horizon3_iter3.mat');
load('.\data_plot\FMHE_ETR_SOCinit0.2_horizon3_iter3.mat');
US06_real_2 = [US06RealSOC(1);US06RealSOC];
US06_jointEKF_2 = [US06RealSOC(1)-errorInitialEstimation;US06EKFSOC];
US06_jointMHEX_2 = [US06RealSOC(1)-errorInitialEstimation;US06RealtimeMHESOC];
US06_jointMHE_2 = [US06RealSOC(1)-errorInitialEstimation;US06ExactMHESOC];
US06_jointMHEFaster_2 = [US06RealSOC(1)-errorInitialEstimation;US06FasterMHESOC];

BJDST_real_2 = [BJDSTRealSOC(1);BJDSTRealSOC];
BJDST_jointEKF_2 = [BJDSTRealSOC(1)-errorInitialEstimation;BJDSTEKFSOC];
BJDST_jointMHEX_2 = [BJDSTRealSOC(1)-errorInitialEstimation;BJDSTRealtimeMHESOC];
BJDST_jointMHE_2 = [BJDSTRealSOC(1)-errorInitialEstimation;BJDSTExactMHESOC];
BJDST_jointMHEFaster_2 = [BJDSTRealSOC(1)-errorInitialEstimation;BJDSTFasterMHESOC];

DST_real_2 = [DSTRealSOC(1);DSTRealSOC];
DST_jointEKF_2 = [DSTRealSOC(1)-errorInitialEstimation;DSTEKFSOC];
DST_jointMHEX_2=[DSTRealSOC(1)-errorInitialEstimation;DSTRealtimeMHESOC];
DST_jointMHE_2=[DSTRealSOC(1)-errorInitialEstimation;DSTExactMHESOC];
DST_jointMHEFaster_2=[DSTRealSOC(1)-errorInitialEstimation;DSTFasterMHESOC];


%% 初值1
% errorInitialEstimation = -0.2; % 初始估计SOC偏差（真实值SOC—初始估计值SOC）
% main;
load('.\data_plot\EKF_SOCinit1.mat');
load('.\data_plot\OMHE_SOCinit1_horizon3.mat');
load('.\data_plot\FMHE_SOCinit1_horizon3_iter3.mat');
load('.\data_plot\FMHE_ETR_SOCinit1_horizon3_iter3.mat');
US06_real_1 = [US06RealSOC(1);US06RealSOC];
US06_jointEKF_1 = [US06RealSOC(1)-errorInitialEstimation;US06EKFSOC];
US06_jointMHEX_1 = [US06RealSOC(1)-errorInitialEstimation;US06RealtimeMHESOC];
US06_jointMHE_1 = [US06RealSOC(1)-errorInitialEstimation;US06ExactMHESOC];
US06_jointMHEFaster_1 = [US06RealSOC(1)-errorInitialEstimation;US06FasterMHESOC];

BJDST_real_1 = [BJDSTRealSOC(1);BJDSTRealSOC];
BJDST_jointEKF_1 = [BJDSTRealSOC(1)-errorInitialEstimation;BJDSTEKFSOC];
BJDST_jointMHEX_1 = [BJDSTRealSOC(1)-errorInitialEstimation;BJDSTRealtimeMHESOC];
BJDST_jointMHE_1 = [BJDSTRealSOC(1)-errorInitialEstimation;BJDSTExactMHESOC];
BJDST_jointMHEFaster_1 = [BJDSTRealSOC(1)-errorInitialEstimation;BJDSTFasterMHESOC];

DST_real_1 = [DSTRealSOC(1);DSTRealSOC];
DST_jointEKF_1 = [DSTRealSOC(1)-errorInitialEstimation;DSTEKFSOC];
DST_jointMHEX_1=[DSTRealSOC(1)-errorInitialEstimation;DSTRealtimeMHESOC];
DST_jointMHE_1=[DSTRealSOC(1)-errorInitialEstimation;DSTExactMHESOC];
DST_jointMHEFaster_1=[DSTRealSOC(1)-errorInitialEstimation;DSTFasterMHESOC];
% save('data.mat');

color_orange = 	'#D95319';
color_green = 'c';

x = (0:9000);
figure
a = 0.23;b = 0.14;%a是宽，b是高
a1 = 0.1;b1 = 0.0625;%子图的宽和高
set(gcf,'position',[100 0 1000 1200])%后两个（宽和高）范围由分辨率限制
subplot(4,3,1);subplot('position',[0.065 0.81 a b] ); %无图例的图形
hold on;box on
plot(x,US06_real_6(1:9001),'Color','m','LineWidth',3);
plot(x,US06_jointEKF_6(1:9001),'--','Color','r','LineWidth',3);
plot(x,US06_jointMHE_6(1:9001),'-','Color','b','LineWidth',3);
plot(x,US06_jointMHEX_6(1:9001),'--','Color',color_green,'LineWidth',3);
plot(x,US06_jointMHEFaster_6(1:9001),'--','Color',color_orange,'LineWidth',2);
ylabel('SOC', 'Interpreter', 'latex','FontName','Times New Roman','FontSize',10);
xlabel('Time(s)', 'Interpreter', 'latex','FontName','Times New Roman','FontSize',10)
axis([0 300 0.6 0.81]);%axis([0 150 0.786 0.801]);
title({'(a) initial SOC guess $\hat{Z}_0 = 0.6$';'\quad \quad \quad \quad \quad \quad \quad  US06'}, 'Interpreter', 'latex','FontName','Times New Roman','FontSize',10)
ax = gca;ax.TitleHorizontalAlignment = 'left';
axes('Position',[0.165,0.83,a1,b1]); % 生成子图
hold on;box on
plot(x,US06_real_6(1:9001),'Color','m','LineWidth',3);
plot(x,US06_jointEKF_6(1:9001),'--','Color','r','LineWidth',3);
plot(x,US06_jointMHE_6(1:9001),'-','Color','b','LineWidth',3);
plot(x,US06_jointMHEX_6(1:9001),'--','Color',color_green,'LineWidth',3);   
plot(x,US06_jointMHEFaster_6(1:9001),'--','Color',color_orange,'LineWidth',2); 
axis([0 50 0.792 0.803]);

subplot(4,3,2);subplot('position',[0.38 0.81 a b] ); %无图例的图形
hold on;box on
plot(x,BJDST_real_6(1:9001),'Color','m','LineWidth',3);
plot(x,BJDST_jointEKF_6(1:9001),'--','Color','r','LineWidth',3);
plot(x,BJDST_jointMHE_6(1:9001),'-','Color','b','LineWidth',3);
plot(x,BJDST_jointMHEX_6(1:9001),'--','Color',color_green,'LineWidth',3);
plot(x,BJDST_jointMHEFaster_6(1:9001),'--','Color',color_orange,'LineWidth',2);
ylabel('SOC', 'Interpreter', 'latex','FontName','Times New Roman','FontSize',10);
xlabel('Time(s)', 'Interpreter', 'latex','FontName','Times New Roman','FontSize',10)
axis([0 300 0.6 0.81]);
title('BJDST', 'Interpreter', 'latex','FontName','Times New Roman','FontSize',10)
axes('Position',[0.48,0.83,a1,b1]); % 生成子图
hold on;box on
plot(x,BJDST_real_6(1:9001),'Color','m','LineWidth',3);
plot(x,BJDST_jointEKF_6(1:9001),'--','Color','r','LineWidth',3);
plot(x,BJDST_jointMHE_6(1:9001),'-','Color','b','LineWidth',3);
plot(x,BJDST_jointMHEX_6(1:9001),'--','Color',color_green,'LineWidth',3);
plot(x,BJDST_jointMHEFaster_6(1:9001),'--','Color',color_orange,'LineWidth',2);
axis([0 50 0.792 0.804]);

subplot(4,3,3);subplot('position',[0.7 0.81 a b] ); %无图例的图形
hold on;box on
plot(x,DST_real_6(1:9001),'Color','m','LineWidth',3);
plot(x,DST_jointEKF_6(1:9001),'--','Color','r','LineWidth',3);
plot(x,DST_jointMHE_6(1:9001),'-','Color','b','LineWidth',3);
plot(x,DST_jointMHEX_6(1:9001),'--','Color',color_green,'LineWidth',3);
plot(x,DST_jointMHEFaster_6(1:9001),'--','Color',color_orange,'LineWidth',2);
ylabel('SOC', 'Interpreter', 'latex','FontName','Times New Roman','FontSize',10);
xlabel('Time(s)', 'Interpreter', 'latex','FontName','Times New Roman','FontSize',10)
axis([0 300 0.6 0.81]);
subtitle('DST', 'Interpreter', 'latex','FontName','Times New Roman','FontSize',10)
axes('Position',[0.8,0.83,a1,b1]); % 生成子图
hold on;box on
plot(x,DST_real_6(1:9001),'Color','m','LineWidth',3);
plot(x,DST_jointEKF_6(1:9001),'--','Color','r','LineWidth',3);
plot(x,DST_jointMHE_6(1:9001),'-','Color','b','LineWidth',3);
plot(x,DST_jointMHEX_6(1:9001),'--','Color',color_green,'LineWidth',3);
plot(x,DST_jointMHEFaster_6(1:9001),'--','Color',color_orange,'LineWidth',2);
axis([0 50 0.788 0.804]);

subplot(4,3,4);subplot('position',[0.065 0.575 a b] ); %无图例的图形
hold on;box on
plot(x,US06_real_4(1:9001),'Color','m','LineWidth',3);
plot(x,US06_jointEKF_4(1:9001),'--','Color','r','LineWidth',3);
plot(x,US06_jointMHE_4(1:9001),'-','Color','b','LineWidth',3);
plot(x,US06_jointMHEX_4(1:9001),'--','Color',color_green,'LineWidth',3);
plot(x,US06_jointMHEFaster_4(1:9001),'--','Color',color_orange,'LineWidth',2);
ylabel('SOC', 'Interpreter', 'latex','FontName','Times New Roman','FontSize',10);
xlabel('Time(s)', 'Interpreter', 'latex','FontName','Times New Roman','FontSize',10)
axis([0 800 0.4 0.9]);
title({'(b) initial SOC guess $\hat{Z}_0 = 0.4$';'\quad \quad \quad \quad \quad \quad \quad  US06'}, 'Interpreter', 'latex','FontName','Times New Roman','FontSize',10)
ax = gca;ax.TitleHorizontalAlignment = 'left';
axes('Position',[0.165,0.595,a1,b1]); % 生成子图
hold on;box on
plot(x,US06_real_4(1:9001),'Color','m','LineWidth',3);
plot(x,US06_jointEKF_4(1:9001),'--','Color','r','LineWidth',3);
plot(x,US06_jointMHE_4(1:9001),'-','Color','b','LineWidth',3);     
plot(x,US06_jointMHEX_4(1:9001),'--','Color',color_green,'LineWidth',3);
plot(x,US06_jointMHEFaster_4(1:9001),'--','Color',color_orange,'LineWidth',2);
axis([450 550 0.751 0.76]);

subplot(4,3,5);subplot('position',[0.38 0.575 a b] ); %无图例的图形
hold on;box on;x=[0:1:9000];
plot(x,BJDST_real_4(1:9001),'Color','m','LineWidth',3);
plot(x,BJDST_jointEKF_4(1:9001),'--','Color','r','LineWidth',3);
plot(x,BJDST_jointMHE_4(1:9001),'-','Color','b','LineWidth',3);     
plot(x,BJDST_jointMHEX_4(1:9001),'--','Color',color_green,'LineWidth',3);
plot(x,BJDST_jointMHEFaster_4(1:9001),'--','Color',color_orange,'LineWidth',2);
axis([0 800 0.4 0.9]);
ylabel('SOC', 'Interpreter', 'latex','FontName','Times New Roman','FontSize',10);
xlabel('Time(s)', 'Interpreter', 'latex','FontName','Times New Roman','FontSize',10)
title('BJDST', 'Interpreter', 'latex','FontName','Times New Roman','FontSize',10)
axes('Position',[0.48,0.595,a1,b1]); % 生成子图
hold on;box on
plot(x,BJDST_real_4(1:9001),'Color','m','LineWidth',3);
plot(x,BJDST_jointEKF_4(1:9001),'--','Color','r','LineWidth',3);
plot(x,BJDST_jointMHE_4(1:9001),'-','Color','b','LineWidth',3);     
plot(x,BJDST_jointMHEX_4(1:9001),'--','Color',color_green,'LineWidth',3);
plot(x,BJDST_jointMHEFaster_4(1:9001),'--','Color',color_orange,'LineWidth',2);
axis([450 550 0.756 0.763]);

subplot(4,3,6);subplot('position',[0.70 0.575 a b] ); %无图例的图形
hold on;box on;x=[0:1:9000];
plot(x,DST_real_4(1:9001),'Color','m','LineWidth',3);
plot(x,DST_jointEKF_4(1:9001),'--','Color','r','LineWidth',3);
plot(x,DST_jointMHE_4(1:9001),'-','Color','b','LineWidth',3);
plot(x,DST_jointMHEX_4(1:9001),'--','Color',color_green,'LineWidth',3);
plot(x,DST_jointMHEFaster_4(1:9001),'--','Color',color_orange,'LineWidth',2);
axis([0 800 0.4 0.9]);
ylabel('SOC', 'Interpreter', 'latex','FontName','Times New Roman','FontSize',10);
xlabel('Time(s)', 'Interpreter', 'latex','FontName','Times New Roman','FontSize',10)
title('DST', 'Interpreter', 'latex','FontName','Times New Roman','FontSize',10)
axes('Position',[0.8,0.595,a1,b1]); % 生成子图
hold on;box on
plot(x,DST_real_4(1:9001),'Color','m','LineWidth',3);
plot(x,DST_jointEKF_4(1:9001),'--','Color','r','LineWidth',3);
plot(x,DST_jointMHE_4(1:9001),'-','Color','b','LineWidth',3);
plot(x,DST_jointMHEX_4(1:9001),'--','Color',color_green,'LineWidth',3);
plot(x,DST_jointMHEFaster_4(1:9001),'--','Color',color_orange,'LineWidth',2);
axis([450 550 0.75 0.76]);

subplot(4,3,7);subplot('position',[0.065 0.34 a b] );
hold on;box on
plot(x,US06_real_2(1:9001),'Color','m','LineWidth',3);
plot(x,US06_jointEKF_2(1:9001),'--','Color','r','LineWidth',3);
plot(x,US06_jointMHE_2(1:9001),'-','Color','b','LineWidth',3);
plot(x,US06_jointMHEX_2(1:9001),'--','Color',color_green,'LineWidth',3);
plot(x,US06_jointMHEFaster_2(1:9001),'--','Color',color_orange,'LineWidth',2);
ylabel('SOC', 'Interpreter', 'latex','FontName','Times New Roman','FontSize',10);
xlabel('Time(s)', 'Interpreter', 'latex','FontName','Times New Roman','FontSize',10)
axis([0 1000 0.2 0.9]);
title({'(c) initial SOC guess $\hat{Z}_0 = 0.2$';'\quad \quad \quad \quad \quad \quad \quad  US06'}, 'Interpreter', 'latex','FontName','Times New Roman','FontSize',10)
ax = gca;ax.TitleHorizontalAlignment = 'left';
axes('Position',[0.165,0.36,a1,b1]); % 生成子图
hold on;box on
plot(x,US06_real_2(1:9001),'Color','m','LineWidth',3);
plot(x,US06_jointEKF_2(1:9001),'--','Color','r','LineWidth',3);
plot(x,US06_jointMHE_2(1:9001),'-','Color','b','LineWidth',3);
plot(x,US06_jointMHEX_2(1:9001),'--','Color',color_green,'LineWidth',3);
plot(x,US06_jointMHEFaster_2(1:9001),'--','Color',color_orange,'LineWidth',2);
axis([450 550 0.75 0.761]);

subplot(4,3,8);subplot('position', [0.38 0.34 a b]); %无图例
hold on;box on;x=[0:1:9000];
plot(x,BJDST_real_2(1:9001),'Color','m','LineWidth',3);
plot(x,BJDST_jointEKF_2(1:9001),'--','Color','r','LineWidth',3);
plot(x,BJDST_jointMHE_2(1:9001),'-','Color','b','LineWidth',3);
plot(x,BJDST_jointMHEX_2(1:9001),'--','Color',color_green,'LineWidth',3);
plot(x,BJDST_jointMHEFaster_2(1:9001),'--','Color',color_orange,'LineWidth',2);
axis([0 2000 0.2 0.9]);
ylabel('SOC', 'Interpreter', 'latex','FontName','Times New Roman','FontSize',10);
xlabel('Time(s)', 'Interpreter', 'latex','FontName','Times New Roman','FontSize',10)
title('BJDST', 'Interpreter', 'latex','FontName','Times New Roman','FontSize',10)
axes('Position',[0.48,0.36,a1,b1]); % 生成子图
hold on;box on
plot(x,BJDST_real_2(1:9001),'Color','m','LineWidth',3);
plot(x,BJDST_jointEKF_2(1:9001),'--','Color','r','LineWidth',3);
plot(x,BJDST_jointMHE_2(1:9001),'-','Color','b','LineWidth',3);
plot(x,BJDST_jointMHEX_2(1:9001),'--','Color',color_green,'LineWidth',3);
plot(x,BJDST_jointMHEFaster_2(1:9001),'--','Color',color_orange,'LineWidth',2);
axis([200 400 0.758 0.79]);

subplot(4,3,9);subplot('position', [0.70 0.34 a b]); %无图例
hold on;box on;x=[0:1:9000];
plot(x,DST_real_2(1:9001),'Color','m','LineWidth',3);
plot(x,DST_jointEKF_2(1:9001),'--','Color','r','LineWidth',3);
plot(x,DST_jointMHE_2(1:9001),'-','Color','b','LineWidth',3);
plot(x,DST_jointMHEX_2(1:9001),'--','Color',color_green,'LineWidth',3);
plot(x,DST_jointMHEFaster_2(1:9001),'--','Color',color_orange,'LineWidth',2);
axis([0 1500 0.2 0.9]);
ylabel('SOC', 'Interpreter', 'latex','FontName','Times New Roman','FontSize',10);
xlabel('Time(s)', 'Interpreter', 'latex','FontName','Times New Roman','FontSize',10)
title('DST', 'Interpreter', 'latex','FontName','Times New Roman','FontSize',10)
axes('Position',[0.8,0.36,a1,b1]); % 生成子图
hold on;box on
plot(x,DST_real_2(1:9001),'Color','m','LineWidth',3);
plot(x,DST_jointEKF_2(1:9001),'--','Color','r','LineWidth',3);
plot(x,DST_jointMHE_2(1:9001),'-','Color','b','LineWidth',3);
plot(x,DST_jointMHEX_2(1:9001),'--','Color',color_green,'LineWidth',3);
plot(x,DST_jointMHEFaster_2(1:9001),'--','Color',color_orange,'LineWidth',2);
axis([200 400 0.753 0.784]);

subplot(4,3,10);subplot('position',[0.065 0.105 a b] ); %无图例的图形
hold on;box on
plot(x,US06_real_1(1:9001),'Color','m','LineWidth',3);
plot(x,US06_jointEKF_1(1:9001),'--','Color','r','LineWidth',3);
plot(x,US06_jointMHE_1(1:9001),'-','Color','b','LineWidth',3);
plot(x,US06_jointMHEX_1(1:9001),'--','Color',color_green,'LineWidth',3);
plot(x,US06_jointMHEFaster_1(1:9001),'--','Color',color_orange,'LineWidth',2);
ylabel('SOC', 'Interpreter', 'latex','FontName','Times New Roman','FontSize',10);
xlabel('Time(s)', 'Interpreter', 'latex','FontName','Times New Roman','FontSize',10)
axis([0 1000 0.7 1]);
title({'(d) initial SOC guess $\hat{Z}_0 = 1.0$';'\quad \quad \quad \quad \quad \quad \quad  US06'}, 'Interpreter', 'latex','FontName','Times New Roman','FontSize',10)
ax = gca;ax.TitleHorizontalAlignment = 'left';
axes('Position',[0.165,0.165,a1,b1]); % 生成子图
hold on;box on
plot(x,US06_real_1(1:9001),'Color','m','LineWidth',3);
plot(x,US06_jointEKF_1(1:9001),'--','Color','r','LineWidth',3);
plot(x,US06_jointMHE_1(1:9001),'-','Color','b','LineWidth',3);
plot(x,US06_jointMHEX_1(1:9001),'--','Color',color_green,'LineWidth',3);
plot(x,US06_jointMHEFaster_1(1:9001),'--','Color',color_orange,'LineWidth',2);
axis([550 650 0.748 0.76]);


subplot(4,3,11);subplot('position', [0.38 0.105 a b]); %无图例
hold on;box on;x=[0:1:9000];
plot(x,BJDST_real_1(1:9001),'Color','m','LineWidth',3);
plot(x,BJDST_jointEKF_1(1:9001),'--','Color','r','LineWidth',3);
plot(x,BJDST_jointMHE_1(1:9001),'-','Color','b','LineWidth',3);
plot(x,BJDST_jointMHEX_1(1:9001),'--','Color',color_green,'LineWidth',3);
plot(x,BJDST_jointMHEFaster_1(1:9001),'--','Color',color_orange,'LineWidth',2);
axis([0 1000 0.7 1]);
ylabel('SOC', 'Interpreter', 'latex','FontName','Times New Roman','FontSize',10);
xlabel('Time(s)', 'Interpreter', 'latex','FontName','Times New Roman','FontSize',10)
title('BJDST', 'Interpreter', 'latex','FontName','Times New Roman','FontSize',10)
axes('Position',[0.48,0.165,a1,b1]); % 生成子图
hold on;box on
plot(x,BJDST_real_1(1:9001),'Color','m','LineWidth',3);
plot(x,BJDST_jointEKF_1(1:9001),'--','Color','r','LineWidth',3);
plot(x,BJDST_jointMHE_1(1:9001),'-','Color','b','LineWidth',3);
plot(x,BJDST_jointMHEX_1(1:9001),'--','Color',color_green,'LineWidth',3);
plot(x,BJDST_jointMHEFaster_1(1:9001),'--','Color',color_orange,'LineWidth',2);
axis([40 140 0.788 0.80]);

subplot(4,3,12);subplot('position', [0.70 0.105 a b]); %无图例
hold on;box on;x=[0:1:9000];
plot(x,DST_real_1(1:9001),'Color','m','LineWidth',3);
plot(x,DST_jointEKF_1(1:9001),'--','Color','r','LineWidth',3);
plot(x,DST_jointMHE_1(1:9001),'-','Color','b','LineWidth',3);
plot(x,DST_jointMHEX_1(1:9001),'--','Color',color_green,'LineWidth',3);
plot(x,DST_jointMHEFaster_1(1:9001),'--','Color',color_orange,'LineWidth',2);
axis([0 1000 0.7 1]);
ylabel('SOC', 'Interpreter', 'latex','FontName','Times New Roman','FontSize',10);
xlabel('Time(s)', 'Interpreter', 'latex','FontName','Times New Roman','FontSize',10)
title('DST', 'Interpreter', 'latex','FontName','Times New Roman','FontSize',10)
axes('Position',[0.8,0.165,a1,b1]); % 生成子图
hold on;box on
plot(x,DST_real_1(1:9001),'Color','m','LineWidth',3);
plot(x,DST_jointEKF_1(1:9001),'--','Color','r','LineWidth',3);
plot(x,DST_jointMHE_1(1:9001),'-','Color','b','LineWidth',3);
plot(x,DST_jointMHEX_1(1:9001),'--','Color',color_green,'LineWidth',3);
plot(x,DST_jointMHEFaster_1(1:9001),'--','Color',color_orange,'LineWidth',2);
axis([50 150 0.782 0.79]);

h=legend({'real SOC','jEKF','optimal jMHE','fast jMHE','fast jMHE-ETR'},'Orientation','horizon','Location','southoutside');legend boxoff;
set(h, 'Position', [0.25,0.0005,0.5,.05]);
set(h,'FontName','Times New Roman','FontSize',12,'FontWeight','normal')
