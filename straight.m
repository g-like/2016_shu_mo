function [k, b] = straight(point1, point2)
    %设y=kx+b
    if point1(1) == point2(1) && point1(2) == point2(2)
        disp('请输入两个不同的点');
    elseif point1(1) == point2(1)
        disp('直线斜率不存在');
    elseif point1(2) == point2(2)
        disp('直线斜率无穷大');
    else
        k = (point1(2) - point2(2)) / (point1(1) - point2(1));
        b = point1(2) - k * point1(1);
    end

end
