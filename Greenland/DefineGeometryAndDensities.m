function  [UserVar,s,b,S,B,rho,rhow,g]=DefineGeometryAndDensities(UserVar,CtrlVar,MUA,F,FieldsToBeDefined)


%%
%
% Defines model geometry and ice densities
%
%   [UserVar,s,b,S,B,rho,rhow,g]=DefineGeometryAndDensities(UserVar,CtrlVar,MUA,F,FieldsToBeDefined)
%
% FieldsToBeDefined is a string indicating which return values are required. For
% example if
%
%   FieldsToBeDefined="-s-b-S-B-rho-rhow-g-"
%
% then s, b, S, B, rho, rhow and g needed to be defined.
%
% Typically, in a transient run
%
%   FieldsToBeDefined="-S-B-rho-rhow-g-"
%
% implying that only s and b do not needed to be defined, and s and b can be set to any
% value, for example s=NaN and b=NaN.
%
% It is OK to define values that are not needed, these will simply be ignored by Úa.
%
% As in all other calls:
%
%  F.s       : is upper ice surface
%  F.b       : lower ice surface
%  F.B       : bedrock
%  F.S       : ocean surface
%  F.rhow    :  ocean density (scalar variable)
%  F.rho     :  ice density (nodal variable)
%  F.g       :  gravitational acceleration
%  F.x       : x nodal coordinates 
%  F.y       : y nodal coordinates 
%  F.time    : time (i.e. model time)
%  F.GF      : The nodal grounded/floating mask (has other subfields)
%
% These fields need to be returned at the nodal coordinates. 
% 
% The nodal x and y coordinates are also stored in MUA.coordinates in addition to F.x and F.y.
%
%%

persistent FB Fb Fs GeometryInterpolants

if isstring(GeometryInterpolants) &&  GeometryInterpolants~=UserVar.Files.GeometryInterpolants

    % This is in case the user has changed the geometry interpolants from last run, in which case the FB, Fs, Fb must be read
    % anew, even if already in local memory.

    GeometryInterpolants=UserVar.Files.GeometryInterpolants;
    FB=[]; Fs=[]; Fb=[]; 

end


if isempty(FB)

    load(UserVar.Files.GeometryInterpolants,"FB","Fb","Fs")
    

end

if contains(FieldsToBeDefined,"-s-")
    s=Fs(F.x,F.y);
else
    s=[];
end
if contains(FieldsToBeDefined,"-b-")

    b=Fb(F.x,F.y);
else
    b=[]; 
end

if contains(FieldsToBeDefined,"-B-")
    B=FB(F.x,F.y);
else 
    B=[];
end

if contains(FieldsToBeDefined,"-S-")
    S=zeros(MUA.Nnodes,1);
else 
    S=[]; 
end


if contains(FieldsToBeDefined,"-rho-")
    rho=zeros(MUA.Nnodes,1)+920;
else
    rho=[];
end


rhow=1027;
g=9.81/1000;

%%
%
% cbar= UaPlots(CtrlVar,MUA,F,B) ; colormap(othercolor("Mdarkterrain",25)) ; clim([-2000 2000]) ; title("Bedrock") ; subtitle("")  ; title(cbar,"(m a.s.l.)")
%
% cbar= UaPlots(CtrlVar,MUA,F,s) ; colormap(othercolor("Mdarkterrain",25)) ; clim([0 3300]) ; title("Surface") ; subtitle("")  ; title(cbar,"(m a.s.l.)")
%%

end




