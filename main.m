I=imread('input/5428ccf9gy1fcx9udoo40j20qo0zkqa2.png');
I=double(I)/255;

w     = 5;       % bilateral filter half-width
sigma = [3 0.1]; % bilateral filter standard deviations

I1=bfilter2(res,Ilow,w,sigma);

subplot(1,2,1);
imshow(I);
subplot(1,2,2);
imshow(I1)  






% % ��ȡ
% f = imread('input/5428ccf9gy1fcx9udoo40j20qo0zkqa2.png');
%  
% % ���ò���
% r = 5;% �˲��뾶
% a = 3;% ȫ�ַ���
% b = 0.1;% �ֲ�����
%  
%     g = bfilter(f,r,a,b);
%  
% % ��ʾ
% subplot(121)
% imshow(f)
% subplot(122)
% imshow(g)