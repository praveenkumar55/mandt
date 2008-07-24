function calinit()
%CALINIT Summary of this function goes here
%   Detailed explanation goes here
clear;

yz = 30;

I = imread('../mask.bmp');
[sy sx] = size(I);
count = 0;

for i = 1:sy
    for j = 1:sx
        if I(i,j) > yz
            count = count + 1;
            XSnake(count) = j; YSnake(count) = i;
            break;
        end
    end
end
for i = sy:-1:1
    for j = sx:-1:1
        if I(i,j) > yz
            count = count + 1;
            XSnake(count) = j; YSnake(count) = i;
            break;
        end
    end
end

% plot(XSnake, YSnake);

XSnake = double(XSnake');
YSnake = double(YSnake');

p = path;
path(p, '../snake');

[XSnake YSnake] = snakeinterp(XSnake,YSnake,2,0.5);

save('../snake.mat', 'XSnake', 'YSnake');

disp('Calculation of init snake done!');