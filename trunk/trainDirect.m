function trainDirect()
width = 48;
height = 116;
mSize = 3;
maskD = zeros(height, width, 6);
count = 0;
dataDir = 'D:\jimmy\program\trainset\';
files = dir(dataDir);

% train
for i=1:(size(files))(1);
    sizeTest = size(findstr(files(i).name, 'bmp'));
    if (sizeTest(1) == 0)
        continue;
    end
    img = imread(strcat(dataDir,files(i).name));
    sizeImg = size(img);
    if (sizeImg(1) ~= height) || (sizeImg(2) ~= width)
        disp('Wrong Size!');
        continue;
    end

    dImg = double(img);
    [gradI direI] = blurAgrad(dImg, 0);
    for p=1:height
        for q = 1:width
            maskD(p, q, uint16(direI(p,q))) = maskD(p, q, uint16(direI(p,q))) + gradI(p, q);
        end
    end

    count = count + 1;
end

% 7*7 average
newMaskD = zeros(size(maskD));
for i=mSize+1:height-mSize
    for j=mSize+1:width-mSize
        sum = 1e-8;
        for k=1:6
            for p = -mSize:mSize
                for q = -mSize:mSize
                    newMaskD(i,j,k) = maskD(i+p,j+q,k) + newMaskD(i,j,k);
                end
            end
            newMaskD(i,j,k) = newMaskD(i,j,k)/(2*mSize+1)/(2*mSize+1);
            sum = sum + newMaskD(i,j,k);
        end
        % normalize
        for k=1:6
            newMaskD(i,j,k) = newMaskD(i,j,k) / sum;
        end
    end
end
maskD = newMaskD;

save('mask.mat', 'maskD');
disp('training done!')
end