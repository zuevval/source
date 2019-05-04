%n is messed up
rmax = zeros(2, 10); %max deviation in midpoints
% figure
% hold on
% title('Chebishev net: cos(\pi\cdot x)')
% n=100;
% X = zeros(1,n+1);
% for i = 0:1:n
    % X(1,i+1) = cos(pi*(2*i+1)/(2*n+2));
% end
% lagrange;
% plot(X, Y1, 'LineWidth', 2)
% for n = [20, 10, 5, 3, 2]
    % X = zeros(1,n+1);
    % for i = 0:1:n
        % X(1,i+1) = cos(pi*(2*i+1)/(2*n+2));
    % end
    % Xmid = zeros(1,n);
    % for i = 1:1:n
        % Xmid(1,i) = 0.5*(X(1,i)+X(1,i+1));
    % end
    % lagrange;
    % plot(Xdense, Ydense1);
% end

% legend('cos(\pi\cdot x)','n=21', 'n=11', 'n=6', 'n=4', 'n=3')

figure
hold on
title('Chebishev net: 1/(1+25(x^2))')
n=100;
X = zeros(1,n+1);
for i = 0:1:n
    X(1,i+1) = cos(pi*(2*i+1)/(2*n+2));
end
lagrange;
plot(X, Y2, 'LineWidth', 2)
for n = [20, 10, 5, 3, 2]
    X = zeros(1,n+1);
    for i = 0:1:n
        X(1,i+1) = cos(pi*(2*i+1)/(2*n+2));
    end
    Xmid = zeros(1,n);
    for i = 1:1:n
        Xmid(1,i) = 0.5*(X(1,i)+X(1,i+1));
    end
    lagrange;
    plot(Xdense, Ydense2);
end

legend('y=1/(1+25(x^2))','n=11', 'n=7', 'n=6', 'n=4', 'n=3')
