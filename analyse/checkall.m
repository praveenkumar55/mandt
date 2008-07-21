function checkall()
%CHECKALL It checks all the images in a same directory
%   Detailed explanation goes here

clear;

% parameter
width = 48;
height = 116;
alpha = 0.5;
beta = 1;
gamma = 1;
kappa = 0;
dmin = 0.5;
dmax = 2;
sigma = 1;
mu = 0.1;
NoGVFIterations = 40;
NoSnakeIterations = 300;

testDir = 'D:\jimmy\program\testset\';
resultDir = 'D:\jimmy\program\trainset\';
outputDir = 'D:\jimmy\program\outputset\';
p = path;
path(p, '../snake;');

files = dir(testDir);
sizeFiles = size(files);
for i=1:sizeFiles(1)

    % read in file
    sizeTest = size(findstr(files(i).name, 'bmp'));
    if (sizeTest(1) == 0)
        continue;
    end
    img = imread(strcat(testDir,files(i).name));
    
    sizeImg = size(img);
    if (sizeImg(1) ~= height) || (sizeImg(2) ~= width)
        disp('Wrong Size!');
        continue;
    end

    % prepossess
    if sizeImg(3) == 3
        img = double(img(:,:,1)) + double(img(:,:,2)) + double(img(:,:,3));
    else
        img = double(img(:,:,1));
    end
    maxvalue = max(max(img)');
    dImg = img/maxvalue; 
    [gradI direI] = blurAgrad(dImg, sigma);
    f = addmask(gradI, direI);
    fmin  = min(f(:));
    fmax  = max(f(:));
    f = 2*(f-fmin)/(fmax-fmin);
    f = BoundMirrorExpand(f);

    % caclVF
    [u,v] = gradient(f);
    [u,v] = GVF(u, v, mu, NoGVFIterations);
%     mag = sqrt(u.*u+v.*v);
%     px = u./(mag+1e-10); py = v./(mag+1e-10);

    % set initial snake: XSnake and YSnake
    load('../snake.mat');

    % iteration
    [x,y] = snakeinterp(XSnake,YSnake,dmax,dmin);
    for j = 1:NoSnakeIterations/5
%         [x,y] = snakedeform(x,y,alpha,beta,gamma,kappa,px,py,5);
        [x,y] = snakedeform(x,y,alpha,beta,gamma,kappa,u,v,5);
        [x,y] = snakeinterp(x,y,dmax,dmin);
    end
    xSpace=(1:3:size(img,2));
    ySpace=(1:3:size(img,1));
    qx=interp2(u,xSpace, ySpace');
    qy=interp2(v,xSpace, ySpace');
    quiver(xSpace,ySpace,qx,qy);
    pause;

    % check the result
    if exist(strcat(resultDir, files(i).name), 'file') == 2
        resultImg = imread(strcat(resultDir, files(i).name));
        diff = calDiff(resultImg, x, y);
        fprintf('Diff of %s : %d\n', files(i).name, diff);
    else
        disp(strcat('No such file: ', files(i).name));
    end
    
    % output
    img = addSnake(img, x, y);
    imwrite(img, strcat(outputDir, files(i).name), 'bmp');
end

disp('Check over!');
end


