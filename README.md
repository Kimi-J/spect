# 简介
光谱芯片的MATLAB模拟程序。紫金计划中的研究过程性内容，现在Github开源。
A simulation of the output of spectroscopy chip. This is the procedural research content of our "Zijin" Project, now open-sourced on GitHub.


# Output_Simulation.m
## 重要参数设置举例
### 观察光谱芯片实际输出的图像（单波长、多波峰、大视角）
```
num_lambda=1;%波长划分数量
lambda=linspace(1550e-9,1550e-9,num_lambda);%波长区间
theta=linspace(-5,5,num_theta).*pi/180;%观察角度范围（°）
```

### 微调观察波长对图像的偏移效果（多波长、微视角、决定分辨率关键因素）
```
num_lambda=11;%波长划分数量
lambda=linspace(1550e-9,1560e-9,num_lambda);%波长区间
theta=linspace(0.174,0.180,num_theta).*pi/180;%观察角度范围（°）
```
# DVD.m
过程性研究，模拟我们制作的简易光谱仪的输出。此简易光谱仪以废弃DVD为原材料。
## 重要参数
光栅常数，即DVD凹坑间距：`d=740e-9;`
此参数根据选用的不同种类光盘必须更改。（我们选用了DVD）
| 光盘种类        | 凹槽间距(nm)    |
| --------   | ------   |
| DVD     | 740 |
| CD        |  1600  |
| BD     |    320    |
# Soap.m
本研究中的创新性设计：将上述简易光谱仪中的光盘（经典光栅）替换为液体的肥皂膜，利用薄膜干涉。此项目的模拟未能在项目期限内完成开发。
