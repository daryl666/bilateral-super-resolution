function res = interpolate(iC, iA)

rows = size(iC, 1);
cols = size(iC, 2);
res = cell(rows * 2 - 1, cols * 2 - 1, 3);

% 基准图像的像素点
for i = 1 : 2 : 2 * rows - 1
    for j = 1 : 2 : 2 * cols - 1
        res(i, j, :) = {iC(floor(i / 2) + 1, floor(j / 2) + 1)};
    end
end

% 需要插值的像素
% 对于每个待插值像素需要考虑其周围的八个像素
for i = 1 : 2 * rows - 1
    if mod(i, 2) == 1
        start = 2;
        step = 2;
    else
        start = 1;
        step = 1;
    end
    
    for j = start : step : 2 * cols - 1
        
%         leftUp----up----rightUp
%           |        |       |
%           |        |       |
%          left ----cur----right
%           |        |       |
%           |        |       |
%        leftDown---down---rightDown

%     有效像素的条件
%     1. 在界内
%     2. x和y为奇数
        if i - 1 > 0 && j - 1 > 0 && mod(i - 1, 2) && mod(j - 1, 2)
            leftUp = squeeze(iA(floor((i - 1) / 2) + 1, floor((j - 1) / 2) + 1, :, :));
        end
        
        if i - 1 > 0 && j + 1 <= 2 * cols - 1 && mod(i - 1, 2) && mod(j + 1, 2)
            rightUp = squeeze(iA(floor((i - 1) / 2) + 1, floor((j + 1) / 2) + 1, :, :));
        end
        
        if i + 1 <= 2 * rows - 1 && j - 1 > 0 && mod(i + 1, 2) && mod(j - 1, 2) 
            leftDown = squeeze(iA(floor((i + 1) / 2) + 1, floor((j - 1) / 2) + 1, :, :));
        end     
        
        if i + 1 <= 2 * rows - 1 && j + 1 <= 2 * cols - 1 ...
                && mod(i + 1, 2) && mod(j + 1, 2)
            rightDown = squeeze(iA(floor((i + 1) / 2) + 1, floor((j + 1) / 2) + 1, :, :));
        end
        
        if j - 1 > 0 && mod(i, 2) && mod(j - 1, 2)
            left = squeeze(iA(floor(i / 2) + 1, floor((j - 1) / 2) + 1, :, :));
        end
        
        if j + 1 > 0 && mod(i, 2) && mod(j + 1, 2)
            right = squeeze(iA(floor(i / 2) + 1, floor((j + 1) / 2) + 1, :, :));
        end
        
        if i - 1 > 0 && mod(i - 1, 2) && mod(j, 2)
            up = squeeze(iA(floor((i - 1) / 2) + 1, floor(j / 2) + 1, :, :));
        end
        
        if i + 1 > 0 && mod(i + 1, 2) && mod(j, 2)
            down = squeeze(iA(floor((i + 1) / 2) + 1, floor(j / 2) + 1, :, :));
        end
      
        
        
