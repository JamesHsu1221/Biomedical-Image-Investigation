load("HW1_brain.mat");

%image test
%origin_image=mat2gray(HW1_brain);
%imshow(origin_image);

%question A

level = 8;    % intensity level setting（1~8）
intensity_level = power(2,level);
max_num = max(HW1_brain(:))+0.001;    %加0.001是為了不要讓最大的那一個數變額外的整數
gap = (max_num/intensity_level);    %作為取樣間隔
adjust_image = floor(HW1_brain/gap);
final_image = mat2gray(adjust_image);
imshow(final_image);

