function diff = calDiff(Img, snakeX, snakeY)
%CALDIFF calculate the difference between the real edge and detected edge
%   Detailed explanation goes here
[sy sx] = size(Img);
edge = zeros(sy, sx);
edge(1:sy-1, 1:sx-1) = abs(Img(1:sy-1, 1:sx-1) - Img(1:sy-1, 2:sx)) ...
    + abs(Img(1:sy-1, 1:sx-1) - Img(2:sy, 1:sx-1));
snakeX = ceil(snakeX);
snakeY = ceil(snakeY);
sum = 0;
for i=1:size(snakeX)
    radius = min(sy, sx);
    result = 0;

    for r = 1:radius
%         fprintf('r=%d, x=%d, y=%d\n', radius, snakeX(i), snakeY(i));
%         if snakeX(i) == 11
%             fprintf('');
%         end
        for x = (snakeX(i)-radius):(snakeX(i)+radius)
            if (x < 1) || (x > sx)
                continue;
            end
            y1 = snakeY(i) + (radius - abs(x-snakeX(i)));
            y2 = snakeY(i) - (radius - abs(x-snakeX(i)));
            if (y1 < 1) || (y1 > sy) || (y2 < 1) || (y2 > sy)
                continue;
            end
            if (edge(y1, x) ~= 0) || (edge(y2, x) ~= 0)
                result = 1;
                break;
            end
        end
        if result ~= 0
            break;
        end
    end
    
    if r < 1.1
        rr = 0;
    elseif r <2.1
        rr = 1;
    else
        rr = r;
    end
    if rr > 10
        disp('');
    end
    rr = rr^2;
    sum = sum + rr;
end

sizeSnake = size(snakeX);
sum
diff = sqrt(sum/sizeSnake(1));

end