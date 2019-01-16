I=imread('input/5428ccf9gy1fcx9udoo40j20qo0zkqa2.png');
I=double(I)/255;

w     = 5;       % bilateral filter half-width
sigma = [3 0.1]; % bilateral filter standard deviations

I1=bfilter2(I,w,sigma);

subplot(1,2,1);
imshow(I);
subplot(1,2,2);
imshow(I1)  

A(1,1,1) = 0.01;
A(1,1,2) = 0.701960784313725;
A(1,1,3) = 0.592156862745098;
I=imread('input/5428ccf9gy1fcx9udoo40j20qo0zkqa2.png');
res = rgb2lab_bak(A);

[l, a, b] = rgb2lab(A(1,1,1), A(1,1,2), A(1,1,3));





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