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

enExit = [];

for i = 1:length(enExitLabel(:, 1))%去除处在原点的坐标

    if enExitLabel(i, 1) ~= 0 || enExitLabel(i, 2) ~= 0
        enExit(end + 1, :) = enExitLabel(i, :);
    end

end

%假设路况不拥堵时小区开放造成的影响
if length(enExit(:, 1)) == 1
    influence = 0; %如果只有一个出入口，开放小区根本没用，对该路段作用为0
else %排除只有一个出入口的下述计算

    for j = 1:length(enExit(:, 1))%下标遍历enExitLabel
        gap = 10; %初始化最短距离

        for i = 1:length(nodeLabel(:, 1))%下标遍历nodeLabel

            if two_distance(enExit(j, :), nodeLabel(i, :)) <= gap%如果距离小于原先的最短距离
                gap = two_distance(enExit(j, :), nodeLabel(i, :));
            end

        end

        enExit(j, 3) = gap;
    end

    %汇总上述数据到enExit上,第一列代表横坐标，第二列代表纵坐标，第三列代表与之相距最近节点距离
    figure('Name', '生成小区图'); %画个图看看
    scatter(enExit(:, 1), enExit(:, 2), 'filled')
    hold on
    scatter(nodeLabel(:, 1), nodeLabel(:, 2), 'filled')
    hold on
    set(get(gca, 'XLabel'), 'String', '横坐标');
    set(get(gca, 'YLabel'), 'String', '纵坐标');

end
