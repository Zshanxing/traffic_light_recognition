%%
%��һ���֣�����λ����Ϣ������ȡ
clc; close all; clear all; 

I=imread('E:\��ҵ���ȫ������\��̹���\����ͼƬ\��������ͼ��\����\3.jpg');                 %��ָ��λ�ö�ȡͼƬ 
figure;
imshow(I);                                         %��ʾͼƬ
a=size(I,1);                                       %��ȡͼ��߶�
b=size(I,2);                                       %��ȡͼ����
im=imcrop(I,[0,0,b,a/2]);

figure;image(im) ;                                    %��ʾ��ȡ��ͼ��
% cd('E:\PSͼƬ\jiantou');                         
% imwrite(im,'light.jpg');                      %���������͵�ͼƬ

%%
%�ڶ����֣�RGB������ȡ
I=im; 
[m,n,d]=size(I); 
 
level=15;%������ֵ 
level2=60;%������ֵ 
 
for i=1:m 
    for j=1:n 
        if((I(i,j,1)-I(i,j,2)>level2)&&(I(i,j,1)-I(i,j,3)>level2)) 
            r(i,j,1)=I(i,j,1); 
            r(i,j,2)=I(i,j,2); 
            r(i,j,3)=I(i,j,3); 
       else  
            r(i,j,1)=0; 
            r(i,j,2)=0; 
            r(i,j,3)=0; 
        end 
    end 
end 
 
figure; 
subplot(2,2,1);imshow(I);title('ԭͼ��'); 
subplot(2,2,2);imshow(r);title('��ȡ�������');%��ʾ��ȡ��������ͼ 
% cd('E:\PSͼƬ\shuzi');
% imwrite(r,'hong.jpg');
%  
%��ȡ�̷�������������ֵ�ı�Ϊ��ɫ 
for i=1:m 
    for j=1:n 
        if((I(i,j,2)-I(i,j,1)>level)&&(I(i,j,2)-I(i,j,3)>level)) 
            g(i,j,1)=I(i,j,1); 
            g(i,j,2)=I(i,j,2); 
            g(i,j,3)=I(i,j,3); 
        else 
            g(i,j,1)=0; 
            g(i,j,2)=0; 
            g(i,j,3)=0; 
        end 
    end 
end 
 
subplot(2,2,3);imshow(g);title('��ȡ�̷�����'); 
%  cd('E:\PSͼƬ\shuzi');
% imwrite(g,'lv.jpg');
 
%��ȡ��ɫ���� 
for i=1:m 
    for j=1:n 
        if((I(i,j,1)-I(i,j,3)>level2)&&(I(i,j,2)-I(i,j,3)>level2)) 
                    b(i,j,1)=I(i,j,1); 
                    b(i,j,2)=I(i,j,2); 
                    b(i,j,3)=I(i,j,3); 
        else 
            b(i,j,1)=0; 
            b(i,j,2)=0; 
            b(i,j,3)=0; 
        end 
    end 
end 
 
subplot(2,2,4);imshow(b);title('��ȡ��ɫ������');
% cd('E:\PSͼƬ\shuzi');
% imwrite(b,'huang.jpg');

%%
%�������֣�ͼ��ҶȻ�����һ������ֵ��
%�ҶȻ�
A=r;
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
% cd('E:\PSͼƬ\shuzi');
% imwrite(BWa,'hongerzhi.jpg')

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


   if area<100
        pointList = status(i).PixelList;                     %ÿ����ͨ���������λ��
        rIndex=pointList(:,2);cIndex=pointList(:,1);
        pointList = status(i).PixelList;                     %��ͨ�������������
       img(rIndex,cIndex)=0; 
  end

end 
subplot(1,2,2);imshow(img);title('��ȡ���');hold on;
% cd('E:\PSͼƬ\shuzi');
% imwrite(img,'hongtiqu.jpg');

[labeled,n] = bwlabel(img);
status=regionprops(labeled,'BoundingBox','Area','PixelList');
centroid = regionprops(labeled,'Centroid','Area','PixelList');

% for i=1:n
%     rectangle('position',status(i).BoundingBox,'LineWidth',2,'LineStyle','--','EdgeColor','r'),
%     text(centroid(i,1).Centroid(1,1)-15,centroid(i,1).Centroid(1,2)-15, num2str(i),'Color', 'r') 
% end


im1=imcrop(img,[status(1).BoundingBox]);
figure;subplot(1,2,1);imshow(im1);
im2=imcrop(img,[status(2).BoundingBox]);
subplot(1,2,2);imshow(im2);

% cd('E:\PSͼƬ\shuzi');
% imwrite(im1,'11.jpg');
% imwrite(im2,'22.jpg');

%%
%���岿�֣��ֲ�ȡ��

A=im1; %����ͼ��                
figure;										%�½�ͼ�δ���
subplot(3,1,1);imshow(A);title('ԭͼ');                    %��ʾԭͼ������
B = imfill(A,'holes');                      %�Կ׶��������
C = B - A;                                  %�������ͼ����ԭͼ����
subplot(3,1,2);imshow(B);title('����')                     %��ʾ�����ͼ��
subplot(3,1,3);imshow(C); title('��ȡ���ͼ')            %��ʾ������ͼ��
% cd('E:\PSͼƬ\shuzi');
% imwrite(C,'11qufan.jpg');

a=im2; %����ͼ��                
figure;										%�½�ͼ�δ���
subplot(1,3,1);imshow(a);title('ԭͼ');                    %��ʾԭͼ������
b = imfill(a,'holes');                      %�Կ׶��������
c = b - a;                                  %�������ͼ����ԭͼ����
subplot(1,3,2);imshow(b); title('����')                     %��ʾ�����ͼ��
subplot(1,3,3);imshow(c); title('��ȡ���ͼ')            %��ʾ������ͼ��
% cd('E:\PSͼƬ\shuzi');
% imwrite(c,'22qufan.jpg');

se=strel('disk',4);
PZ=imdilate(C,se);
figure;
subplot(1,2,1);imshow(PZ);title('���ͽ��ͼ1') 
% cd('E:\PSͼƬ\shuzi');
% imwrite(PZ,'11liantong.jpg');

se=strel('line',4,90);
pz=imdilate(c,se);

subplot(1,2,2);imshow(pz);title('���ͽ��ͼ2') 
% cd('E:\PSͼƬ\shuzi');
% imwrite(pz,'22liantong.jpg');

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
A=pz;
bw2=~im2bw(A,0.2);
imshow(bw2);
figure;
bw_7050=imresize(bw2,[70,50]);
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
answer=find(A3==1);                                                           %ʶ������
figure;
plotchar(number(:,answer));