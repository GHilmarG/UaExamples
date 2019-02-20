function [UserVar,s,b,S,B,alpha]=DefineGeometry(UserVar,CtrlVar,MUA,time,FieldsToBeDefined)

persistent FB Fs Fb



if nargin<5
    FieldsToBeDefined='sbSB';
end

fprintf('DefineGeometry %s \n',FieldsToBeDefined)

if isempty(FB)
    
    %%
    %locdir=pwd;
    %AntarcticGlobalDataSets=getenv('AntarcticGlobalDataSets');
    %cd(AntarcticGlobalDataSets)
    fprintf('DefineGeometry: loading file: %-s ',UserVar.GeometryInterpolant)
    load(UserVar.GeometryInterpolant,'FB','Fb','Fs')
    fprintf(' done \n')
    %cd(locdir)
end


x=MUA.coordinates(:,1); y=MUA.coordinates(:,2);
alpha=0 ;

if contains(FieldsToBeDefined,'S')
    S=x*0;
else
    S=NaN;
end


if contains(FieldsToBeDefined,'s')
    s=Fs(x,y);
else
    s=NaN;
end

b=NaN; B=NaN;

if contains(FieldsToBeDefined,'b')  || contains(FieldsToBeDefined,'B')
    
    B=FB(x,y);
    b=Fb(x,y);

    I=b<B; b(I)=B(I);  % make sure that interpolation errors don't create a situation where b<B
    
    % Vostock
    I=x>1000e3 & x < 1600e3 & y>-500e3 & y<-200e3  ;
    B(I)=b(I); % shift bed upwards towards lower ice surface and ignore lake
    
end



end



