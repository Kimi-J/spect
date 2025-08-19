clear;clc;%��ʼ��
%%��������
num_lambda=1;%������������
lambda=linspace(1550e-9,1550e-9,num_lambda);%��������
num_wg=128;%��������
a=6.5e-6;%�����ߴ�
d_wg=500e-6;%�������м��
num_theta=100001;%�۲�Ƕ�����
AE_in=zeros(1,num_wg)+1;%�糡ģ
phi_in=zeros(1,num_wg);%ÿ�������ĳ�����λ
phi_in=linspace(0,2*pi,num_wg);%��ͬ�����ĳ�����λ��0���ȱ仯��2pi
E_in=AE_in.*exp(1j*phi_in);%����λ����糡
E_f=zeros(1,num_theta);%��ĳһ����ǶȾ۽������õ��Ĺ�ǿ
theta=linspace(-5,5,num_theta).*pi/180;%�۲�Ƕȷ�Χ���㣩
delta=zeros(num_wg,num_theta);%��ͬ�����ڲ�ͬ�Ƕȴ���������λ��
%%���Ʋ�������λ��Ϣ
figure;%�½���ͼ��
% scatter(1:num_wg,phi_in./pi);%���Ʋ�ͬ�����ĳ�����λ
% title("��ʼ��λ�ֲ�");%���ͼƬ����
% xlabel("�������");%��Ӻ�����
% ylabel("��λ(�� rad)")%���������
%%���㲻ͬ�Ƕ��ϵĸ���ǿ��
% figure;%�½���ͼ��
for k=1:num_lambda
    %������������
    alpha=pi*a*sin(theta)/lambda(k);
    name="���� = "+num2str(lambda(k)*1e9)+" nm";%����ÿ�����ߵ�����
    %%������������
    for i=1:num_wg
        for j=1:num_theta
            delta(i,j)=i*2*pi*d_wg*sin(theta(j))/lambda(k);%ÿ������֮����һ���Ƕ��ϲ����Ĺ�̲�
        end
    end
    E_f=E_in*exp(1j*delta).*(sin(alpha)./alpha).^2;%ÿ���Ƕ��Ͼ۽���ĸ����ǿ
    
    plot(theta.*180/pi,abs(E_f).^2,'Displayname',name);%���ƹ۲�Ƕ�������ǿ�Ĺ�ϵ
    legend;%���ͼ��
    hold on%����ס���ߣ���һ����ͼʱ�����
end
title("�����ǿ�Ƿֲ�")%��ӱ���
xlabel("�Ƕȣ��㣩")%��Ӻ�����
ylabel("��һ����ǿ")%���������
xlim([min(theta)*180/pi max(theta)*180/pi])%ѡ������귶Χ
% ylim([-50 50]);