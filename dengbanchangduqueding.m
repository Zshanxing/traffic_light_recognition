clc;
close all;
clear all;
%% Ԥ����
I=imread('E:\PSͼƬ\48.jpg');
figure;
imshow(I);title('ԭͼ');
imshow(I);                         %��ʾͼƬ
a=size(I,1);                                       %��ȡͼ��߶�
b=size(I,2);                                       %��ȡͼ����
im=imcrop(I,[0,0,b,a*2/3]);
figure;
image(im) ;                                    %��ʾ��ȡ��ͼ��
cd('E:\PSͼƬ');                         
imwrite(im,'light.jpg');                      %���������͵�ͼƬ
%% �ҶȻ���ֱ��ͼ���⻯
%�ҶȻ�
a=rgb2gray(im);
figure;
subplot(1,2,1);imshow(im);title('ԭͼ');
subplot(1,2,2);imshow(a);title('�Ҷ�ͼ');
cd('E:\PSͼƬ');
imwrite(a,'hui.jpg');
J=histeq(a);
figure;
imshow(J);title('ֱ��ͼ���⻯');
figure;
subplot(1,2,1);imhist(a,64);title('ԭʼͼ��ֱ��ͼ');
subplot(1,2,2);imhist(J,64);title('�����ͼ��ֱ��ͼ');

[m,n]=size(J);
for i=1:m
    for j=1:n
       if J(i,j)<55
           J(i,j)=0;
       else
           J(i,j)=255;
       end
    end
end
figure;
imshow(J);title('�����ư�');
    
%% ��̬ѧ����     
se=strel('disk',4);
BW=~imclose(J,se);
figure;
subplot(1,2,1);imshow(J);title('ԭͼ');
subplot(1,2,2);imshow(BW);title('������')

%% ��Ӿ��γ��������ȡ

%ͳ�Ʊ�ע��ͨ��

[l,m] = bwlabel(BW);
status=regionprops(l,'BoundingBox','Area','PixelList');
centroid = regionprops(l,'Centroid','Area','PixelList');
figure;
imshow(BW);title('��ǽ��');hold on;
for i=1:m
    rectangle('position',status(i).BoundingBox,'LineWidth',2,'LineStyle','--','EdgeColor','r'),
    text(centroid(i,1).Centroid(1,1)-15,centroid(i,1).Centroid(1,2)-15, num2str(i),'Color', 'r') 
    area=status(i).Area;

   if area<1000||area>1300
        pointList = status(i).PixelList;                     %ÿ����ͨ���������λ��
        rIndex=pointList(:,2);cIndex=pointList(:,1);
        pointList = status(i).PixelList;                     %��ͨ�������������
       BW(rIndex,cIndex)=0; 
  end

end 
I=BW;
figure;
imshow(I);title('��ȡ���');hold on;