%         选择距离当前像素最近的像素做插值
        temp = cell(5);
        tempDist = intmax;
        if exist('leftUp', 'var')
            for ii = 1 : leftUp{1, 1}
                if (leftUp{ii + 1, 1} * 2 - 1 - i) ^ 2 ...
                        + (leftUp{ii + 1, 2} * 2 - 1 - j) ^ 2 < tempDist
                    temp = leftUp(ii + 1, :);
                    tempDist = (leftUp{ii + 1, 1} * 2 - 1 - i) ^ 2 ...
                        + (leftUp{ii + 1, 2} * 2 - 1 - j) ^ 2;
                end
            end
        end
        
        if exist('leftDown', 'var')
            for ii = 1 : leftDown{1, 1}
                if (leftDown{ii + 1, 1} * 2 - 1 - i) ^ 2 ...
                        + (leftDown{ii + 1, 2} * 2 - 1 - j) ^ 2 < tempDist
                    temp = leftDown(ii + 1, :);
                    tempDist = (leftDown{ii + 1, 1} * 2 - 1 - i) ^ 2 ...
                        + (leftDown{ii + 1, 2} * 2 - 1 - j) ^ 2;
                end
            end
        end
        
        if exist('rightUp', 'var')
            for ii = 1 : rightUp{1, 1}
                if (rightUp{ii + 1, 1} * 2 - 1 - i) ^ 2 + (rightUp{ii + 1, 2} * 2 - 1 - j) ^ 2 < tempDist
                    temp = rightUp(ii + 1, :);
                    tempDist = (rightUp{ii + 1, 1} * 2 - 1 - i) ^ 2 + (rightUp{ii + 1, 2} * 2 - 1 - j) ^ 2;
                end
            end
        end
        
        if exist('rightDown', 'var')
            for ii = 1 : rightDown{1, 1}
                if (rightDown{ii + 1, 1} * 2 - 1 - i) ^ 2 ...
                        + (rightDown{ii + 1, 2} * 2 - 1 - j) ^ 2 < tempDist
                    temp = rightDown(ii + 1, :);
                    tempDist = (rightDown{ii + 1, 1} * 2 - 1 - i) ^ 2 ...
                        + (rightDown{ii + 1, 2} * 2 - 1 - j) ^ 2;
                end
            end
        end
        
        if exist('rightDown', 'var')
            for ii = 1 : rightDown{1, 1}
                if (rightDown{ii + 1, 1} * 2 - 1 - i) ^ 2 ...
                        + (rightDown{ii + 1, 2} * 2 - 1 - j) ^ 2 < tempDist
                    temp = rightDown(ii + 1, :);
                    tempDist = (rightDown{ii + 1, 1} * 2 - 1 - i) ^ 2 ...
                        + (rightDown{ii + 1, 2} * 2 - 1 - j) ^ 2;
                end
            end
        end
        
        if exist('left', 'var')
            for ii = 1 : left{1, 1}
                if (left{ii + 1, 1} * 2 - 1 - i) ^ 2 ...
                        + (left{ii + 1, 2} * 2 - 1 - j) ^ 2 < tempDist
                    temp = left(ii + 1, :);
                    tempDist = (left{ii + 1, 1} * 2 - 1 - i) ^ 2 ...
                        + (left{ii + 1, 2} * 2 - 1 - j) ^ 2;
                end
            end
        end
        
        if exist('right', 'var')
            for ii = 1 : right{1, 1}
                if (right{ii + 1, 1} * 2 - 1 - i) ^ 2 ...
                        + (right{ii + 1, 2} * 2 - 1 - j) ^ 2 < tempDist
                    temp = right(ii + 1, :);
                    tempDist = (right{ii + 1, 1} * 2 - 1 - i) ^ 2 ...
                        + (right{ii + 1, 2} * 2 - 1 - j) ^ 2;
                end
            end
        end
        
        if exist('up', 'var')
            for ii = 1 : up{1, 1}
                if (up{ii + 1, 1} * 2 - 1 - i) ^ 2 ...
                        + (up{ii + 1, 2} * 2 - 1 - j) ^ 2 < tempDist
                    temp = up(ii + 1, :);
                    tempDist = (up{ii + 1, 1} * 2 - 1 - i) ^ 2 ...
                        + (up{ii + 1, 2} * 2 - 1 - j) ^ 2;
                end
            end
        end
        
         if exist('down', 'var')
            for ii = 1 : down{1, 1}
                if (down{ii + 1, 1} * 2 - 1 - i) ^ 2 ...
                        + (down{ii + 1, 2} * 2 - 1 - j) ^ 2 < tempDist
                    temp = down(ii + 1, :);
                    tempDist = (down{ii + 1, 1} * 2 - 1 - i) ^ 2 ...
                        + (down{ii + 1, 2} * 2 - 1 - j) ^ 2;
                end
            end
         end
        
        res(i, j, 1 : 3) = temp(1, 3 : 5);
        
      
    end
end







