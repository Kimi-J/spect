clear;clc;%初始化
%%参数设置
num_lambda=1;%波长划分数量
lambda=linspace(1550e-9,1550e-9,num_lambda);%波长区间
num_wg=128;%波导数量
a=6.5e-6;%波导尺寸
d_wg=500e-6;%波导阵列间距
num_theta=100001;%观察角度数量
AE_in=zeros(1,num_wg)+1;%电场模
phi_in=zeros(1,num_wg);%每根波导的出射相位
phi_in=linspace(0,2*pi,num_wg);%不同波导的出射相位由0均匀变化到2pi
E_in=AE_in.*exp(1j*phi_in);%带相位出射电场
E_f=zeros(1,num_theta);%由某一出射角度聚焦干涉后得到的光强
theta=linspace(-5,5,num_theta).*pi/180;%观察角度范围（°）
delta=zeros(num_wg,num_theta);%不同波导在不同角度处产生的相位差
%%绘制波导的相位信息
figure;%新建绘图框
% scatter(1:num_wg,phi_in./pi);%绘制不同波导的出射相位
% title("初始相位分布");%添加图片标题
% xlabel("波导编号");%添加横坐标
% ylabel("相位(π rad)")%添加纵坐标
%%计算不同角度上的干涉强度
% figure;%新建绘图框
for k=1:num_lambda
    %单缝衍射因子
    alpha=pi*a*sin(theta)/lambda(k);
    name="波长 = "+num2str(lambda(k)*1e9)+" nm";%设置每条曲线的名称
    %%计算多光束干涉
    for i=1:num_wg
        for j=1:num_theta
            delta(i,j)=i*2*pi*d_wg*sin(theta(j))/lambda(k);%每个波导之间在一定角度上产生的光程差
        end
    end
    E_f=E_in*exp(1j*delta).*(sin(alpha)./alpha).^2;%每个角度上聚焦后的干涉光强
    
    plot(theta.*180/pi,abs(E_f).^2,'Displayname',name);%绘制观察角度与干涉光强的关系
    legend;%添加图例
    hold on%保持住曲线，下一次作图时不清除
end
title("干涉光强角分布")%添加标题
xlabel("角度（°）")%添加横坐标
ylabel("归一化光强")%添加纵坐标
xlim([min(theta)*180/pi max(theta)*180/pi])%选择横坐标范围
% ylim([-50 50]);