%%
%��һ���֣�����λ����Ϣ������ȡ
clc; close all; clear all; 

I=imread('C:\Users\zsx\Desktop\��ҵ��Ʋ���\��������ͼ��\����\5.jpg');                 %��ָ��λ�ö�ȡͼƬ 
figure;
imshow(I);                                                               %��ʾͼƬ
a=size(I,1);                                                             %��ȡͼ��߶�
b=size(I,2);                                                             %��ȡͼ����
im=imcrop(I,[0,0,b,a/2]);
figure;image(im) ;                                                       %��ʾ��ȡ��ͼ��

%%
%�ڶ����֣�RGB������ȡ
%�ڶ����֣�������ɫ��ȡ�����̻���ɫ��ȡ��

B=im;
[m,n,d]=size(B); 
 
level=20;                                            %������ֵ 
level2=80;                                           %������ֵ 
 
%��ȡ�����
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
subplot(2,2,1);imshow(im);title('ԭͼ��'); 

subplot(2,2,2);imshow(Ba);title('��ȡ�������');     %��ʾ��ȡ��������ͼ 
% cd('E:\PSͼƬ\yuanxing');
% imwrite(r,'hong.jpg');
  
%��ȡ�̷���
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
subplot(2,2,3);imshow(Bb);title('��ȡ�̷�����');      %��ʾ��ȡ�̷������ͼ 
% cd('E:\PSͼƬ\yuanxing');
% imwrite(g,'lv.jpg');
 
%%��ȡ�Ʒ���
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
subplot(2,2,4);imshow(Bc);title('��ȡ��ɫ������');     %��ʾ��ȡ�Ʒ������ͼ 
% cd('E:\PSͼƬ\yuanxing');
% imwrite(b,'huang.jpg');

%%
%�������֣�ͼ��ҶȻ�����һ������ֵ��
%�ҶȻ�
A=Ba;
a=rgb2gray(A);
figure;
subplot(2,2,1);imshow(A);title('ԭͼ');
subplot(2,2,2);imshow(a);title('�Ҷ�ͼ');
%��һ��
originalMinValue = min(min(min(a)));
originalMaxValue = max(max(max(a)));
originalRange = originalMaxValue - originalMinValue;
dblImageS1 = double(1. * (a - originalMinValue) / originalRange);

subplot(2,2,3);imshow(dblImageS1);title('��һ��');
%��ֵ��
level = graythresh(dblImageS1);
BWa=im2bw(dblImageS1,level);

subplot(2,2,4);imshow(BWa);title('��ֵͼ');

%%
%���Ĳ��֣���ͨ��������ȡ

img=BWa; %��ȡԭͼ��
%ͳ�Ʊ�ע��ͨ��
%ʹ����Ӿ��ο�ѡ��ͨ�򣬲�ʹ������ȷ����ͨ��λ��
[labeled,m] = bwlabel(img);
status=regionprops(labeled,'BoundingBox','Area','PixelList');
centroid = regionprops(labeled,'Centroid','Area','PixelList');

figure;
subplot(1,2,1);imshow(img);title('��ǽ��');hold on;
for i=1:m
    rectangle('position',status(i).BoundingBox,'LineWidth',2,'LineStyle','--','EdgeColor','r'),
    text(centroid(i,1).Centroid(1,1)-15,centroid(i,1).Centroid(1,2)-15, num2str(i),'Color', 'r') 
    area=status(i).Area;
 
   if (area<150 || area>600)
        pointList = status(i).PixelList;                     %ÿ����ͨ���������λ��
        rIndex=pointList(:,2);cIndex=pointList(:,1);
        pointList = status(i).PixelList;                     %��ͨ�������������
       img(rIndex,cIndex)=0; 
  end

end 
subplot(1,2,2);imshow(img);title('��ȡ���');hold on;

[labeled,n] = bwlabel(img);
status=regionprops(labeled,'BoundingBox','Area','PixelList');
centroid = regionprops(labeled,'Centroid','Area','PixelList');

for i=1:n                                                                                         %ͼ��ָ�
    rectangle('position',status(i).BoundingBox,'LineWidth',2,'LineStyle','--','EdgeColor','r'),
    text(centroid(i,1).Centroid(1,1)-15,centroid(i,1).Centroid(1,2)-15, num2str(i),'Color', 'r') 
end

im1=imcrop(img,[status(1).BoundingBox]);
figure;subplot(1,2,1);imshow(im1);
%         im2=imcrop(img,[status(2).BoundingBox]);
%         subplot(1,2,2);imshow(im2);

%%
%BP����������ʶ��

%�����������
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
       plotchar(number(:,i));%��������
       
end  
grid on;

%����ʶ��
clear all;
%���紴��
load data;
[R,Q]=size(number);
P=number;
T=targets;
% NodeNum=2;
NodeNum=12; %������ڵ�

BTF='traingdx'; %��ѧϰ�ʶ����ݶ��½��㷨   ����ʽѧϰ�㷨

TF1='logsig';%�����㴫�ݺ���
TF2='logsig';%����㴫�ݺ���

BLF='learngdm';
TypeNum=10;%�����ڵ�

net=newff(minmax(P),[NodeNum,TypeNum],{TF1,TF2},BTF,BLF);
net.LW{1,1}=net.LW{1,1}*0.01;                                        %����Ȩֵ  
net.b{1}=net.b{1}*0.01;                                              %1��ʾ������������֮�����ֵ
net.LW{2,1}=net.LW{2,1}*0.01;                                        %2��ʾ����������֮���Ȩֵ 1��ʾ��һ����������
net.b{2}=net.b{2}*0.01;                                              %������ֵ,ʹ�ó�ʼȨֵ�㹻С���ӿ�ѧϰ����
%����ѵ��
net.trainParam.goal=0.001;                                           %ѧϰĿ��
net.trainParam.epochs=5000;                                          %��������
net=train(net,P,T);
%�������
A=sim(net,P);                                                        %��ʱ��������Ǳ�׼��0-1ֵ����Ҫʹ��compet�������е���
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
number_noise=lett';                                                        %����������������ֵ
plotchar(number_noise);                                                    %������������������Ӧ����

%����ʶ����
A3=sim(net,number_noise);
A3=compet(A3);
answer=find(A3);                                                           %ʶ������
figure;
plotchar(number(:,answer));