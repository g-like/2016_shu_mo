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
