%简单地说:  
%A为给定图像，归一化到[0,1]的矩阵  
%W为双边滤波器（核）的边长/2  
%定义域方差σd记为SIGMA(1),值域方差σr记为SIGMA(2)  
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
% Pre-process input and select appropriate filter.  
function B = bfilter2(Ah,Al,w,sigma)  
  
% % Verify that the input image exists and is valid.  
% if ~exist('A','var') || isempty(A)  
%    error('Input image A is undefined or invalid.');  
% end  
% if ~isfloat(A) || ~sum([1,3] == size(A,3)) || ...  
%       min(A(:)) < 0 || max(A(:)) > 1  
%    error(['Input image A must be a double precision ',...  
%           'matrix of size NxMx1 or NxMx3 on the closed ',...  
%           'interval [0,1].']);        
% end  
  
% Verify bilateral filter window size.  
if ~exist('w','var') || isempty(w) || ...  
      numel(w) ~= 1 || w < 1  
   w = 5;  
end  
w = ceil(w);  
  
% Verify bilateral filter standard deviations.  
if ~exist('sigma','var') || isempty(sigma) || ...  
      numel(sigma) ~= 2 || sigma(1) <= 0 || sigma(2) <= 0  
   sigma = [3 0.1];  
end  
  
% Apply either grayscale or color bilateral filtering.  
if size(Ah,3) == 1  
   B = bfltGray(Ah,Al,w,sigma(1),sigma(2));  
else  
   B = bfltColor(Ah,Al,w,sigma(1),sigma(2));  
end  
  
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
% Implements bilateral filtering for grayscale images.  
function B = bfltGray(A,w,sigma_d,sigma_r)  
  
% Pre-compute Gaussian distance weights.  
[X,Y] = meshgrid(-w:w,-w:w);  
%创建核距离矩阵，e.g.  
%  [x,y]=meshgrid(-1:1,-1:1)  
%   
% x =  
%   
%     -1     0     1  
%     -1     0     1  
%     -1     0     1  
%   
%   
% y =  
%   
%     -1    -1    -1  
%      0     0     0  
%      1     1     1  
%计算定义域核  
G = exp(-(X.^2+Y.^2)/(2*sigma_d^2));  
  
% Create waitbar.  
h = waitbar(0,'Applying bilateral filter...');  
set(h,'Name','Bilateral Filter Progress');  
  
% Apply bilateral filter.  
%计算值域核H 并与定义域核G 乘积得到双边权重函数F  
dim = size(A);  
B = zeros(dim);  
for i = 1:dim(1)  
   for j = 1:dim(2)  
        
         % Extract local region.  
         iMin = max(i-w,1);  
         iMax = min(i+w,dim(1));  
         jMin = max(j-w,1);  
         jMax = min(j+w,dim(2));  
         %定义当前核所作用的区域为(iMin:iMax,jMin:jMax)  
         I = A(iMin:iMax,jMin:jMax);%提取该区域的源图像值赋给I  
        
         % Compute Gaussian intensity weights.  
         H = exp(-(I-A(i,j)).^2/(2*sigma_r^2));  
        
         % Calculate bilateral filter response.  
         F = H.*G((iMin:iMax)-i+w+1,(jMin:jMax)-j+w+1);  
         B(i,j) = sum(F(:).*I(:))/sum(F(:));  
                 
   end  
   waitbar(i/dim(1));  
end  
  
% Close waitbar.  
close(h);  
  
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
% Implements bilateral filter for color images.  
function B = bfltColor(Ah,Al,w,sigma_d,sigma_r)  
  
% Convert input sRGB image to CIELab color space.  
if exist('applycform','file')  
   Ah = applycform(Ah,makecform('srgb2lab'));  
else  
   Ah = colorspace('Lab<-RGB',Ah);  
end  

for m = 1 : size(Al, 1)
    for n = 1 : size(Al, 2)
        pixNum = Al{m, n, 1, 1};
        for p = 2 : pixNum + 1
            [l, a, b] = ...
                rgb2lab(Al{m, n, p, 3}, Al{m, n, p, 4}, Al{m, n, p, 5});
            Al(m, n, p, 3 : 5) = {l, a, b};
        end
    end
end

  
% 高分辨图像窗口中的定义域核
[X,Y] = meshgrid(-w:w,-w:w);  
G = exp(-(X.^2+Y.^2)/(2*sigma_d^2));  
  
% Rescale range variance (using maximum luminance).  
sigma_r = 100*sigma_r;  
  
% Create waitbar.  
h = waitbar(0,'Applying bilateral filter...');  
set(h,'Name','Bilateral Filter Progress');  
  

% Apply bilateral filter.  
dim = size(Ah);  
B = zeros(dim);  
for i = 1:dim(1)  
   for j = 1:dim(2)  
        
         % 高分辨率图像的窗口区域
         ihMin = max(i-w,1);  
         ihMax = min(i+w,dim(1));  
         jhMin = max(j-w,1);  
         jhMax = min(j+w,dim(2));  
         
%          低分辨率图像的窗口区域
         ilMax = floor((ihMax + 1) / 2);
         ilMin = cell((ihMin + 1) / 2);
         jlMax = floor((jhMax + 1) / 2);
         jlMin = cell((jhMin + 1) / 2);
         
         Ih = Ah(ihMin:ihMax,jhMin:jhMax,:);  
        
         % 高分辨率图像窗口中的值域核  
         dL = Ih(:,:,1)-Ah(i,j,1);  
         da = Ih(:,:,2)-Ah(i,j,2);  
         db = Ih(:,:,3)-Ah(i,j,3);  
         H = exp(-(dL.^2+da.^2+db.^2)/(2*sigma_r^2));  
          
%          高分辨率图像窗口中的双边权重函数
         F = H.*G((iMin:iMax)-i+w+1,(jMin:jMax)-j+w+1); 
         
         norm_F = sum(F(:));
         Isum = [sum(sum(F.*Ih(:,:,1))),...
                 sum(sum(F.*Ih(:,:,2))),...
                 sum(sum(F.*Ih(:,:,3)))];
             
         
         for il = ilMin : ilMax
             for jl = jlMin : jlMax
                 pixGroup = squeeze(Al(il, jl,:, :));
                 groupSize = pixGroup{1, 1};
                 for pl = 2 : groupSize + 1
                     px = pixGroup(pl);
                     x = 2* px{1} - 1;
                     y = 2 * px{2} - 1;
                     if (2 * x - 1) >= ihMin && (2 * x - 1) <= ihMax && ...
                             (2 * y - 1) >= jhMin && (2 * y - 1) <= jhMax
                         l_ = px{3};
                         a_ = px{4};
                         b_ = px{5};
                         dl_ = l_ - Ah(i, j, 1);
                         da_ = a_ - Ah(i, j, 2);
                         db_ = b_ - Ah(i, j, 3);
                         Gtemp = exp(-((x - i).^2+(y - j).^2)/(2*sigma_d^2));
                         Htemp = exp(-(dl_.^2+da_.^2+db_.^2)/(2*sigma_r^2));
                         Isum = Isum + Gtemp * Htemp * Ah(i, j);
                         norm_F = norm_F + Gtemp * Htemp;
                        
                     end
                     
                 end
             end
         end
         
         B(i, j) = Isum / norm_F;
                  
   end  
   waitbar(i/dim(1));  
end  
  
% Convert filtered image back to sRGB color space.  
if exist('applycform','file')  
   B = applycform(B,makecform('lab2srgb'));  
else    
   B = colorspace('RGB<-Lab',B);  
end  
  
% Close waitbar.  
close(h);  