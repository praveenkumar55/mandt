function classify()
%CLASSIFY Summary of this function goes here
%   Detailed explanation goes here

clear

goodresult = 'D:\jimmy\program\good_set_result\';
origset = 'D:\jimmy\program\testset\';
goodset = 'D:\jimmy\program\good_set\';
badset = 'D:\jimmy\program\bad_set\';

% files = dir(goodresult);
% sizeFiles = size(files);
% pause;
% 
% for i=1:sizeFiles(1)
% 
%     sizeTest = size(findstr(files(i).name, 'bmp'));
%     if (sizeTest(1) == 0)
%         continue;
%     end
%     
%     s = sprintf('copy %s%s %s%s', origset, files(i).name, goodset, files(i).name);
%     system(s);
% 
% end

files = dir(origset);
sizeFiles = size(files);

for i=1:sizeFiles(1)

    sizeTest = size(findstr(files(i).name, 'bmp'));
    if (sizeTest(1) == 0)
        continue;
    end
    
    if exist(strcat(goodset, files(i).name)) == 2;
        continue;
    end
    
    s = sprintf('copy %s%s %s%s', origset, files(i).name, badset, files(i).name);
    system(s);
    
end


