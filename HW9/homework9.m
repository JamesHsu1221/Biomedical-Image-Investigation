clc
clear
close all;

data = readtable('HW9_excel.xlsx', 'VariableNamingRule', 'preserve');
data.Properties.VariableNames = ...
{'ID', 'Group', 'Sex', 'Age', 'Disease', 'Height', 'Weight', 'Height_inch', 'Weight_lb', 'Velrate', 'CBFrate'};

% Split by 'Group'
group1_data = data(data.Group == 1, :);
group2_data = data(data.Group == 2, :);

% Question 1-a
% Sex
group1_male = sum(strcmp(group1_data.Sex, 'M'));
group1_female = sum(strcmp(group1_data.Sex, 'F'));
group2_male = sum(strcmp(group2_data.Sex, 'M'));
group2_female = sum(strcmp(group2_data.Sex, 'F'));
% Age
age1_mean = mean(group1_data.Age);
age1_std = std(group1_data.Age);
age2_mean = mean(group2_data.Age);
age2_std = std(group2_data.Age);
% Height(m)
height1_mean = mean(group1_data.Height);
height1_std = std(group1_data.Height);
height2_mean = mean(group2_data.Height);
height2_std = std(group2_data.Height);
% Weight (kg)
weight1_mean = mean(group1_data.Weight);
weight1_std = std(group1_data.Weight);
weight2_mean = mean(group2_data.Weight);
weight2_std = std(group2_data.Weight);
% Velrate (cm/s^2)
velrate1_mean = mean(group1_data.Velrate);
velrate1_std = std(group1_data.Velrate);
velrate2_mean = mean(group2_data.Velrate);
velrate2_std = std(group2_data.Velrate);
% CBFrate(min^2*100g)
CBFrate1_mean = mean(group1_data.CBFrate);
CBFrate1_std = std(group1_data.CBFrate);
CBFrate2_mean = mean(group2_data.CBFrate);
CBFrate2_std = std(group2_data.CBFrate);

% Question 1-b 
[counts, name] = groupcounts(data.Disease);
figure(1);
pie(counts, '%.2f%%');

% Question 1-c
figure(2);
histogram(data.Weight, 0:10:ceil(max(data.Weight)));
xlabel('Weight (kg)');
ylabel('Number of people');

% Question 1-d
figure(3);
hold on;
box1 = boxchart(ones(size(group1_data.CBFrate)), group1_data.CBFrate, 'BoxFaceColor', 'green', 'MarkerStyle','x');
box2 = boxchart(2*ones(size(group2_data.CBFrate)), group2_data.CBFrate, 'BoxFaceColor', 'red', 'MarkerStyle','x');
xticklabels({'','Group 1','', 'Group 2'});
ylabel('CBF rate (ml / min^2 * 100g)');

scatter(ones(size(group1_data.CBFrate)), group1_data.CBFrate, 'MarkerEdgeColor', 'g','Marker','x');
scatter(2*ones(size(group2_data.CBFrate)), group2_data.CBFrate, 'MarkerEdgeColor', 'r','Marker','x');
hold off;

% Question 1-e
figure(4);
hold on;
% CBF rate
yyaxis left;
CBF = bar(1:2, [CBFrate1_mean, CBFrate2_mean]); % bar plot
CBF.FaceColor = "flat"; % set color
CBF.CData = [0 1 0; 1 0 0];
errorbar(1:2, [CBFrate1_mean, CBFrate2_mean], [CBFrate1_std, CBFrate2_std], 'k', 'linestyle', 'none'); % std errorbar plot
ylim([0, 150]); % set Y axis
ylabel('CBF rate (ml / min^2 * 100g)');

% Velocity Rate
yyaxis right;
Vel = bar(4:5, [velrate1_mean,velrate2_mean]); % bar plot
Vel.FaceColor = "flat"; % set color
Vel.CData = [0 1 0; 1 0 0];
errorbar(4:5, [velrate1_mean,velrate2_mean], [velrate1_std,velrate2_std], 'k', 'linestyle', 'none'); % std errorbar plot
ylim([0, 0.9]); % set Y axis
ylabel('Velocity Rate (cm / s^2)');

% set X axis, labels and open grid
xticks([1.5, 4.5]);
xticklabels({'CBF rate', 'Velocity rate'});
grid on;
ax = gca;
ax.XGrid = 'off';
hold off;
%_____________________________________________
% Question 2-a
x_bar = 25;
s = 2.7;
n = 58;
CI = 0.95;
df = n-1;
z = 1.96;
SE = s/sqrt(n);

CI_upper = x_bar+z*SE;
CI_lower = x_bar-z*SE;
fprintf('Confidence Interval: [%.2f, %.2f] \n', CI_lower, CI_upper);

% Question 2-b
mu = 24;

t = (x_bar-mu)/(s/sqrt(n));
p_value = 2*(1 - tcdf(t, df));
fprintf('P_value = %.4f \n',p_value);