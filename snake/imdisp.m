function imdisp(I)
% imdisp(I) - scale the dynamic range of an image and display it.

x = (0:255)./255;
grey = [x;x;x]';
I = double(I);
minI = min(min(I));
maxI = max(max(I));
I = uint8((I-minI)/(maxI-minI)*255);
% image(I);
imshow(I);
% axis('square','off');
colormap(gray(256));
% imshow(uint8(I/max(max(I))*255));