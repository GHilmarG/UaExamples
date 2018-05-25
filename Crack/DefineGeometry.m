
function [UserVar,s,b,S,B,alpha]=GetGeometry(UserVar,CtrlVar,MUA,time,FieldsToBeDefined)
%%
%  Defining geometrical variables
% [UserVar,s,b,S,B,alpha]=DefineGeometry(UserVar,CtrlVar,MUA,time,FieldsToBeDefined)
%
% s : upper glacier surface b : lower glacier surface S : ocean surface B :
% bedrock
%
% All these variables are nodal variables.
%
% alpha : tilt of the coordinate system with respect to gravity.
%
% FieldsToBeDefined    : a string indicating which output variables are required
%                        at the current stage of the run.
%
% If for example this string is 'sbSB' , then s, b, S and B are required. If the
% string is 'B'  then only B is required. The other variables must be : defined
% as well but their values will not be used.
%
%                      
% Note: Floating conditions are taken care of internally and s and b will be
% modified accordingly while conserving thickness.
%
% Note: If for some reason s and b are defined so that s-b<CtrlVar.ThickMin then
% s and b will be modified internally to ensure that min ice thickness is no
% less than CtrlVar.ThickMin
%
% Note: In a transient run s and b are updated internally and do not need to be
% defined by the user (in this case FieldsToBeDefined='SB') except at the start
% of the run.
%
% Note: After remeshing, variables are generally mapped internally from the old
% to the new mesh using some interpolation methods (Usually a natural neighbour
% scatterd interpolant). But in a diagnostic/static run, geometric variables
% (s,b,S,B) are always defined over the new mesh through a call to
% [UserVar,s,b,S,B,alpha]=DefineGeometry(UserVar,CtrlVar,MUA,time,FieldsToBeDefined).
%       
%
    x=MUA.coordinates(:,1); y=MUA.coordinates(:,2);
    
    alpha=0.0; % tilt of the coordinate system with respect to gravity
    
    
    h=1000; 
    
    
    B=zeros(MUA.Nnodes,1)-1e10 ;  
    S=zeros(MUA.Nnodes,1);        
    b=zeros(MUA.Nnodes,1);        
    s=b+h;                     
    
    
end
