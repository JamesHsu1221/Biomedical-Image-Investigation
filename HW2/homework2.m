
load("HW2_brain.mat");
first_data = HW2_brain;

% a小題

figure(1);
histogram(first_data);
title('HW2 brain''s histogram' );
xlabel('數值');
ylabel('數量');
