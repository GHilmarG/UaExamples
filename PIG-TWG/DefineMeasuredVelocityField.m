function [FuMeas,FvMeas,FwMeas]=DefineMeasuredVelocityField()
    
    % Grids datapoints and creates interpolant for measured velocity
    
    
    fprintf(' Loading measured velocity data for PIG \n')
%%   
     CurDir=pwd; goto_home_directory ; cd('PIG') ;  load PIG96VelocityHilmar X Y Speed Vx Vy ;cd(CurDir)
    figure ; contourf(X/1000,Y/1000,Speed,50,'LineStyle','none') ; colorbar ; axis equal tight

%%

%     Vz=Vx*0;
%     
%     DTmeas = DelaunayTri(X(:),Y(:));
%     
%     
%     FuMeas = TriScatteredInterp(DTmeas,Vx(:),'natural');
%     FvMeas = TriScatteredInterp(DTmeas,Vy(:),'natural');
%     FwMeas = TriScatteredInterp(DTmeas,Vz(:),'natural');
    
    
    
    load PigMeasVelInterpolant FuMeas FvMeas 
    
    FwMeas=NaN;
end


