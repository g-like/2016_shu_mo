judge = randi(2); %��������ж�ֵ����Ϊ2�����ʾ��·�����г����
enExitLabel = zeros(4, 2); %С������ڣ���һ��������������꣬�ڶ�����������������
nodeLabel = rand(randi(9) + 1, 2); %�涨һ��С�������������ڵ�,����10���ڵ�,��һ��������������꣬�ڶ�����������������

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

enExit = [];

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

end
