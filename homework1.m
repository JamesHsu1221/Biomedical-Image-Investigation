load("HW1_brain.mat");

%image test 
%origin_image=mat2gray(HW1_brain);
%imshow(origin_image);

%question A

bits = 8;    % intensity level setting（1~8）

intensity_level = power(2,bits);
max_num = max(HW1_brain(:))+0.001;    %加0.001是為了不要讓最大的那一個數變額外的整數
gap = (max_num/intensity_level);    %作為取樣間隔
adjust_image = floor(HW1_brain/gap);
final_image = mat2gray(adjust_image);
figure(1);
imshow(final_image);

%question B (question A's bits must be 8)
MSB_8bits = bitand(adjust_image,128);
figure(2);
imshow(mat2gray(MSB_8bits));



