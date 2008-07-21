function trainDirect()
    width = 48;
    height = 116;
    mask0 = zeros(height, width);
    mask1 = zeros(height, width);
    mask2 = zeros(height, width);
    mask3 = zeros(height, width);
    mask4 = zeros(height, width);
    mask5 = zeros(height, width);
    count = 0;
    dataDir = 'D:\jimmy\program\trainset\';
    files = dir(dataDir);
    
    % train
    for i=1:(size(files))(1)
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
                switch direI(p, q)
                    case 0 
                        mask0(p, q) = mask0(p, q) + gradI(p, q);
                    case 1
                        mask1(p, q) = mask1(p, q) + gradI(p, q);
                    case 2
                        mask2(p, q) = mask2(p, q) + gradI(p, q);
                    case 3
                        mask3(p, q) = mask3(p, q) + gradI(p, q);
                    case 4
                        mask4(p, q) = mask4(p, q) + gradI(p, q);
                    case 5
                        mask5(p, q) = mask5(p, q) + gradI(p, q);
                end
            end
        end
        
        count = count + 1;
    end
    
    % normalize
    mask0 = mask0 * 6 / count;
    mask1 = mask1 * 6 / count;
    mask2 = mask2 * 6 / count;
    mask3 = mask3 * 6 / count;
    mask4 = mask4 * 6 / count;
    mask5 = mask5 * 6 / count;
    save('mask.mat', 'mask0', 'mask1', 'mask2', 'mask3', 'mask4', 'mask5');
    disp('training done!')
end