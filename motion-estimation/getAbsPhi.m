function [absPhi, parameters] = getAbsPhi(relativePhi, direction)

cols = size(relativePhi, 2);
rows = size(relativePhi, 1);
absPhi = zeros(rows, cols);
if strcmp(direction, 'vertical')
    parameters = zeros(2, cols);
    for y = 1 : cols
%   ???????????
        A = relativePhi(:, y);
        A = A';
        B = [];
        k = 1;
        for i = 1 : rows - 1
            j = i + 1;
            if A(j) - A(i) > 0
                B(k) = i;
                k = k + 1;
            end
        end
        %   ??????
        temp = A;
        if temp(1) > 0 
            start = 1;
        else
            start = 2;
            diff = temp(B(2) + 1) - temp(B(1));
            for i = 1 : B(1)
               temp(i) = temp(i) + diff;
            end
        end
        for i = start : size(B, 2)
            diff = temp(B(i) + 1) - temp(B(i));
            if i < size(B, 2)
                for j = B(i) + 1 : B(i + 1) 
                    temp(j) = temp(j) - diff;
                end
            else
                for j = B(i) + 1 : size(temp, 2) 
                    temp(j) = temp(j) - diff;
                end
            end
        end
        absPhi(:, y) = temp';
        x = 1 : rows;
        p = polyfit(x, temp, 1);
        parameters(:, y) = p';
    end
else
    parameters = zeros(rows, 2);
    for x = 1 : rows
%   ???????????
        A = relativePhi(x, :);
        k = 1;
        for i = 1 : cols - 1
            j = i + 1;
            if A(j) - A(i) > 0
                B(k) = i;
                k = k + 1;
            end
        end
        %   
        temp = A;
        if temp(1) > 0 
            start = 1;
        else
            start = 2;
            diff = temp(B(2) + 1) - temp(B(1));
            for i = 1 : B(2) + 1
               temp(i) = temp(i) + diff;
            end
        end
        for i = start : size(B, 2)
            diff = temp(B(i) + 1) - temp(B(i));
            if i < size(B, 2)
                for j = B(i) + 1 : B(i + 1) 
                    temp(j) = temp(j) - diff;
                end
            else
                for j = B(i) + 1 : size(temp, 2) 
                    temp(j) = temp(j) - diff;
                end
            end
        end
        absPhi(x, :) = temp;
        x_ = 1 : cols;
        p = polyfit(x_, temp, 1);
        parameters(x, :) = p;
    end
    
end

