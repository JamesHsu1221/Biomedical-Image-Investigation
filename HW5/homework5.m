clc
clear
close all;

load("HW5_ima1.mat");
load("HW5_ima2.mat");
load("HW5_ima3.mat");
img_1 = ima1;
img_2 = ima2;
img_3 = ima3;

% Problem 1-a
% Img 1
figure(1);
roi_1 = roipoly(img_1);
roi_1_img = img_1 .* uint8(roi_1); %show the part where I choose
subplot(1,2,1);
imshow(roi_1_img);
title('area where I choose in Img 1')

roi_1_img_pixel = img_1(roi_1);
[number_1 , value_1] = imhist(roi_1_img_pixel); %將原資料分析出個數值的數量

subplot(1,2,2);
bar(value_1,number_1); %畫出各數值的數量長條圖
title('Image1 roipoly histogram' ), xlabel('value'), ylabel('quantity');

mean_1 = mean(roi_1_img_pixel);  % 計算 ROI 像素的均值
std_1 = std(double(roi_1_img_pixel));  % 計算 ROI 像素的標準差
fprintf ('This picture mean = %f, std = %f\n', mean_1, std_1);

% Img 2
figure(2);
roi_2 = roipoly(img_2);
roi_2_img = img_2 .* uint8(roi_2); %show the part where I choose
subplot(1,2,1);
imshow(roi_2_img);
title('area where I choose in Img 2')

roi_2_img_pixel = img_2(roi_2);
[number_2 , value_2] = imhist(roi_2_img_pixel); %將原資料分析出個數值的數量

subplot(1,2,2);
bar(value_2,number_2); %畫出各數值的數量長條圖
title('Image2 roipoly histogram' ), xlabel('value'), ylabel('quantity');

mean_2 = mean(roi_2_img_pixel);  % 計算 ROI 像素的均值
std_2 = std(double(roi_2_img_pixel));  % 計算 ROI 像素的標準差
fprintf ('This picture mean = %f, std = %f\n', mean_2, std_2);

% Problem 1-b
% create mean filter for Img 1
filter_1 = [1/9 1/9 1/9;1/9 1/9 1/9;1/9 1/9 1/9];
img_1_mean = imfilter(img_1,filter_1);

figure(3);
subplot(1,2,1);
imshow (img_1,[]);
title('Original Image 1');
subplot(1,2,2);
imshow (img_1_mean,[]);
title('Image 1 after mean filter');

% mean and median filter for Img 2
img_2_filter_mean = imfilter(img_2,filter_1);
img_2_filter_median = medfilt2(img_2);

figure(4);
subplot(1,3,1);
imshow (img_2,[]);
title('Original Image 2');
subplot(1,3,2);
imshow (img_2_filter_mean,[]);
title('Image 2 after mean filter');
subplot(1,3,3);
imshow (img_2_filter_median,[]);
title('Image 2 after median filter');

% Problem 2

len = 6;
theta = 5;
NSR = 0.15;

motion = fspecial('motion', len, theta);
wiener = deconvwnr(img_3, motion, NSR);

figure(5);
subplot(1,2,1);
imshow (img_3,[]);
title('Original Image 3');
subplot(1,2,2);
imshow (wiener,[]);
title('Image 3 after Wiener');
