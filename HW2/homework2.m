
load("HW2_brain.mat");
first_data = HW2_brain;

%question a

[number , value] = imhist(first_data);    %將原資料分析出個數值的數量
figure(1);
bar(value,number);    %畫出各數值的數量長條圖
title('original histogram' );
xlabel('value');
ylabel('quantity');

%question b

pixels = numel(first_data);    %計算圖片像素
pdf = number / pixels;    %計算pdf
cdf = cumsum(pdf);    %計算cdf，利用累加的函數
TF = uint8(round(cdf*255));    %將算出的cdf範圍變成[0,255]當作transfer function
adjust_data = TF(first_data+1);    %+1是因為原始資料從0開始，但TF從1開始

adjust_data_by_histeq = histeq(first_data);    %利用histeq進行轉換

%show the image
figure(2);
subplot(1,2,1);
imshow(adjust_data);
title('Histogram Normalization');

subplot(1,2,2);
imshow(adjust_data_by_histeq);
title('Histogram Normalization by histeq');

%Transfer Function
figure(3);
plot(value,TF);
title('Transfer Function');
xlim([0 255]);
ylim([0 256]);

%histeq
[number_TF , value_TF] = imhist(adjust_data);
[number_histeq , value_hsiteq] = imhist(adjust_data_by_histeq);

figure(4);
subplot(1,2,1);
bar(value_TF,number_TF);
title('Histogram after Transfer');
xlabel('value');
ylabel('quantity');

subplot(1,2,2);
bar(value_hsiteq,number_histeq);
title('Histogram after Transfer by histeq');
xlabel('value');
ylabel('quantity');
