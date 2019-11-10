function [UserVar,EleSizeDesired,ElementsToBeRefined]=...
        DefineDesiredEleSize(UserVar,CtrlVar,MUA,x,y,EleSizeDesired,ElementsToBeRefined,s,b,S,B,rho,rhow,ub,vb,ud,vd,GF,NodalErrorIndicators)
    
    %%
    % Define desired sizes of elements or specify which elements to refine.
    %
    %
    % Only used in combination with adaptive meshing.
    %
    % Allows user to set desired ele sizes (EleSize) at given locations (x,y).
    %
    % On input EleSizeDesired are desired ele sizes at (x,y) as
    % calculated by Úa based on some user-defined criteria.
    %
    % On output EleSizeDesired are desired ele sizes at (x,y).
    %
    % Do not modify the size of the (nodal) vector `EleSizeDesired' or the logical (element)
    % vector 'ElementsToBeRefine', only the values.
    %
    % x,y are the locations where new element sizes are specifed.
    %
    % ElementsToBeRefined can either be a logical array in which case values set to true/1 indicate elements
    % to be refined, or a list of numbers of elements to be refined.
    %
    %%
    Temp=EleSizeDesired;
    x=MUA.coordinates(:,1) ; y=MUA.coordinates(:,2) ;
    
    D=10e3; I=x>-D & x< D & y> -D & y < D ; Temp(I)=0.5e3;
    D=1e3;  I=y> (UserVar.Crack.b-D) & y < (UserVar.Crack.b+D)  & x> -D & x < D ; Temp(I)=0.1e3;
    D=0.1e3;  I=y> (UserVar.Crack.b-D) & y < (UserVar.Crack.b+D)  & x> -D & x < D ; Temp(I)=0.01e3;
    D=0.01e3;  I=y> (UserVar.Crack.b-D) & y < (UserVar.Crack.b+D)  & x> -D & x < D ; Temp(I)=0.001e3;
    
    EleSizeDesired=min(Temp(:),EleSizeDesired(:));
    
    
    
    
    return
    
end
