function caclVF()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% calculate Vector field
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%% image processing variables
global Image2;							% blured image
global direI;                           % direction of the image

global mu;
global NoGVFIterations;				% number of iterations
global VectorFieldButt;
global alpha beta gamma kappa dmin dmax;		% parameters for the snake
global px py u v;											% forse filed
global SchangeInFieldType;
global XSnake YSnake;				% conture of the snake

global xsize ysize;					%size of the picture

global adgeD;

%%%%% global handles
global HDmainf;
global HDorigPic;						%original picture axes handle
global HDbluredPic;				   %blured picture axes handle
global HDvectorFPic;					%handle of vector field picture

global HDSnakeLine;					%vector of Handles of Snake lines on the picture
global SnakeON;						%indicate if snake is visible

if SchangeInFieldType==1
    if VectorFieldButt(3) == 1
        f = addmask(Image2, direI);
    else
        f = double(Image2);
    end
    set(HDmainf,'CurrentAxes',HDbluredPic); imdisp(f); title('Blured image');
    fmin  = min(f(:));
    fmax  = max(f(:));
%     f = 2*(Image2-fmin)/(fmax-fmin);  % Normalize f to the range [0,1]
    f = 2*(f-fmin)/(fmax-fmin);  % Normalize f to the range [0,1]
    f = BoundMirrorExpand(f);  % Take care of boundary condition
   
    if VectorFieldButt(1) ~= 1
        % Compute the GVF of the edge Image2
        disp(' Compute GVF ...');
        [u,v] = GVF(f, mu, NoGVFIterations);
    else
        [u,v] = gradient(f);     % Calculate the gradient of the edge map
    end
    SchangeInFieldType=0;
end

mag = sqrt(u.*u+v.*v);
px = u./(mag+1e-10); py = v./(mag+1e-10);

set(HDvectorFPic,'Units', 'pixels','Position',[adgeD adgeD xsize ysize],...
   					'Units', 'normal',...
                  'XLim',[0 size(Image2,1)],...
                  'YLim',[0 size(Image2,2)],...
                  'XTickMode','manual','XTick',[],...
                  'YTickMode','manual','YTick',[],...
                  'Units', 'pixels');

% HDvectorFPic=subplot(223);
%  global HDmainf;
set(HDmainf,'CurrentAxes',HDvectorFPic);
[ysImage2 xsImage2] = size(Image2);
[xSpace ySpace] = meshgrid(4:3*xsImage2/xsize:(xsImage2-3), 4:3*ysImage2/ysize:(ysImage2-3));
qx = interp2(px, xSpace, ySpace);
qy = interp2(py, xSpace, ySpace);
quiver(xSpace,ySpace,qx,qy);
axis('ij');
if VectorFieldButt(1)==1
    title('Standard field');
else
    title('GVF');
end

%%%%% result
XS = [XSnake; XSnake(1)];
YS = [YSnake; YSnake(1)];
% pause;
HDline1=line('Parent', HDorigPic,'XData',XS,'YData',YS,'Color','Red','LineWidth',3);
HDline2=line('Parent', HDbluredPic,'XData',XS,'YData',YS,'Color','Red','LineWidth',3);
HDline3=line('Parent', HDvectorFPic,'XData',XS,'YData',YS,'Color','Red','LineWidth',3);

HDSnakeLine=[HDline1 HDline2 HDline3];
SnakeON=1;
% if SnakeDotsON==1
%    set(HDSnakeLine,'Marker','.','MarkerEdgeColor','Green','MarkerFaceColor','Blue','MarkerSize',DotsSize);
% else
%    set(HDSnakeLine,'Marker','None');
% end;


HD=get(HDvectorFPic,'Children');
set(HD,'ButtonDownFcn','SnakeIter(''Pic3Click'')');

menu3;