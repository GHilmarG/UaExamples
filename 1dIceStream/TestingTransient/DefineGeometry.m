


function [UserVar,s,b,S,B,alpha]=DefineGeometry(Experiment,coordinates,CtrlVar,FieldsToDefine)

% Defines model geometry

x=coordinates(:,1); y=coordinates(:,2);
alpha=0.;



slope=-0.001;
B0=0;
Thick=1000;


B=B0+slope*x;
%S=B*0-1000;  % gl at 1900 km, i.e. slighly outside of domain (good test)
%S=B*0-5000;  % gl well outside the domain and everything fully grounded
S=B*0  ;     % gl at 900 km, i.e. within the domain
b=B;
s=b+Thick;

end
