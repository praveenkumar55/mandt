% function [u, v] = addmask(fx, fy)
% %ADDMASK Summary of this function goes here
% %   Detailed explanation goes here
% yz = -1;
% % by jimmy
% % mask.bmp : 48*116
% mask = imread('mask.bmp');
% mask = double(mask);
% mask = mask/max(max(mask))
% sizeMask = size(mask);
% sizeImage = size(fx);
% if isnan(fx)
%      disp('Warning 13!\n');
% end
% u = fx;
% v = fy;
% mag = fx.^2+fy.^2;
% if (sizeMask(1) == sizeImage(1)-2) && (sizeMask(2) == sizeImage(2)-2)
%     if yz < 0
%         for i=1:sizeMask(1)
%             for j = 1:sizeMask(2)
%                 u(i+1, j+1) = mask(i, j) * fx(i+1, j+1);
%                 v(i+1, j+1) = mask(i, j) * fy(i+1, j+1);
%             end
%         end
%     else
%         for i=1:sizeMask(1)
%             for j = 1:sizeMask(2)
%                 if mag(i,j) < yz
%                     u(i+1, j+1) = mask(i, j) * fx(i+1, j+1);
%                     v(i+1, j+1) = mask(i, j) * fy(i+1, j+1);
%                 end
%             end
%         end
%     end
% else
%     disp('size miss match!');
% end
% if isnan(u)
%      disp('Warning 43!\n');
% end

function maskF = addmask(gradI, direI)

% simple mask define how to add a mask to photo
% simpleMask = 1: 简单相乘
% simpleMask = 2: 有条件相乘
% simpleMask = 3: 带方向相乘
% simpleMask = 1*: 局部加强 -- 效果很差，得想其他办法
simpleMask = 3;
exponent = 10;
mSize = 2;

%ADDMASK Summary of this function goes here
%   Detailed explanation goes here
% yz = -1;

if mod(simpleMask,10) == 1
    % by jimmy
    % mask.bmp : 48*116
    if exist('mask.bmp', 'file') == 2
        mask = imread('mask.bmp');
    else
        mask = imread('../mask.bmp');
    end
    if mask(1,1) > 128
        mask = 255 - mask;
    end
    mask = double(mask);
    mask = mask/max(max(mask));
    maskF = mask.*gradI;
    
elseif mod(simpleMask,10) >= 2 
    if exist('mask.bmp', 'file') == 2
        mask = imread('mask.bmp');
    else
        mask = imread('../mask.bmp');
    end
    if mask(1,1) > 128
        mask = 255 - mask;
    end
    mask = double(mask);
    mask = mask/max(max(mask));
    [sy sx] = size(mask);
    for i=1:sy
        for j=1:sx
            mask(i,j) = 1 - (1-mask(i,j))^exponent;
        end
    end
    maskF = mask.*double(gradI);
end
    
if mod(simpleMask,10) == 3
    if exist('./mask.mat', 'file') == 2
        load('./mask.mat');
    else
        load('../mask.mat');
    end

    % check size
    maskSize = size(maskD);
    if (sy ~= maskSize(1)) || (sx ~= maskSize(2))
        error('Size Miss Match!');
    end

    for i=1:sy
        for j=1:sx
            switch direI(i,j)
                case 1
                    weight = maskD(i,j,1) + 0.8*maskD(i,j,2) + 0.8*maskD(i,j,6);
                case 2
                    weight = maskD(i,j,2) + 0.8*maskD(i,j,1) + 0.8*maskD(i,j,3);
                case 3
                    weight = maskD(i,j,3) + 0.8*maskD(i,j,2) + 0.8*maskD(i,j,4);
                case 4
                    weight = maskD(i,j,4) + 0.8*maskD(i,j,3) + 0.8*maskD(i,j,5);
                case 5
                    weight = maskD(i,j,5) + 0.8*maskD(i,j,4) + 0.8*maskD(i,j,6);
                case 6
                    weight = maskD(i,j,6) + 0.8*maskD(i,j,5) + 0.8*maskD(i,j,1);
            end
%             weight = 1-(1-weight)^3;
            maskF(i,j) = maskF(i,j) * weight;
        end
    end
end

if uint8(simpleMask/10) == 1
    [sy sx] = size(maskF);
    for i = mSize+1:sy-mSize
        for j = mSize+1:sx-mSize
            neigh = maskF(i-mSize:i+mSize, j-mSize:j+mSize);
            maxV = max(max(neigh));
            if maxV > 50
                maskF(i,j) = maskF(i,j)/((maxV+40)^0.7);
            else
                maskF(i,j) = 0;
            end
        end
    end
end

end



