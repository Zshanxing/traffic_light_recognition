%%
%��һ���֣�����ROI��ȡ
clc; close all; clear all; 

I=imread('E:\��ҵ���ȫ������\��̹���\����ͼƬ\��������ͼ��\����\2.jpg');              %��ָ��λ�ö�ȡͼƬ 
figure;
imshow(I);                         %��ʾͼƬ
a=size(I,1);                                       %��ȡͼ��߶�
b=size(I,2);                                       %��ȡͼ����
im=imcrop(I,[0,0,b,a*2/3]);

figure;image(im) ;                                    %��ʾ��ȡ��ͼ��
% cd('E:\PSͼƬ\jiantou');                         
% imwrite(im,'light.jpg');                      %���������͵�ͼƬ

%%
%�ڶ����֣�������ɫ��ȡ

B=im;
[m,n,d]=size(B); 
 
level=20;%������ֵ 
level2=80;%������ֵ 

%��ȡ�����
B=im;
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

subplot(2,2,2);imshow(Ba);title('��ȡ�������');%��ʾ��ȡ��������ͼ 
% cd('E:\PSͼƬ\jiantou');
% imwrite(r,'hong.jpg');
 
%��ȡ�̷�������������ֵ�ı�Ϊ��ɫ 
B=im;
for i=1:m 
    for j=1:n 
        if((B(i,j,2)-B(i,j,1)<level)||(B(i,j,2)-B(i,j,3)<level)) 
          
            B(i,j,1)=0; 
            B(i,j,2)=0; 
            B(i,j,3)=0; 
        end 
    end 
end 
 Bb=B;
subplot(2,2,3);imshow(Bb);title('��ȡ�̷�����'); 
%  cd('E:\PSͼƬ\jiantou');
% imwrite(g,'lv.jpg');
 
%��ȡ�Ʒ�������������ֵ�ı�Ϊ��ɫ  
B=im;
for i=1:m 
    for j=1:n 
        if((B(i,j,1)-B(i,j,3)<level2)||(B(i,j,2)-B(i,j,3)<level2)) 
              
            B(i,j,1)=0; 
            B(i,j,2)=0; 
            B(i,j,3)=0; 
        end 
    end 
end 
 Bc=B;
subplot(2,2,4);imshow(Bc);title('��ȡ��ɫ������');
% cd('E:\PSͼƬ\jiantou');
% imwrite(b,'huang.jpg');

%%
%�������֣�ͼ��ҶȻ�����һ������ֵ��

A=Bb;
%�ҶȻ�
a=rgb2gray(A);
figure;
subplot(2,2,1);imshow(A);title('ԭͼ');
subplot(2,2,2);imshow(a);title('�Ҷ�ͼ');
cd('E:\PSͼƬ\jiantou');
imwrite(a,'lvhui.jpg');

%��һ��
originalMinValue = min(min(min(a)));
originalMaxValue = max(max(max(a)));
originalRange = originalMaxValue - originalMinValue;
dblImageS1 = double(1. * (a - originalMinValue) / originalRange);

subplot(2,2,3);imshow(dblImageS1);title('��һ��');

%��ֵ��
level = graythresh(dblImageS1);
BWa=im2bw(dblImageS1,level);

subplot(2,2,4);imshow(BWa);title('��ֵ��');
% cd('E:\PSͼƬ\jiantou');
% imwrite(BWa,'lverzhi.jpg');

%%
%���Ĳ��֣���ͷ��״����
se=strel('disk',1);
BW=imdilate(BWa,se);
figure;
imshow(BW);title('��ͷ��״����');
% % cd('E:\PSͼƬ\jiantou');
% % imwrite(BW,'lvbuchong.jpg');
% 
% se=strel('disk',2);
% erodedBW2=imerode(BW2,se);
% figure;
% imshow(erodedBW2);title('lvfushi');
% % cd('E:\PSͼƬ\jiantou');
% % imwrite(erodedBW2,'lvfushi.jpg');

%%
%���岿�֣���Ӿ��γ��������ȡ

%ͳ�Ʊ�ע��ͨ��
%ʹ����Ӿ��ο�ѡ��ͨ�򣬲�ʹ������ȷ����ͨ��λ��

[labeled,m] = bwlabel(BW);
stats=regionprops(labeled,'BoundingBox','Area','PixelList');
centroid = regionprops(labeled,'Centroid','Area','PixelList');
graindata=regionprops(labeled,'basic');
figure;
subplot(1,2,1);imshow(BW);title('��ǽ��');
for i=1:m
    rectangle('Position',[stats(i).BoundingBox],'LineWidth',2,'LineStyle','--','EdgeColor','r'),
    text(centroid(i,1).Centroid(1,1)-15,centroid(i,1).Centroid(1,2)-15, num2str(i),'Color', 'r') 
    area=stats(i).Area;
    area
     
   %���������ֵ����ȡ
    
     Area=graindata(i).BoundingBox(3)*graindata(i).BoundingBox(4);
     value=area/Area;
%      value
    if value<0.48|| value>0.68 
        pointList = stats(i).PixelList;                     %ÿ����ͨ���������λ��
        rIndex=pointList(:,2);cIndex=pointList(:,1);
        pointList = stats(i).PixelList;                     %��ͨ�������������
        BW(rIndex,cIndex)=0;
    end
   
   %���������С����ȡ
   
   if area<180|| area>350
        pointList = stats(i).PixelList;                     %ÿ����ͨ���������λ��
        rIndex=pointList(:,2);cIndex=pointList(:,1);
        pointList = stats(i).PixelList;                     %��ͨ�������������
        BW(rIndex,cIndex)=0; 
   end  

end 


subplot(1,2,2);imshow(BW);title('��ȡ���');
% cd('E:\PSͼƬ\jiantou');
% imwrite(BWa,'lvchutiqu.jpg');

%%
%�������֣���ͷָ����ж�

[labeled,m] = bwlabel(BW);
stats=regionprops(labeled,'BoundingBox','Area','PixelList');
centroid = regionprops(labeled,'Centroid','Area','PixelList');
graindata=regionprops(labeled,'basic');
for i=1:m
%     rectangle('Position',[stats(i).BoundingBox],'LineWidth',2,'LineStyle','--','EdgeColor','r'),
%     text(centroid(i,1).Centroid(1,1)-15,centroid(i,1).Centroid(1,2)-15, num2str(i),'Color', 'r') 
%     area=stats(i).Area;
    M1=round(graindata(i).BoundingBox(1)+graindata(i).BoundingBox(3)/2);
    N1=round(graindata(i).BoundingBox(2)+graindata(i).BoundingBox(4)/2);
    M2=round(graindata(i).Centroid(1));
    N2=round(graindata(i).Centroid(2));
    if M2-M1>0 
        disp('��ͷָ���ҷ�');
    elseif M2-M1<0
        disp('��ͷָ����');
    elseif N2-N1>0
         disp('��ͷָ���·�');
    elseif N2-N1<0
         disp('��ͷָ���Ϸ�');
    end  
end