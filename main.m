judge = randi(2); %随机生成判断值，若为2，则表示此路段上有出入口
enExitLabel = zeros(4, 2); %小区出入口，第一个参数代表横坐标，第二个参数代表纵坐标
nodeLabel = rand(randi(7) + 3, 2); %规定一个小区内至少4个节点,至多10个节点,第一个参数代表横坐标，第二个参数代表纵坐标
nodeLabel(:, 3) = 0; %节点参数汇总,第一个参数代表横坐标,第二个参数代表纵坐标,第三个参数代表所有与之最短距离的节点的距离之和
enExit = []; %出入口参数汇总,第一个参数代表横坐标，第二个参数代表纵坐标,第三个参数代表与之距离最短的节点距离,第4个参数代表与之距离最短节点的索引
middleDistance = [];
middleDistance2 = [];
middleDistance3 = [];
enExitDistance = []; %存储每个出入口到对应其他出入口的合理距离

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
    p = (sum(nodeLabel(:, 3)) + sum(enExit(:, 3)) * 2) / 2; %p即为平均路网密度,因每条路段都被重复加了一次,所以需要除以二;假设小区边长为1个单位,因此小区面积为1.

    %以下计算每个出入口到达另外一个出入口需要的最短距离(需要经过合理多个中间节点)
    middleDistance = []; %初始化middledistance

    for i = 1:length(enExit(:, 1))%遍历第一个入口点

        for j = 1:length(enExit(:, 1))%遍历第二个入口点

            if i == j%如果两个点重合，无意义
                continue;
            end

            if enExit(i, 4) == enExit(j, 4)%如果两出入口的最短距离节点恰好是同一个,则直接通过最短距离节点通到另外的出口
                enExitDistance(i, j) = enExit(i, 3) + enExit(j, 3);
                continue;
            end

            for m = 1:length(nodeLabel(:, 1))

                for n = 1:length(nodeLabel(:, 1))

                    if n == m
                        continue;
                    end

                    middleDistance2(end + 1) = ...,
                    two_distance(enExit(i, :), nodeLabel(m, :)) ...,
                    +two_distance(nodeLabel(m, :), nodeLabel(n, :)) ...,
                    + two_distance(nodeLabel(n, :), enExit(j, :)); %得到一个经过两节点的距离数组

                    for k = 1:length(nodeLabel(:, 1))

                        if k == n || k == m
                            continue;
                        end

                        middleDistance3(end + 1) = ...,
                        two_distance(enExit(i, :), nodeLabel(m, :)) ...,
                        +two_distance(nodeLabel(m, :), nodeLabel(n, :)) ...,
                        +two_distance(nodeLabel(n, :), nodeLabel(k, :)) ...,
                        +two_distance(nodeLabel(k, :), enExit(j, :)); %得到一个经过三节点的距离数组

                    end

                end

            end

            sortDistance2 = sort(middleDistance2); %排序,由小到大
            sortDistance3 = sort(middleDistance3); %排序,由小到大

            if (sortDistance2(1) - sortDistance3(1)) / sortDistance2(1) <= 0.1%如果两节点和三节点之间相差距离很小,则可以认为该路段经过了三个节点.故选择三节点.
                enExitDistance(i, j) = sortDistance3(1);
            else
                enExitDistance(i, j) = sortDistance2(1);
            end

        end

    end

end
