function newImg = addSnake(img, snakeX, snakeY)
%ADDSNAKE Summary of this function goes here
%   Detailed explanation goes here
    [sy sx] = size(img);
    newImg = uint8(zeros([sy, sx, 3]));
    minImg = min(min(img));
    maxImg = max(max(img));
    img = uint8((img-minImg)/(maxImg-minImg)*255);
    for i=1:sy
        for j=1:sx
            newImg(i, j, 1) = img(i, j);
            newImg(i, j, 2) = img(i, j);
            newImg(i, j, 3) = img(i, j);
        end
    end
    
    for i = 1:size(snakeX)
        x = uint8(snakeX(i));
        y = uint8(snakeY(i));
%         fprintf('x = %d, y = %d\n', x, y);
        newImg(y, x, 1) = 255;
        newImg(y, x, 2) = 0;
        newImg(y, x, 3) = 0;
        
        xx = x + 1;
        yy = y;
        if (xx > 0) && (xx <= sx ) && (yy > 0) && (yy <= sy)
            newImg(yy, xx, 1) = 255;
            newImg(yy, xx, 2) = 0;
            newImg(yy, xx, 3) = 0;
        end
        
        xx = x - 1;
        yy = y;
        if (xx > 0) && (xx <= sx ) && (yy > 0) && (yy <= sy)
            newImg(yy, xx, 1) = 255;
            newImg(yy, xx, 2) = 0;
            newImg(yy, xx, 3) = 0;
        end
        
        xx = x;
        yy = y + 1;
        if (xx > 0) && (xx <= sx ) && (yy > 0) && (yy <= sy)
            newImg(yy, xx, 1) = 255;
            newImg(yy, xx, 2) = 0;
            newImg(yy, xx, 3) = 0;
        end
        
        xx = x;
        yy = y - 1;
        if (xx > 0) && (xx <= sx ) && (yy > 0) && (yy <= sy)
            newImg(yy, xx, 1) = 255;
            newImg(yy, xx, 2) = 0;
            newImg(yy, xx, 3) = 0;
        end
    end
end