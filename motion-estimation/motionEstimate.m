function motion = motionEstimate(pRef, absPhiTarget, direction) 

cols = size(absPhiTarget, 2);
rows = size(absPhiTarget, 1);
if strcmp(direction, 'vertical')
    for i = 1 : cols
        for j = 1 : rows
            phase = absPhiTarget(j, i);
            newY(j, i) = 1 / pRef(1, i) * phase - pRef(2, i) / pRef(1, i);
        end
    end
    [X, Y] = meshgrid(1 : cols, 1 : rows);
    motion = newY - Y;
else
    for i = 1 : rows
        for j = 1 : cols
            phase = absPhiTarget(i, j);
            newX(i, j) = 1 / pRef(1, i) * phase - pRef(2, i) / pRef(1, i);
        end
    end
    [X, Y] = meshgrid(1 : cols, 1 : rows);
    motion = newX - X;
end



