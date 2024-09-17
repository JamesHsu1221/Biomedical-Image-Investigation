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
final_image = mat2gray(adjust_image); %將最後的數值歸一化
figure(1);
imshow(final_image);

%question B (line 21 is question A's code but always 8bits)

adjust_image_B = uint8(floor(HW1_brain/(max_num/256))); % merge line 11 to line 14 and change it to int8bit
MSB_8bits = bitand(adjust_image_B,128);
figure(2);
imshow(MSB_8bits);

%question C
MSB_8bits_0 = bitand(adjust_image_B,127);
figure(3);
imshow(MSB_8bits_0);

