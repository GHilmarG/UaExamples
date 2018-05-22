

function [xB,yB]=CreateMeshBoundaryCoordinatesForSAP(CtrlVar)
%%
load('ZeroIceThicknessContour.mat','xh0','yh0')


% use ginput to get (x,y) from mouse
cornerSW=[-1.754e+06   2.5332e+05];
cornerSE=[-1.4583e+06   7.8769e+05];

cornerNW=[-2.0946e+06   8.5469e+05];
cornerNE=[-1.7702e+06   1.0031e+06];


D= (xh0-cornerSW(1)).^2 + (yh0-cornerSW(2)).^2; [d,ISW]=min(D);
D= (xh0-cornerSE(1)).^2 + (yh0-cornerSE(2)).^2; [d,ISE]=min(D);

%plot(xh0,yh0,'b') ; axis equal
%hold on ; plot(xh0(ISW),yh0(ISW),'or') ; plot(xh0(ISE),yh0(ISE),'or')

n=numel(xh0);  ind=[(1:ISW)' ;(ISE:n)']; xh0(ind)=[] ;  yh0(ind)=[] ;

%plot(xh0,yh0,'r') ; axis equal

D= (xh0-cornerNW(1)).^2 + (yh0-cornerNW(2)).^2; [d,INW]=min(D);
D= (xh0-cornerNE(1)).^2 + (yh0-cornerNE(2)).^2; [d,INE]=min(D);


ind=INW:INE; xh0(ind)=[] ;  yh0(ind)=[] ;

%plot(xh0,yh0,'g') ; axis equal

%
%figure  plot(xh0,yh0,'g') ; axis equal



CtrlVar.GLtension=1e-9; % tension of spline, 1: no smoothing; 0: straight line
CtrlVar.GLds=CtrlVar.MeshSizeBoundary;

[xB,yB,nx,ny] = Smooth2dPos(xh0,yh0,CtrlVar);

% figure 
% plot(xh0,yh0,'r')
% hold on
% plot(xB,yB,'-go')
% hold on ; plot(xB,yB,'xg')
% axis equal

end
