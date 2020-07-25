judge = randi(2); %随机生成判断值，若为2，则表示此路段上有出入口
enExitLabel = zeros(4, 2); %小区出入口，第一个参数代表横坐标，第二个参数代表纵坐标
nodeLabel = rand(randi(7) + 3, 2); %规定一个小区内至少4个节点,至多10个节点,第一个参数代表横坐标，第二个参数代表纵坐标
nodeLabel(:, 3) = 0; %节点参数汇总
enExit = []; %出入口参数汇总
middleDistance = [];

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
                enExit(j, 4) = i;
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
    %以下开始计算平均路网密度ρ,假设每个节点只能连接3个其他端点

    for i = 1:length(nodeLabel(:, 1))%遍历每个节点

        for m = 1:length(enExit(:, 4))%对已经连接到出入口的节点单独讨论

            if i == enExit(m, 4)%如果遍历到的该节点恰好是连接到出入口的节点时
                k = 3 - length(find(enExit(:, 4) == enExit(m, 4))); %k对应剩下的可连接其他节点的数量，定义至多为3

                if k == 0 || k == -1%如果k等于这两个值,该节点将不与其他节点相连接。
                    nodeLabel(i, 3) = 0;
                else %k不等于上述两个值，选择1到三个节点与之相连.

                    for n = 1:length(nodeLabel(:, 1))

                        if i == n
                            continue;
                        end

                        middleDistance(end + 1) = two_distance(nodeLabel(i, :), nodeLabel(n, :));

                    end

                    sortDistance = sort(middleDistance);
                    nodeLabel(i, 3) = sum(sortDistance(1:k)); %得到与该节点连接的所有与其他道路连接的总长.

                end

            end

        end

        %经过筛选之后,剩下的就是不连接出入口的节点了.
        if nodeLabel(i, 3) == 0%如果此时仍然等于0,那么证明其没有与其他出入口相连接,于是分配给其3个节点.
            middleDistance = []; %初始化middledistance

            for n = 1:length(nodeLabel(:, 1))

                if i == n
                    continue;
                end

                middleDistance(end + 1) = two_distance(nodeLabel(i, :), nodeLabel(n, :));

            end

            sortDistance = sort(middleDistance);
            nodeLabel(i, 3) = sum(sortDistance(1:3)); %将前三名距离总和分配给其相加.
        end

    end

    %遍历完成,每个节点对应的距离之和都储存在nodeLabel的第三列中.
    p = sum(nodeLabel(:, 3)) + sum(enExit(:, 3)) * 2; %p即为平均路网密度,因假设小区边长为1个单位,因此小区面积为1.
end
