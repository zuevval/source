%n is messed up
rmax = zeros(2, 10); %max deviation in midpoints
figure
hold on
title('periodic net: cos(\pi\cdot x)');
n=100;
X = -1:2/n:1;
lagrange;
plot(X, Y1, 'LineWidth', 3)
k=1;
for n = [20, 10, 5, 3, 2]
    X = -1:2/n:1;
    Xmid = -1+1/n:2/n:1;
    lagrange;
    %plot(Xmid, Lnmid1);
    plot(Xdense, Ydense1);
    rmax(1, k) = max(R1);
    rmax(2, k) = max(R2);
    k = k+1;
end
legend('cos(\pi\cdot x)','n=21', 'n=11', 'n=6', 'n=4', 'n=3')

% figure
% hold on
% axis([-1, 1, -2, 2])
% title('periodic net: 1/(1+25(x^2))')
% n=100;
% X = -1:2/n:1;
% lagrange;
% plot(X, Y2, 'LineWidth', 3)
% for n = [10, 6, 5, 3, 2]
% %for n = [6, 5, 4, 3, 2]
    % X = -1:2/n:1;
    % Xmid = -1+1/n:2/n:1;
    % lagrange;
    % %plot(Xmid, Lnmid2);
    % plot(Xdense, Ydense2);
% end

% legend('y=1/(1+25(x^2))','n=11', 'n=7', 'n=6', 'n=4', 'n=3')

