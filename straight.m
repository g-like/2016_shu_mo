function [k, b] = straight(point1, point2)
    %��y=kx+b
    if point1(1) == point2(1) && point1(2) == point2(2)
        disp('������������ͬ�ĵ�');
    elseif point1(1) == point2(1)
        disp('ֱ��б�ʲ�����');
    elseif point1(2) == point2(2)
        disp('ֱ��б�������');
    else
        k = (point1(2) - point2(2)) / (point1(1) - point2(1));
        b = point1(2) - k * point1(1);
    end

end
