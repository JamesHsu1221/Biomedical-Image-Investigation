clc
clear
close all;

data = readtable('HW9_excel.xlsx', 'VariableNamingRule', 'preserve');
data.Properties.VariableNames = ...
{'ID', 'Group', 'Sex', 'Age', 'Disease', 'Height', 'Weight', 'Height_inch', 'Weight_lb', 'Velrate', 'CBFrate'};

% Split by 'Group'
group1_data = data(data.Group == 1, :);
group2_data = data(data.Group == 2, :);
