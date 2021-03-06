%%
%第一部分：基于位置信息初步提取
clc; close all; clear all; 

I=imread('C:\Users\zsx\Desktop\毕业设计测试\测试样本图像\数字\5.jpg');                 %从指定位置读取图片 
figure;
imshow(I);                                                               %显示图片
a=size(I,1);                                                             %获取图像高度
b=size(I,2);                                                             %获取图像宽度
im=imcrop(I,[0,0,b,a/2]);
figure;image(im) ;                                                       %显示获取的图像

%%
%第二部分：RGB分量提取
%第二部分：基于颜色提取（红绿黄三色提取）

B=im;
[m,n,d]=size(B); 
 
level=20;                                            %设置阈值 
level2=80;                                           %设置阈值 
 
%提取红分量
for i=1:m 
    for j=1:n 
        if((B(i,j,1)-B(i,j,2)<level2)||(B(i,j,1)-B(i,j,3)<level2)) 
 
            B(i,j,1)=0; 
            B(i,j,2)=0; 
            B(i,j,3)=0; 
        end 
    end 
end 
Ba=B; 
figure; 
subplot(2,2,1);imshow(im);title('原图像'); 

subplot(2,2,2);imshow(Ba);title('提取红分量后');     %显示提取红分量后的图 
% cd('E:\PS图片\yuanxing');
% imwrite(r,'hong.jpg');
  
%提取绿分量
B=im;
for i=1:m 
    for j=1:n 
        if((B(i,j,2)-B(i,j,1)<level)||(B(i,j,2)-B(i,j,3)<level)) 
%             g(i,j,1)=B(i,j,1); 
%             g(i,j,2)=B(i,j,2); 
%             g(i,j,3)=B(i,j,3); 
%         else 
            B(i,j,1)=0; 
            B(i,j,2)=0; 
            B(i,j,3)=0; 
        end 
    end 
end 
Bb=B;
subplot(2,2,3);imshow(Bb);title('提取绿分量后');      %显示提取绿分量后的图 
% cd('E:\PS图片\yuanxing');
% imwrite(g,'lv.jpg');
 
%%提取黄分量
B=im;
for i=1:m 
    for j=1:n 
        if((B(i,j,1)-B(i,j,3)<level2)||(B(i,j,2)-B(i,j,3)<level2)) 
                    b(i,j,1)=B(i,j,1); 
                    b(i,j,2)=B(i,j,2); 
                    b(i,j,3)=B(i,j,3); 
        else 
            B(i,j,1)=0; 
            B(i,j,2)=0; 
            B(i,j,3)=0; 
        end 
    end 
end 
Bc=B; 
subplot(2,2,4);imshow(Bc);title('提取黄色分量后');     %显示提取黄分量后的图 
% cd('E:\PS图片\yuanxing');
% imwrite(b,'huang.jpg');

%%
%第三部分：图像灰度化、归一化、二值化
%灰度化
A=Ba;
a=rgb2gray(A);
figure;
subplot(2,2,1);imshow(A);title('原图');
subplot(2,2,2);imshow(a);title('灰度图');
%归一化
originalMinValue = min(min(min(a)));
originalMaxValue = max(max(max(a)));
originalRange = originalMaxValue - originalMinValue;
dblImageS1 = double(1. * (a - originalMinValue) / originalRange);

subplot(2,2,3);imshow(dblImageS1);title('归一化');
%二值化
level = graythresh(dblImageS1);
BWa=im2bw(dblImageS1,level);

subplot(2,2,4);imshow(BWa);title('二值图');

%%
%第四部分：连通区域标记提取

img=BWa; %读取原图像
%统计标注连通域
%使用外接矩形框选连通域，并使用形心确定连通域位置
[labeled,m] = bwlabel(img);
status=regionprops(labeled,'BoundingBox','Area','PixelList');
centroid = regionprops(labeled,'Centroid','Area','PixelList');

figure;
subplot(1,2,1);imshow(img);title('标记结果');hold on;
for i=1:m
    rectangle('position',status(i).BoundingBox,'LineWidth',2,'LineStyle','--','EdgeColor','r'),
    text(centroid(i,1).Centroid(1,1)-15,centroid(i,1).Centroid(1,2)-15, num2str(i),'Color', 'r') 
    area=status(i).Area;
 
   if (area<150 || area>600)
        pointList = status(i).PixelList;                     %每个连通区域的像素位置
        rIndex=pointList(:,2);cIndex=pointList(:,1);
        pointList = status(i).PixelList;                     %连通区域的像素坐标
       img(rIndex,cIndex)=0; 
  end

end 
subplot(1,2,2);imshow(img);title('提取结果');hold on;

