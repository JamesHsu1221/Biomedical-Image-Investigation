clc
clear
close all;

load("HW1_brain.mat");
origin_img = HW1_brain;

% question a
img_fourier = fft2(origin_img);
img_fourier_shift = fftshift(img_fourier);

magnitude = abs(img_fourier_shift);
real = real(img_fourier_shift);
imaginary = imag(img_fourier_shift);

figure(1);
subplot(1,3,1);
imshow (log(magnitude),[]), title('magnitude'), colorbar;
subplot(1,3,2);
imshow (real,[]), title('real part'), colorbar;
subplot(1,3,3);
imshow (imaginary,[]), title('imaginary part'), colorbar;

% reverse
img_magnitude_reverse = ifft2(ifftshift(magnitude));

figure(2);
subplot(1,2,1);
imshow (origin_img,[]), title('Original Image'), colorbar;
subplot(1,2,2);
imshow (abs(img_magnitude_reverse),[]), title('Reverse from magnitude'), colorbar;

% question b

% create a filter
[X,Y] = size(origin_img);
center = X/2; % Because the image is a square, so only create one center.
Q2_filter_matrix = zeros(X,Y);
Q2_filter_matrix((center-X/4 : center+X/4) , (center-Y/4 : center+Y/4)) = 1;

Q2_after_filter = img_fourier_shift .* Q2_filter_matrix;
Q2_after_filter_reverse = ifft2(ifftshift(Q2_after_filter));

figure(3);
subplot(1,2,1);
imshow (origin_img,[]), title('Original Image'), colorbar;
subplot(1,2,2);
imshow (abs(Q2_after_filter_reverse),[]), title('Reverse after M/2 filter'), colorbar;

% question c

% create a gaussian lowpass filter
[Q3_x , Q3_y] = meshgrid (1:X,1:Y);
filter_distance = sqrt((Q3_x-X/2).^2 + (Q3_y-Y/2).^2);
Q3_gaussian_filter_20 = exp(-(filter_distance.^2)/(2*20^2));
Q3_gaussian_filter_40 = exp(-(filter_distance.^2)/(2*40^2));

Q3_after_filter_20 = img_fourier_shift .* Q3_gaussian_filter_20;
Q3_after_filter_40 = img_fourier_shift .* Q3_gaussian_filter_40;
Q3_after_filter_20_reverse = ifft2(ifftshift(Q3_after_filter_20));
Q3_after_filter_40_reverse = ifft2(ifftshift(Q3_after_filter_40));

figure(4);
subplot(1,2,1);
imshow (abs(Q3_after_filter_20_reverse),[]), title('Gaussian lowpass D0=20'), colorbar;
subplot(1,2,2);
imshow (abs(Q3_after_filter_40_reverse),[]), title('Gaussian lowpass D0=40'), colorbar;




