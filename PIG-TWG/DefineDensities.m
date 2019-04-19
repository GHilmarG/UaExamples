function  [UserVar,rho,rhow,g]=DefineDensities(UserVar,CtrlVar,MUA,time,s,b,h,S,B)

persistent Fr

if isempty(Fr)
    
    %%
    % locdir=pwd;
    % AntarcticGlobalDataSets=getenv('AntarcticGlobalDataSets');
    % cd(AntarcticGlobalDataSets)
    fprintf('DefineIceDensity: loading file: %-s ',UserVar.DensityInterpolant)
    load(UserVar.DensityInterpolant,'Fr')
    fprintf(' done \n')
    %cd(locdir)
    
end

rhow=1030; g=9.81/1000;

rho=Fr(MUA.coordinates(:,1),MUA.coordinates(:,2));


end

