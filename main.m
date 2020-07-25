judge = randi(2); %��������ж�ֵ����Ϊ2�����ʾ��·�����г����
enExitLabel = zeros(4, 2); %С������ڣ���һ��������������꣬�ڶ�����������������
nodeLabel = rand(randi(7) + 3, 2); %�涨һ��С��������4���ڵ�,����10���ڵ�,��һ��������������꣬�ڶ�����������������
nodeLabel(:, 3) = 0; %�ڵ��������,��һ���������������,�ڶ�����������������,��������������������֮��̾���Ľڵ�ľ���֮��
enExit = []; %����ڲ�������,��һ��������������꣬�ڶ�����������������,����������������֮������̵Ľڵ����,��4������������֮������̽ڵ������
middleDistance = [];
middleDistance2 = [];
middleDistance3 = [];
enExitDistance = []; %�洢ÿ������ڵ���Ӧ��������ڵĺ������

for i = 1:4%���ɳ����λ�����꣬������enExitLabel������
    judge = randi(2);

    if judge == 2%��������ж�ֵ����Ϊ2�����ʾ��·�����г����

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

    if (i == 4 & enExitLabel(:) == 0)%���ף���ֹһ������ڶ�û�е����
        enExitLabel(4, 1) = 0;
        enExitLabel(4, 2) = rand(1);
    end

end

for i = 1:length(enExitLabel(:, 1))%ȥ������ԭ�������

    if enExitLabel(i, 1) ~= 0 || enExitLabel(i, 2) ~= 0
        enExit(end + 1, :) = enExitLabel(i, :);
    end

end

%����·����ӵ��ʱС��������ɵ�Ӱ��
if length(enExit(:, 1)) == 1
    influence = 0; %���ֻ��һ������ڣ�����С������û�ã��Ը�·������Ϊ0
else %�ų�ֻ��һ������ڵ���������

    for j = 1:length(enExit(:, 1))%�±����enExitLabel
        gap = 10; %��ʼ����̾���

        for i = 1:length(nodeLabel(:, 1))%�±����nodeLabel

            if two_distance(enExit(j, :), nodeLabel(i, :)) <= gap%�������С��ԭ�ȵ���̾���
                gap = two_distance(enExit(j, :), nodeLabel(i, :));
                enExit(j, 4) = i;
            end

        end

        enExit(j, 3) = gap;
    end

    %�����������ݵ�enExit��,��һ�д�������꣬�ڶ��д��������꣬�����д�����֮�������ڵ����
    figure('Name', '����С��ͼ'); %����ͼ����
    scatter(enExit(:, 1), enExit(:, 2), 'filled')
    hold on
    scatter(nodeLabel(:, 1), nodeLabel(:, 2), 'filled')
    hold on
    set(get(gca, 'XLabel'), 'String', '������');
    set(get(gca, 'YLabel'), 'String', '������');
    %���¿�ʼ����ƽ��·���ܶȦ�,����ÿ���ڵ�ֻ������3�������˵�
    for i = 1:length(nodeLabel(:, 1))%����ÿ���ڵ�

        for m = 1:length(enExit(:, 4))%���Ѿ����ӵ�����ڵĽڵ㵥������

            if i == enExit(m, 4)%����������ĸýڵ�ǡ�������ӵ�����ڵĽڵ�ʱ
                k = 3 - length(find(enExit(:, 4) == enExit(m, 4))); %k��Ӧʣ�µĿ����������ڵ����������������Ϊ3

                if k == 0 || k == -1%���k����������ֵ,�ýڵ㽫���������ڵ������ӡ�
                    nodeLabel(i, 3) = 0;
                else %k��������������ֵ��ѡ��1�������ڵ���֮����.

                    for n = 1:length(nodeLabel(:, 1))

                        if i == n
                            continue;
                        end

                        middleDistance(end + 1) = two_distance(nodeLabel(i, :), nodeLabel(n, :));
                    end

                    sortDistance = sort(middleDistance);
                    nodeLabel(i, 3) = sum(sortDistance(1:k)); %�õ���ýڵ����ӵ�������������·���ӵ��ܳ�.
                end

            end

        end

        %����ɸѡ֮��,ʣ�µľ��ǲ����ӳ���ڵĽڵ���.
        if nodeLabel(i, 3) == 0%�����ʱ��Ȼ����0,��ô֤����û�������������������,���Ƿ������3���ڵ�.
            middleDistance = []; %��ʼ��middledistance

            for n = 1:length(nodeLabel(:, 1))

                if i == n
                    continue;
                end

                middleDistance(end + 1) = two_distance(nodeLabel(i, :), nodeLabel(n, :));
            end

            sortDistance = sort(middleDistance);
            nodeLabel(i, 3) = sum(sortDistance(1:3)); %��ǰ���������ܺͷ���������.
        end

    end

    %�������,ÿ���ڵ��Ӧ�ľ���֮�Ͷ�������nodeLabel�ĵ�������.
    p = (sum(nodeLabel(:, 3)) + sum(enExit(:, 3)) * 2) / 2; %p��Ϊƽ��·���ܶ�,��ÿ��·�ζ����ظ�����һ��,������Ҫ���Զ�;����С���߳�Ϊ1����λ,���С�����Ϊ1.

    %���¼���ÿ������ڵ�������һ���������Ҫ����̾���(��Ҫ�����������м�ڵ�)
    middleDistance = []; %��ʼ��middledistance

    for i = 1:length(enExit(:, 1))%������һ����ڵ�

        for j = 1:length(enExit(:, 1))%�����ڶ�����ڵ�

            if i == j%����������غϣ�������
                continue;
            end

            if enExit(i, 4) == enExit(j, 4)%���������ڵ���̾���ڵ�ǡ����ͬһ��,��ֱ��ͨ����̾���ڵ�ͨ������ĳ���
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
                    + two_distance(nodeLabel(n, :), enExit(j, :)); %�õ�һ���������ڵ�ľ�������

                    for k = 1:length(nodeLabel(:, 1))

                        if k == n || k == m
                            continue;
                        end

                        middleDistance3(end + 1) = ...,
                        two_distance(enExit(i, :), nodeLabel(m, :)) ...,
                        +two_distance(nodeLabel(m, :), nodeLabel(n, :)) ...,
                        +two_distance(nodeLabel(n, :), nodeLabel(k, :)) ...,
                        +two_distance(nodeLabel(k, :), enExit(j, :)); %�õ�һ���������ڵ�ľ�������

                    end

                end

            end

            sortDistance2 = sort(middleDistance2); %����,��С����
            sortDistance3 = sort(middleDistance3); %����,��С����

            if (sortDistance2(1) - sortDistance3(1)) / sortDistance2(1) <= 0.1%������ڵ�����ڵ�֮���������С,�������Ϊ��·�ξ����������ڵ�.��ѡ�����ڵ�.
                enExitDistance(i, j) = sortDistance3(1);
            else
                enExitDistance(i, j) = sortDistance2(1);
            end

        end

    end

end
