S = 4;
%创建出入口点
enExit = [];
enExit(1, 1) = S * rand; enExit(1, 2) = 0;
enExit(2, 1) = S; enExit(2, 2) = S * rand;
enExit(3, 1) = S * rand; enExit(3, 2) = S;
enExit(4, 1) = 0; enExit(4, 2) = S * rand;
[k, b] = straight(enExit(1, :), enExit(3, :)); %将第一个点和第三个点连起来
node = []; %节点相关参数
node(1, 1) = abs((enExit(1, 1) - enExit(3, 1))) * rand + min([enExit(1, 1), enExit(3, 1)]);
node(2, 1) = abs((enExit(1, 1) - enExit(3, 1))) * rand + min([enExit(1, 1), enExit(3, 1)]);
node(1, 2) = k * node(1, 1) + b;
node(2, 2) = k * node(2, 1) + b;
figure('Name', '生成小区图'); %画个图看看
scatter(enExit(:, 1), enExit(:, 2), 'filled'); hold on
scatter(node(:, 1), node(:, 2), 'filled'); hold on
set(get(gca, 'XLabel'), 'String', '横坐标');
set(get(gca, 'YLabel'), 'String', '纵坐标'); hold on
line([enExit(1, 1), enExit(3, 1)], [enExit(1, 2), enExit(3, 2)]); hold on
line([node(1, 1), enExit(2, 1)], [node(1, 2), enExit(2, 2)]); hold on
line([node(2, 1), enExit(4, 1)], [node(2, 2), enExit(4, 2)]); hold on
