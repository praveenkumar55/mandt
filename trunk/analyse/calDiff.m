function diff = calDiff(Img, snakeX, snakeY)
%CALDIFF calculate the difference between the real edge and detected edge
%   Detailed explanation goes here
[sy sx] = size(Img);
edge(1:sy-1, 1:sx-1) = abs(Img(1:sy-1, 1:sx-1) - Img(1:sy-1, 2:sx)) ...
    + abs(Img(1:sy-1, 1:sx-1) - Img(2:sy, 1:sx-1));
snakeX = ceil(snakeX);
snakeY = ceil(snakeY);

sum = 0;
for i=1:size(snakeX)
    radius = min([snakeX(i) snakeY(i) sx-snakeX(i) sy-snakeY(i)])-2;
    result = 0;

    for r = 1:radius
%         fprintf('r=%d, x=%d, y=%d\n', radius, snakeX(i), snakeY(i));
%         if snakeX(i) == 11
%             fprintf('');
%         end
        for x = (snakeX(i)-radius):(snakeX(i)+radius)
            y1 = snakeY(i) + (radius - abs(x-snakeX(i)));
            y2 = snakeY(i) - (radius - abs(x-snakeX(i)));
            if (edge(y1, x) ~= 0) || (edge(y2, x) ~= 0)
                result = r;
                break;
            end
        end
        if result ~= 0
            break;
        end
    end

    sum = sum + r;
end

sizeSnake = size(snakeX);
diff = sum/sizeSnake(1);

end