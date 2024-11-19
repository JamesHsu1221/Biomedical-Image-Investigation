clc
clear
close all;

load("HW8_Irad.mat");
load("HW8_Itof.mat");

% resize and normalization
Irad_resize = imresize(Irad, size(Itof));
reference_img = mat2gray(Irad_resize);
target_img = mat2gray(Itof);

% High intensity detection (get template from reference image)
tep_rows = 11;
tep_cols = 11;

template = ones(tep_rows, tep_cols);
[rows, cols] = size(reference_img);
idenity_map = imfilter(reference_img, template);
[~, max_index] = max(idenity_map(:));
[max_row, max_col] = ind2sub(size(idenity_map), max_index);
template = reference_img(max_row-5:max_row+5, max_col-5:max_col+5);

% Calculate MI map for reference image
MI_map = zeros(rows - tep_rows + 1, cols - tep_cols + 1);
[map_rows, map_cols] = size(MI_map);

for i = 1:map_rows
    for j = 1:map_cols

        area = reference_img(i:i+tep_rows-1, j:j+tep_cols-1);
        
        % Histogram
        joint_hist = histcounts2(template(:), area(:), [tep_rows, tep_cols] ...
            , 'Normalization', 'probability');
        template_hist = sum(joint_hist, 2); % Marginal histogram of template
        area_hist = sum(joint_hist, 1); % Marginal histogram of patch
        
        % Add bias to avoid division by zero
        bias = 0.00000001;
        joint_hist = joint_hist + bias;
        template_hist = template_hist + bias;
        area_hist = area_hist + bias;
        
        % Compute MI
        MI = sum(joint_hist(:) .* (log2(joint_hist(:) ./ reshape((template_hist * area_hist), [], 1))), 'all');
        MI_map(i, j) = MI;
    end
end

% Find the maximum location on MI map
[~, max_idx] = max(MI_map(:));
[ref_row, ref_col] = ind2sub(size(MI_map), max_idx);

% Same processing for target image
for i = 1:map_rows
    for j = 1:map_cols

        area = target_img(i:i+tep_rows-1, j:j+tep_cols-1);
        
        joint_hist = histcounts2(template(:), area(:), [tep_rows, tep_cols] ...
            , 'Normalization', 'probability');
        template_hist = sum(joint_hist, 2);
        area_hist = sum(joint_hist, 1);
        
        bias = 0.00000001;
        joint_hist = joint_hist + bias;
        template_hist = template_hist + bias;
        area_hist = area_hist + bias;
        
        MI = sum(joint_hist(:) .* (log2(joint_hist(:) ./ reshape((template_hist * area_hist), [], 1))), 'all');
        MI_map(i, j) = MI;
    end
end

[~, max_idx] = max(MI_map(:));
[target_row, target_col] = ind2sub(size(MI_map), max_idx);

% plot (mark area)
figure(1);

subplot(1, 3, 1);
imshow(template, []);
title('Template image (SSS)');

subplot(1, 3, 2);
imshow(reference_img, []);
title('Template in Irad image');
rectangle('Position', [ref_col, ref_row, tep_cols, tep_rows], ...
          'EdgeColor', 'r', 'LineWidth', 2);

subplot(1, 3, 3);
imshow(target_img, []);
title('Template in Itof image');
rectangle('Position', [target_col, target_row, tep_cols, tep_rows], ...
          'EdgeColor', 'r', 'LineWidth', 2);

% plot (overlaid image)
% create two mask from different image 
mask_ref = zeros(rows, cols);
mask_ref(ref_row:ref_row+tep_rows-1, ref_col:ref_col+tep_cols-1) = template;

mask_target = zeros(rows, cols);
mask_target(target_row:target_row+tep_rows-1, target_col:target_col+tep_cols-1) = template;

figure(2);
% original reference image
subplot(1, 2, 1);
imshow(reference_img);
hold on;
% overlaid
h = imshow(cat(3, mask_ref, zeros(size(mask_ref)), zeros(size(mask_ref))));
set(h, 'AlphaData', mask_ref * 0.5);
title('Overlaid template on Irad Image');

subplot(1, 2, 2);
imshow(target_img);
hold on;
h = imshow(cat(3, mask_target, zeros(size(mask_target)), zeros(size(mask_target))));
set(h, 'AlphaData', mask_target * 0.5);
title('Overlaid template on Itof Image');
