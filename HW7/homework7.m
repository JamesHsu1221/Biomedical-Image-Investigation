clc
clear
close all;

load("HW7_T1brain.mat");
Origin_img = T1brain;

% question a
lowThreshold = 0.1;
highThreshold = 0.32;
sigma = 1.7;
[edgeResult, threshold] = edge(Origin_img, 'Canny', [lowThreshold highThreshold], sigma);

figure(1);
subplot(1, 2, 1);
imshow(Origin_img,[]); title('Original Image');
subplot(1, 2, 2);
imshow (edgeResult); title('Canny Image');

% question b
TH = 200;
TL = 100;
sig = 2;

[E, M, A, Gx, Gy, threshold_image] = canny(Origin_img, sig, TH, TL);

figure(2);
subplot(1, 2, 1);
imshow(edgeResult); title('Canny Edge Result');
subplot(1, 2, 2);
imshow (threshold_image); title('Self made Canny Edge Result');

% question 3

% graythresh function only can input the range between 0 and 1 
Image_in_01 = rescale(Origin_img);
otsu_threshold = graythresh(Image_in_01);
otsu_image = imbinarize(Image_in_01, otsu_threshold);

figure(3);
subplot(1, 2, 1);
imshow(Origin_img,[]); title('Original Image');
subplot(1, 2, 2);
imshow(otsu_image); title('After Otsu thresholding');

% observe histogram
[number , value] = imhist(Image_in_01);
figure(4);
bar(value,number);
title('Original histogram' );
xlabel('value');
ylabel('quantity');

% question 3 test (adjust the threshold to see the result)
test_otsu_threshold = otsu_threshold*1.85;
test_otsu_image = imbinarize(Image_in_01, test_otsu_threshold);

figure(5);
subplot(1, 3, 1);
imshow(Origin_img,[]); title('Original Image');
subplot(1, 3, 2);
imshow(otsu_image); title('Original Otsu Image');
subplot(1, 3, 3);
imshow(test_otsu_image); title('Test Otsu Image');


function [E, M, A, Gx, Gy, threshold_image] = canny(I, sig, TH, TL)
    % default TH and TL if we don't input
    if nargin < 3
        TH = 0.1;
        TL = 0.1;
    end

    % gaussian smooth
    I_gaussian = imgaussfilt(double(I),sig);

    % gradient
    [Gx, Gy] = imgradientxy(I_gaussian, "sobel");

    % magnitude and direction
    M = sqrt(Gx.^2 + Gy.^2);
    A = atan2d(Gy, Gx);
    
    % non-maximum suppression
    [row, col] = size(I);
    E = zeros(row, col);

    for i = 2:row-1
        for j = 2:col-1
            % find the edge normal
            if ((A(i,j) >= -22.5 && A(i,j) <= 22.5) || A(i,j) >= 157.5 || (A(i,j) <= -157.5))
                neighbors = [M(i, j+1), M(i, j-1)];
            elseif (A(i,j) > 22.5 && A(i,j) < 67.5 || A(i,j) > -157.5 && A(i,j) < -112.5)
                neighbors = [M(i+1, j-1), M(i-1, j+1)];
            elseif (A(i,j) >= 67.5 && A(i,j) <= 112.5 || A(i,j) >= -112.5 && A(i,j) <= -67.5)
                neighbors = [M(i+1, j), M(i-1, j)];
            else
                neighbors = [M(i-1, j-1), M(i+1, j+1)];
            end          
            % compare the magnitudes if neighborint pixels
            if (M(i, j) >= neighbors(1)) && (M(i, j) >= neighbors(2))
                E(i, j) = M(i, j);
            else
                E(i, j) = 0;
            end
        end
    end
    
    % Determine strond edges or weak edges
    threshold_image = zeros(row, col);
    strong_edges = (E >= TH);
    weak_edges = (E >= TL) & (E < TH);

    % Determine whether to connect
    for i = 6:row-5
        for j = 6:col-5
            if strong_edges(i, j)
                threshold_image(i, j) = 1;
            elseif weak_edges(i, j)
            neighborhood = strong_edges(i-5:i+5, j-5:j+5);
                if any(neighborhood(:))
                    threshold_image(i, j) = 1;
                end
            end
        end
    end 
end