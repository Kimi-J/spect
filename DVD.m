clear;clc;%初始化
%设置参数
lambda_start=380e-9;%起始波长
lambda_end=780e-9;%结束波长
theta_start=-90;%观察开始角度
theta_end=90;%观察结束角度
theta_in=22.5;%入射角（°）
N=5;%光栅条纹数量
d=740e-9;%光栅常数，即DVD凹坑间距
ratio=0.5;%占空比，凸起宽度除以凹陷宽度
num_lambda=10;%波长划分数量
num_theta=10001;%观察角度划分数量
%设置计算变量
a=d*ratio;%光栅缝宽，即突起宽度
theta_in=theta_in*pi/180;%入射角转换成弧度制
lambda=linspace(lambda_end,lambda_start,num_lambda);%波长数组
theta=linspace(theta_start*pi/180,theta_end*pi/180,num_theta);%观察角度数组
I=zeros(num_lambda,num_theta);%光强数组
%%开始计算
for i=1:num_lambda
    for j=1:num_theta
        alpha(i,j)=pi*a*sin(theta(j))/lambda(i);%单缝衍射因子相关参数
        delta(i,j)=2*pi*d/lambda(i)*( sin(theta_in) + sin(theta(j)) );%多缝引入的相位差
        I(i,j)=( sin(alpha(i,j))/alpha(i,j) )^2*( sin(N*delta(i,j)/2)/sin(delta(i,j)/2) )^2;%计算每个波长和观察角度处的光强
        if(alpha(i,j)*delta(i,j)==0)
            I(i,j)=I(i,j-1);%保证连续性
        end
    end
end
I0=max(max(I));%归一化
cmap = colormap(hsv(num_lambda)); % 使用hsv根据波长数量形成彩虹渐变
for i=1:num_lambda
    name=strcat("波长 = ",num2str(lambda(i)*1e9)," nm");
    plot(theta*180/pi,I(i,:)/I0,"LineWidth", 1.5, "Color", cmap(i, :),"DisplayName",name);%绘制观察角度对应的归一化光强的图
    legend
    hold on
end
xlabel("衍射角度（°）");
ylabel("归一化光强I/I0");
title("光栅光谱仪色散曲线");