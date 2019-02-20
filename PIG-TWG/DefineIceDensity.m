function rho=DefineIceDensity(Experiment,coordinates,CtrlVar)
    
   
    
FileName='rhoEffectivePIG.mat';

fprintf('DefineIceDensity: loading file: %-s ',FileName) 
load('rhoEffectivePIG.mat','x','y','rhoeffective')
fprintf(' done \n')


% there are nan in the data set outside the ice boundary of the firn-densityu model. Possibly the FE model will need
% values here and I set them to rhoIceShelf

rhoIceShelf=800;

rhoeffective(isnan(rhoeffective))=rhoIceShelf;

[X,Y]=meshgrid(x,y);
rho=interp2(X,Y,rhoeffective,coordinates(:,1),coordinates(:,2),'spline');

if any(isnan(rho)) ;error(' nan values in rho ') ; end

%figure; contour(X/1000,Y/1000,rhoeffective) ; colorbar ; axis equal tight

end