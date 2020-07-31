%%
%��һ���֣�����ROI��ȡ
clc; close all; clear all; 

I=imread('E:\��ҵ���ȫ������\��̹���\����ͼƬ\��������ͼ��\Բ��\1.jpg');              %��ָ��λ�ö�ȡͼƬ 
figure;
imshow(I); title('ԭͼ');                          %��ʾͼƬ
a=size(I,1);                                       %��ȡͼ��߶�
b=size(I,2);                                       %��ȡͼ����
im=imcrop(I,[0,0,b,a*2/3]);

figure;image(im) ; title('����λ����Ϣ��ȡ');       %��ʾ��ȡ��ͼ��
% cd('E:\PSͼƬ\yuanxing');                         
% imwrite(im,'light.jpg');                           %���������͵�ͼƬ

%%
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

A=Ba;
%�ҶȻ�
a=rgb2gray(A);
figure;
subplot(2,2,1);imshow(A);title('ԭͼ');
subplot(2,2,2);imshow(a);title('�Ҷ�ͼ');
% cd('E:\PSͼƬ\yuanxing');
% imwrite(a,'honghui.jpg');

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
% cd('E:\PSͼƬ\yuanxing');
% imwrite(BWa,'hongerzhi.jpg');

%%
%���Ĳ��֣���̬ѧ����
se=strel('disk',4);
BW=imclose(BWa,se);

figure;
subplot(1,2,1);imshow(BWa);title('��ֵ��');
subplot(1,2,2);imshow(BW);title('������');

% cd('E:\PSͼƬ\yuanxing');
% imwrite(BW,'hongkai.jpg');

%%
%���岿�֣���ͨ��������ȡ


[mark_image,num] = bwlabel(BW,8);

stats=regionprops(mark_image,'BoundingBox','Area','PixelList');
centroid=regionprops(mark_image,'Centroid','Area','PixelList');
graindata=regionprops(mark_image,'basic');

figure;
subplot(2,1,1);imshow(mark_image);title('��Ǻ��ͼ��');
for i=1:num
    rectangle('Position',[stats(i).BoundingBox],'LineWidth',1,'LineStyle','--','EdgeColor','r'),
    text(centroid(i,1).Centroid(1,1)-15,centroid(i,1).Centroid(1,2)-15, num2str(i),'Color', 'r') 
    area=stats(i).Area;
   
    %���������ֵ����ȡ
     Area=graindata(i).BoundingBox(3)*graindata(i).BoundingBox(4);
     value=area/Area;
    if value<0.7 || value>0.85    
        pointList = stats(i).PixelList;                       %ÿ����ͨ���������λ��
        rIndex=pointList(:,2);cIndex=pointList(:,1);
        pointList = stats(i).PixelList;                       %��ͨ�������������
        BW(rIndex,cIndex)=0;
    end
   
   %���������С����ȡ 
   if area<250 || area>500
        pointList = stats(i).PixelList;                       %ÿ����ͨ���������λ��
        rIndex=pointList(:,2);cIndex=pointList(:,1);
        pointList = stats(i).PixelList;                       %��ͨ�������������
        BW(rIndex,cIndex)=0; 
   end  
end

subplot(2,1,2);imshow(BW);title('�����ȡ��');

% cd('E:\PSͼƬ\yuanxing');
% imwrite(BW,'result.jpg')
