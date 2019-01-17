I=imread('input/5428ccf9gy1fcx9udoo40j20qo0zkqa2.png');
I=double(I)/255;

w     = 5;       % bilateral filter half-width
sigma = [3 0.1]; % bilateral filter standard deviations

I1=bfilter2(res,Ilow,w,sigma);

subplot(1,2,1);
imshow(I);
subplot(1,2,2);
imshow(I1)  






% % 读取
% f = imread('input/5428ccf9gy1fcx9udoo40j20qo0zkqa2.png');
%  
% % 设置参数
% r = 5;% 滤波半径
% a = 3;% 全局方差
% b = 0.1;% 局部方差
%  
%     g = bfilter(f,r,a,b);
%  
% % 显示
% subplot(121)
% imshow(f)
% subplot(122)
% imshow(g)