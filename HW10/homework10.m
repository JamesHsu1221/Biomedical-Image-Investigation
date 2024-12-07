clc
clear
close all;

data = readtable('HW9_excel.xlsx', 'VariableNamingRule', 'preserve');
data.Properties.VariableNames = ...
{'ID', 'Group', 'Sex', 'Age', 'Disease', 'Height', 'Weight', 'Height_inch', 'Weight_lb', 'Velrate', 'CBFrate'};

% Split by 'Group'
group1_data = data(data.Group == 1, :);
group2_data = data(data.Group == 2, :);

% Question 1 
% Weight (kg)
weight1_mean = mean(group1_data.Weight);
weight1_std = std(group1_data.Weight);
weight2_mean = mean(group2_data.Weight);
weight2_std = std(group2_data.Weight);
% CBFrate(min^2*100g)
CBFrate1_mean = mean(group1_data.CBFrate);
CBFrate1_std = std(group1_data.CBFrate);
CBFrate2_mean = mean(group2_data.CBFrate);
CBFrate2_std = std(group2_data.CBFrate);

% two sample t test in Matlab
h_1a = ttest2(group1_data.Weight, group2_data.Weight);
fprintf('Question 1-a :\n')
if h_1a == 1
    fprintf('Reject the null hypothesis.\n');
else
    fprintf('Fail to reject the null hypothesis.\n');
end

h_1b = ttest2(group1_data.CBFrate, group2_data.CBFrate);
fprintf('Question 1-b :\n')
if h_1b == 1
    fprintf('Reject the null hypothesis.\n');
else
    fprintf('Fail to reject the null hypothesis.\n');
end

% question 2
groupA = [2.5,3.7,1.9,2.4,4.4,1.8,2.2,2.0,0.6,2.9];
groupB = [6.3,6.2,9.3,4.3,8.8,6.8,1.0,5.3,5.8,5.0];
groupC = [4.8,9.3,5.0,11.7,7.1,8.7,10.7,9.4,9.6,5.4];

groupA_mean = mean(groupA);
groupB_mean = mean(groupB);
groupC_mean = mean(groupC);
groupA_std = std(groupA);
groupB_std = std(groupB);
groupC_std = std(groupC);

% anova in Matlab
data_2 = [groupA, groupB, groupC];
group_2 = {'A','A','A','A','A','A','A','A','A','A',...
    'B','B','B','B','B','B','B','B','B','B',...
    'C','C','C','C','C','C','C','C','C','C'};

p_2  = anova1(data_2, group_2);
close Figure 2;
fprintf('Question 2 :\n');
if p_2 < 0.05
    fprintf('Reject the null hypothesis.\n');
else
    fprintf('Fail to reject the null hypothesis.\n');
end

% question 3
Bulimic = [15.9,16.0,16.5,17.0,17.6,18.1,18.4,18.9,18.9,19.6,21.5,...
    21.6,22.9,23.6,24.1,24.5,25.1,25.2,25.6,28.0,28.7,29.2,30.9];
Healthy = [20.7,22.4,23.1,23.8,24.5,25.3,25.7,30.6,30.6,33.2,33.7,...
    36.6,37.1,37.4,40.8];

Bulimic_mean = mean(Bulimic);
Healthy_mean = mean(Healthy);
Bulimic_std = std(Bulimic);
Healthy_std = std(Healthy);

% two sample t test in Matlab (One tail)
h_3 = ttest2(Bulimic, Healthy, 'Tail', 'left');
fprintf('Question 3 :\n')
if h_3 == 1
    fprintf('Reject the null hypothesis.\n');
else
    fprintf('Fail to reject the null hypothesis.');
end