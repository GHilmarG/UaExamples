





%%
load Restart-Thule-P-SSmin-10km-.mat
% load Restart-Thule-P-SSmax-10km-.mat
CtrlVar=CtrlVarInRestartFile;

%%
close all
FIGsbB=FindOrCreateFigure("sbB"); clf(FIGsbB);
hold off
AspectRatio=3;
ViewAndLight(1)=-40 ;  ViewAndLight(2)=20 ;
ViewAndLight(3)=30 ;  ViewAndLight(4)=50;
sCol=[0.8 0.8 1]; 
bCol=[0.8 0.8  1]; 
BCol=[0.8 0.6 0.3] ;

TRI=[]; DT=[] ; 
[TRI,DT]=Plot_sbB(CtrlVar,MUA,F.s,F.b,F.B,TRI,DT,AspectRatio,ViewAndLight,[],sCol,bCol,BCol);

xlabel("x (km)",Interpreter="latex") ; 
ylabel("y (km)",Interpreter="latex") ;
zlabel("z (m a.s.l.)",Interpreter="latex") ;
title("")

 ax=gca; exportgraphics(ax,'ThulesbBmin.pdf')

 %%

FIGuv=FindOrCreateFigure("uv"); clf(FIGuv);

UaPlots(CtrlVar,MUA,F,"-ubvb-")
xlabel("x (km)",Interpreter="latex") ; 
ylabel("y (km)",Interpreter="latex") ;
axis tight
ax=gca; exportgraphics(ax,'ThuleMinVel.pdf')