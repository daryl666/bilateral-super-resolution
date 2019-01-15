function Res = pixAggregate(Ia, Coordinate)

rows = size(Ia, 1);
cols = size(Ia, 2);

Res= cell(rows, cols, 50, 3);

for i = 1 : rows
    for j = 1 : cols
        x = Coordinate(i, j, 1);
        y = Coordinate(i, j, 2);
        rValue = Ia(i, j, 1);
        gValue = Ia(i, j, 2);
        bValue = Ia(i, j, 3);
        
        pixNum = Res(round(x), round(y), 1);
        if isempty(pixNum{1})
            pixNum{1} = 1;
        else
            pixNum{1} = pixNum{1} + 1;
        end
        Res(round(x), round(y), 1, 1) = pixNum(1);
        Res(round(x), round(y), pixNum{1} + 1, 1:5) = {x, y, rValue, gValue, bValue};
    end
end

