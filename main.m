judge = randi(2); %随机生成判断值，若为2，则表示此路段上有出入口
enExitLabel = zeros(4, 2); %小区出入口，第一个参数代表横坐标，第二个参数代表纵坐标
nodeLabel = rand(randi(9) + 1, 2); %规定一个小区内至少两个节点,至多10个节点,第一个参数代表横坐标，第二个参数代表纵坐标

for i = 1:4%生成出入口位置坐标，储存在enExitLabel矩阵中
    judge = randi(2);

    if judge == 2%随机生成判断值，若为2，则表示此路段上有出入口

        if i == 1
            enExitLabel(1, 1) = rand(1);
            enExitLabel(1, 2) = 0;
        elseif i == 2
            enExitLabel(2, 1) = 1;
            enExitLabel(2, 2) = rand(1);
        elseif i == 3
            enExitLabel(3, 1) = rand(1);
            enExitLabel(3, 2) = 1;
        else
            enExitLabel(4, 1) = 0;
            enExitLabel(4, 2) = rand(1);
        end

    end

    if (i == 4 & enExitLabel(:) == 0)%兜底，防止一个出入口都没有的情况
        enExitLabel(4, 1) = 0;
        enExitLabel(4, 2) = rand(1);
    end

end
