clc
clear
close all;

I = imread('gantrycrane.png');
I_gray = rgb2gray(I);

% question 1-a
sig = 1;
[E, M, A, Gx, Gy] = canny(I_gray, sig);

figure(1);
subplot(2, 3, 1);
imshow(I); title('Original Image');
subplot(2, 3, 2);
imshow(E, []); title('Edge Map (E)');
subplot(2, 3, 3);
imshow(M, []); title('gradient magnitude (M)');
subplot(2, 3, 4);
imshow(A, []); title('gradient angle (A)');
subplot(2, 3, 5);
imshow(Gx, []); title('gradient components (Gx)');
subplot(2, 3, 6);
imshow(Gy, []); title('gradient components (Gy)');

% question 1-b

sigma_values = [1, 2, 3];

figure(2);
for i = 1:3
    [E_1b] = canny(I_gray, sigma_values(i));
    
    subplot(1, 3, i);
    imshow(E_1b, []); 
    title(['Edge Map (σ = ' num2str(sigma_values(i)) ')']);
end

% question 1-c

threshold = [2, 6, 10];
TH = 30;

figure(3);
for x = 1:3

    TL = TH / threshold(x);
  
    [E, M, A, Gx, Gy, threshold_image] = canny(I_gray, sig, TH, TL);
    
    subplot(1, 3, x);
    imshow(threshold_image, []); 
    title(['Edge Map (TH/TL = ' num2str(threshold(x)) ')']);
end

% question 2
[H, theta, rho] = hough(E_1b);

% find the peak
peaks = houghpeaks(H, 20, 'threshold', round(0.1 * max(H(:))));

% filter and save vertical lines
filtered_peaks = []; 
for i = 1:size(peaks, 1)
    if theta(peaks(i, 2)) >= -1 && theta(peaks(i, 2)) <= 1
        filtered_peaks = [filtered_peaks; peaks(i, :)];
    end
end

% use houghline to extract line, use 'FillGap' to connect the line
lines = houghlines(E, theta, rho, filtered_peaks, 'FillGap', 60);

figure(4);
subplot(1, 3, 1);
imshow(imadjust(rescale(H)),'XData',theta,'YData',rho);
title('Hough transform');
xlabel('\theta'), ylabel('\rho');
axis on, axis normal, hold on;

subplot(1, 3, 2);
imshow(E_1b);
% plot the vertical line and add on the image
hold on;
for k = 1:length(lines)
    xy = [lines(k).point1; lines(k).point2];
    plot(xy(:,1), xy(:,2), 'LineWidth', 2, 'Color', 'green');
end
hold off;
title('Edge map with vertical Lines');

subplot(1, 3, 3);
imshow(I);
hold on;
for k = 1:length(lines)
    xy = [lines(k).point1; lines(k).point2];
    plot(xy(:,1), xy(:,2), 'LineWidth', 2, 'Color', 'green');
end
hold off;
title('Original image with vertical Lines');

% test for question 2 (setting sigma = 1)
% Same code with question 2, but set the sigma = 1
[E] = canny(I_gray, 1);
[H, theta, rho] = hough(E);
peaks = houghpeaks(H, 20, 'threshold', round(0.1 * max(H(:))));
filtered_peaks = []; 
for i = 1:size(peaks, 1)
    if theta(peaks(i, 2)) >= -1 && theta(peaks(i, 2)) <= 1
        filtered_peaks = [filtered_peaks; peaks(i, :)];
    end
end
lines = houghlines(E, theta, rho, filtered_peaks, 'FillGap', 60);

figure(5);
subplot(1, 2, 1);
imshow(E);
hold on;
for k = 1:length(lines)
    xy = [lines(k).point1; lines(k).point2];
    plot(xy(:,1), xy(:,2), 'LineWidth', 2, 'Color', 'green');
end
hold off;
title('Edge map(sigma=1) with vertical Lines');

subplot(1, 2, 2);
imshow(I);
hold on;
for k = 1:length(lines)
    xy = [lines(k).point1; lines(k).point2];
    plot(xy(:,1), xy(:,2), 'LineWidth', 2, 'Color', 'green');
end
hold off;
title('Original image with vertical Lines');

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
