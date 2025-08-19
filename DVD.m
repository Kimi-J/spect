clear;clc;%��ʼ��
%���ò���
lambda_start=380e-9;%��ʼ����
lambda_end=780e-9;%��������
theta_start=-90;%�۲쿪ʼ�Ƕ�
theta_end=90;%�۲�����Ƕ�
theta_in=22.5;%����ǣ��㣩
N=5;%��դ��������
d=740e-9;%��դ��������DVD���Ӽ��
ratio=0.5;%ռ�ձȣ�͹���ȳ��԰��ݿ��
num_lambda=10;%������������
num_theta=10001;%�۲�ǶȻ�������
%���ü������
a=d*ratio;%��դ�����ͻ����
theta_in=theta_in*pi/180;%�����ת���ɻ�����
lambda=linspace(lambda_end,lambda_start,num_lambda);%��������
theta=linspace(theta_start*pi/180,theta_end*pi/180,num_theta);%�۲�Ƕ�����
I=zeros(num_lambda,num_theta);%��ǿ����
%%��ʼ����
for i=1:num_lambda
    for j=1:num_theta
        alpha(i,j)=pi*a*sin(theta(j))/lambda(i);%��������������ز���
        delta(i,j)=2*pi*d/lambda(i)*( sin(theta_in) + sin(theta(j)) );%����������λ��
        I(i,j)=( sin(alpha(i,j))/alpha(i,j) )^2*( sin(N*delta(i,j)/2)/sin(delta(i,j)/2) )^2;%����ÿ�������͹۲�Ƕȴ��Ĺ�ǿ
        if(alpha(i,j)*delta(i,j)==0)
            I(i,j)=I(i,j-1);%��֤������
        end
    end
end
I0=max(max(I));%��һ��
cmap = colormap(hsv(num_lambda)); % ʹ��hsv���ݲ��������γɲʺ罥��
for i=1:num_lambda
    name=strcat("���� = ",num2str(lambda(i)*1e9)," nm");
    plot(theta*180/pi,I(i,:)/I0,"LineWidth", 1.5, "Color", cmap(i, :),"DisplayName",name);%���ƹ۲�Ƕȶ�Ӧ�Ĺ�һ����ǿ��ͼ
    legend
    hold on
end
xlabel("����Ƕȣ��㣩");
ylabel("��һ����ǿI/I0");
title("��դ������ɫɢ����");