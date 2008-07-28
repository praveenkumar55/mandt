function [gradI direI] = blurAgrad(I, sigma)
%   Calculate the gradient and direction of an image
[sy sx] = size(I);
dx = zeros([sy sx]);
dy = zeros([sy sx]);

I = double(I);
if sigma~=0 
   f = gaussianBlur(I,sigma);
else
   f = I;
end;

dy(2:sy-1, 2:sx-1) = f(1:sy-2, 1:sx-2) + 2*f(1:sy-2, 2:sx-1) + f(1:sy-2, 3:sx) - ...
    f(3:sy, 1:sx-2) - 2*f(3:sy, 2:sx-1) - f(3:sy, 3:sx);
dx(2:sy-1, 2:sx-1) = f(1:sy-2, 1:sx-2) + 2*f(2:sy-1, 1:sx-2) + f(3:sy, 1:sx-2) - ...
    f(1:sy-2, 3:sx) - 2*f(2:sy-1, 3:sx) - f(3:sy, 3:sx);

gradI = abs(dx) + abs(dy);
direI = zeros([sy sx]);
for i=1:sy
    for j=1:sx
        if dy(i, j) < -1.732*dx(i, j)
            direI(i, j) = 1;
        elseif dy(i, j) < -0.5773*dx(i, j)
            direI(i, j) = 2;
        elseif dy(i, j) < 0
            direI(i, j) = 3;
        elseif dy(i, j) < 0.5773*dx(i, j)
            direI(i, j) = 4;
        elseif dy(i, j) < 1.732*dx(i, j)
            direI(i, j) = 5;
        else
            direI(i, j) = 6;
        end
    end
end