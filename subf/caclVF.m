function caclVF();
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
%     f = addMask(f);
    f = addmask(Image2, direI);
    set(HDmainf,'CurrentAxes',HDbluredPic); imdisp(f); title('Blured image');
    fmin  = min(f(:));
    fmax  = max(f(:));
    f = 2*(Image2-fmin)/(fmax-fmin);  % Normalize f to the range [0,1]
    f = BoundMirrorExpand(f);  % Take care of boundary condition
    [u,v] = gradient(f);     % Calculate the gradient of the edge map
    if VectorFieldButt(1) ~= 1
        % Compute the GVF of the edge Image2
        disp(' Compute GVF ...');
        [u,v] = GVF(u, v, mu, NoGVFIterations);
    end
    SchangeInFieldType=0;
end

mag = sqrt(u.*u+v.*v);
px = u./(mag+1e-10); py = v./(mag+1e-10);

%HDvectorFPic=subplot(223);
%  global HDmainf;
set(HDmainf,'CurrentAxes',HDvectorFPic);
xSpace=(1:3:size(Image2,2));
ySpace=(1:3:size(Image2,1));
qx=interp2(px,xSpace, ySpace');
qy=interp2(py,xSpace, ySpace');

quiver(xSpace,ySpace,qx,qy);
axis('ij');
if VectorFieldButt(1)==1
    title('Standard potencial field');
else
    title('GVF');
end

set(HDvectorFPic,'Units', 'pixels','Position',[adgeD adgeD ysize/3 xsize/3],...
    'Units', 'normal',...
    'XLim',[0 size(Image2,2)],...
    'YLim',[0 size(Image2,1)],...
    'XTickMode','manual','XTick',[],...
    'YTickMode','manual','YTick',[],...
    'Units', 'pixels');

%%%%% result
XS = [XSnake; XSnake(1)];
YS = [YSnake; YSnake(1)];

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