[labeled,n] = bwlabel(img);
status=regionprops(labeled,'BoundingBox','Area','PixelList');
centroid = regionprops(labeled,'Centroid','Area','PixelList');

for i=1:n                                                                                         %图像分割
    rectangle('position',status(i).BoundingBox,'LineWidth',2,'LineStyle','--','EdgeColor','r'),
    text(centroid(i,1).Centroid(1,1)-15,centroid(i,1).Centroid(1,2)-15, num2str(i),'Color', 'r') 
end

im1=imcrop(img,[status(1).BoundingBox]);
figure;subplot(1,2,1);imshow(im1);
%         im2=imcrop(img,[status(2).BoundingBox]);
%         subplot(1,2,2);imshow(im2);

%%
%BP神经网络数字识别

%输入输出数据
number=[1 1 1 1 1 1 0 0 0 1 1 0 0 0 1 1 0 0 0 1 1 0 0 0 1 1 0 0 0 1 1 1 1 1 1;%0
     0 0 1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1 0 0;%1
     1 1 1 1 1 0 0 0 0 1 0 0 0 0 1 1 1 1 1 1 1 0 0 0 0 1 0 0 0 0 1 1 1 1 1;%2
     1 1 1 1 1 0 0 0 0 1 0 0 0 0 1 1 1 1 1 1 0 0 0 0 1 0 0 0 0 1 1 1 1 1 1;%3
     1 0 0 0 1 1 0 0 0 1 1 0 0 0 1 1 1 1 1 1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1;%4
     1 1 1 1 1 1 0 0 0 0 1 0 0 0 0 1 1 1 1 1 0 0 0 0 1 0 0 0 0 1 1 1 1 1 1;%5
     1 1 1 1 1 1 0 0 0 0 1 0 0 0 0 1 1 1 1 1 1 0 0 0 1 1 0 0 0 1 1 1 1 1 1;%6
     1 1 1 1 1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1;%7
     1 1 1 1 1 1 0 0 0 1 1 0 0 0 1 1 1 1 1 1 1 0 0 0 1 1 0 0 0 1 1 1 1 1 1;%8
     1 1 1 1 1 1 0 0 0 1 1 0 0 0 1 1 1 1 1 1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1];%9
  
number=number';
targets=eye(10);
save data
figure;
for i=1:10
       subplot(2,5,i);
       plotchar(number(:,i));%画出数字
       
end  
grid on;

%数字识别
clear all;
%网络创建
load data;
[R,Q]=size(number);
P=number;
T=targets;
% NodeNum=2;
NodeNum=12; %隐含层节点

BTF='traingdx'; %变学习率动量梯度下降算法   启发式学习算法

TF1='logsig';%隐含层传递函数
TF2='logsig';%输出层传递函数

BLF='learngdm';
TypeNum=10;%输出层节点

net=newff(minmax(P),[NodeNum,TypeNum],{TF1,TF2},BTF,BLF);
net.LW{1,1}=net.LW{1,1}*0.01;                                        %调整权值  
net.b{1}=net.b{1}*0.01;                                              %1表示在隐层和输出层之间的阈值
net.LW{2,1}=net.LW{2,1}*0.01;                                        %2表示隐层和输出层之间的权值 1表示第一个输入向量
net.b{2}=net.b{2}*0.01;                                              %调整阈值,使得初始权值足够小，加快学习速率
%网络训练
net.trainParam.goal=0.001;                                           %学习目标
net.trainParam.epochs=5000;                                          %迭代次数
net=train(net,P,T);
%网络测试
A=sim(net,P);                                                        %此时输出并不是标准的0-1值，需要使用compet函数进行调整
AA=compet(A);

figure;
A=im1;
bw2=~im2bw(A,0.2);
imshow(bw2);
bw_7050=imresize(bw2,[70,50]);
figure;
imshow(bw_7050);
for i=1:length(A)
for cnt=1:7
    for cnt2=1:5
        Atemp=sum(bw_7050(((cnt*10-9):(cnt*10)),((cnt2*10-9):(cnt2*10))));%10*10box
        lett((cnt-1)*5+cnt2)=sum(Atemp);
    end
end
lett=((100-lett)/100);


end
for i=1:35
     if lett(i)<0.5
         lett(i)=0;
     else
         lett(i)=1;
     end
end

figure;
number_noise=lett';                                                        %将样本特征向量赋值
plotchar(number_noise);                                                    %画出样本特征向量对应数字

%画出识别结果
A3=sim(net,number_noise);
A3=compet(A3);
answer=find(A3);                                                           %识别数字
figure;
plotchar(number(:,answer));