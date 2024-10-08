clear
close all;

load("HW1_brain.mat");
origin_img = HW1_brain;
figure(1);
imshow (origin_img,[]);
colorbar;

% question 1
img_fourier = fft(origin_img);
img_fourier_shift = fftshift(img_fourier);

magnitude = abs(img_fourier_shift);
real = real(img_fourier_shift);
imaginary = imag(img_fourier_shift);

figure(2);
subplot(1,3,1);
imshow (log(magnitude),[]);
colorbar;
subplot(1,3,2);
imshow (log(real),[]);
colorbar;
subplot(1,3,3);
imshow (log(imaginary),[]);
colorbar;
