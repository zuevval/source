%save('stone_data.m', 'x_alpha_0_7');
%save('stone_data.m', 'y_alpha_0_7');
%save('stone_data.m', 'x_alpha_0_3');
%save('stone_data.m', 'y_alpha_0_3');
%save('stone_data.m', 'x_alpha_1_1');
%save('stone_data.m', 'y_alpha_1_1');
%save('stone_data.m', 'x_k_0_6');
%save('stone_data.m', 'y_k_0_6');
%save('stone_data.m', 'x_k_0_0_6');
%save('stone_data.m', 'y_k_0_0_6');
%save('stone_data.m', 'x_v0_30');
%save('stone_data.m', 'y_v0_30');
save('stone_data.m', 'x_v0_50');
save('stone_data.m', 'y_v0_50');
%load('stone_data.m', '-mat', 'x_alpha_0_7');
%load('stone_data.m', '-mat', 'y_alpha_0_7');
figure
hold on
grid on
title ('flight of solid body');
plot (x_alpha_0_7(1:54,2), y_alpha_0_7(1:54,2));
plot(x_alpha_0_3(1:29,2), y_alpha_0_3(1:29,2));
plot (x_alpha_1_1(1:57,2), y_alpha_1_1(1:57,2));
legend('\alpha=0.7','\alpha=0.3','\alpha=1.1');

figure
hold on
grid on
title ('various k');
plot (x_alpha_1_1(1:57,2), y_alpha_1_1(1:57,2));
plot (x_k_0_0_6(1:54,2), y_k_0_0_6(1:54,2));
plot (x_k_0_6(1:43,2), y_k_0_6(1:43,2));
legend('k=0.006','k=0.06','k=0.6');

figure
hold on
grid on
title ('various v_0');
plot (x_alpha_0_7(1:54,2), y_alpha_0_7(1:54,2));
plot (x_v0_50(1:33,2), y_v0_50(1:33,2));
plot (x_v0_30(1:23,2), y_v0_30(1:23,2));