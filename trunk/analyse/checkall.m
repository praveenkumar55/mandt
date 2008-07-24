function checkall()
%CHECKALL It checks all the images in a same directory
%   Detailed explanation goes here

clear;

% parameter
width = 48;
height = 116;
alpha = 0.05;
beta = 0;
gamma = 1;
kappa = 0.6;
dmin = 0.5;
dmax = 2;
sigma = 1;
mu = 0.1;
NoGVFIterations = 80;
NoSnakeIterations = 100;

% algorithm
useGVF = 1;

testDir = 'D:\jimmy\program\bad_set\';
resultDir = 'D:\jimmy\program\trainset\';
outputDir = 'D:\jimmy\program\bad_set_result\';
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
        img = double(rgb2gray(img));
    else
        img = double(img(:,:,1));
    end
%     maxvalue = max(max(img)');
%     dImg = img/maxvalue; 
%     [gradI direI] = blurAgrad(dImg, sigma);
    [gradI direI] = blurAgrad(img, sigma);
    f = addmask(gradI, direI);
%     f = gradI;
    fmin  = min(f(:));
    fmax  = max(f(:));
    f = 2*(f-fmin)/(fmax-fmin);
    f = BoundMirrorExpand(f);

    % caclVF
%     [u,v] = gradient(f);
%     [u,v] = GVF(u, v, mu, NoGVFIterations);
    if useGVF == 1
        [u,v] = GVF(f, mu, NoGVFIterations);
    else
        [u,v] = gradient(f);
    end
    mag = sqrt(u.*u+v.*v);
    px = u./(mag+1e-10); py = v./(mag+1e-10);
%     u = 1000*u;
%     v = 1000*v;
%     xSpace=(1:3:size(img,2));
%     ySpace=(1:3:size(img,1));
%     qx=interp2(px,xSpace, ySpace');
%     qy=interp2(py,xSpace, ySpace');
%     quiver(xSpace,ySpace,qx,qy);
%     pause;

    % set initial snake: XSnake and YSnake
    load('../snake.mat');

    % iteration
    [x,y] = snakeinterp(XSnake,YSnake,dmax,dmin);
    for j = 1:NoSnakeIterations/5
        [x,y] = snakedeform(x,y,alpha,beta,gamma,kappa,px,py,5);
%         [x,y] = snakedeform(x,y,alpha,beta,gamma,kappa,u,v,5);
        [x,y] = snakeinterp(x,y,dmax,dmin);
    end

    % check the result
    diffsum = 0;
    count = 0;
    if exist(strcat(resultDir, files(i).name), 'file') == 2
        resultImg = imread(strcat(resultDir, files(i).name));
        diff = calDiff(resultImg, x, y);
        diffsum = diffsum + diff;
        count = count + 1;
        fprintf('Diff of %s : %d\n', files(i).name, diff);
    else
        disp(strcat('No such file: ', files(i).name));
    end
    
    % output
    img = addSnake(img, x, y);
%     img = addSnake(f, x, y);
    imwrite(img, strcat(outputDir, files(i).name), 'bmp');
end

diffsum = diffsum / count;
fprintf('average diff: %d', diffsum);

disp('Check over!');
end