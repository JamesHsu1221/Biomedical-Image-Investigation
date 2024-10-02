
RGB_img = imread('HW3.jpg');
origin_img = rgb2gray(RGB_img);

%Prewitt
prewitt_img = edge(origin_img,'prewitt');

%sobel
sobel_img = edge(origin_img,'sobel');

figure(1);
subplot(1,3,1);
imshow(origin_img);
title('Origin Image');
subplot(1,3,2);
imshow(prewitt_img);
title('Prewitt Edge Detection');
subplot(1,3,3);
imshow(sobel_img);
title('Sobel Edge Detection');

%question 1-a X-gradient and Y-gradient
[prewitt_gradX , prewitt_gradY] = imgradientxy(prewitt_img);
[sobel_gradX , sobel_gradY] = imgradientxy(sobel_img);

%question 1-b gradient magnitude
[prewitt_mag , prewitt_dir] = imgradient(prewitt_gradX , prewitt_gradY);
[sobel_mag , sobel_dir] = imgradient(sobel_gradX , sobel_gradY);

%question 1-c thresholding
threshold = 4;
after_threshold_prewitt = prewitt_mag >= threshold;
after_threshold_sobel = sobel_mag >= threshold;

figure(2);
subplot(1,2,1);
imshow(after_threshold_prewitt);
title('After threshold Prewitt Image');
subplot(1,2,2);
imshow(after_threshold_sobel);
title('After threshold Sobel Image');

% 1-e 先使用imadjust加強對比
adjust_img = imadjust(origin_img);
[adjust_sobel_gradX , adjust_sobel_gradY] = imgradientxy(edge(adjust_img,'sobel'));
[adjust_sobel_mag , adjust_sobel_dir] = imgradient(adjust_sobel_gradX , adjust_sobel_gradY);
after_threshold_adjust_sobel = adjust_sobel_mag >= threshold;
figure(3);
subplot(1,2,1);
imshow (after_threshold_adjust_sobel);
title('Use imadjust');
subplot(1,2,2);
imshow(after_threshold_sobel);
title('Not use imadjust');