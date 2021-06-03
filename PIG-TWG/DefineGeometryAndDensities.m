function  [UserVar,s,b,S,B,rho,rhow,g]=DefineGeometryAndDensities(UserVar,CtrlVar,MUA,F,FieldsToBeDefined)


persistent FB Fs Fb Frho


fprintf('DefineGeometry %s \n',FieldsToBeDefined)

if isempty(FB)
    
    fprintf('DefineGeometry: loading file: %-s ',UserVar.GeometryInterpolant)
    load(UserVar.GeometryInterpolant,'FB','Fb','Fs','Frho')
    fprintf(' done \n')
    
end

g=9.81/1000;

if contains(FieldsToBeDefined,'S')
    S=zeros(MUA.Nnodes,1);
else
    S=NaN;
end

if contains(FieldsToBeDefined,'s')
    s=Fs(F.x,F.y);
else
    s=NaN;
end

b=NaN; B=NaN;

if contains(FieldsToBeDefined,'b')  || contains(FieldsToBeDefined,'B')
    
    B=FB(F.x,F.y);
    b=Fb(F.x,F.y);
    
    
    I=b<B; b(I)=B(I);  % make sure that interpolation errors don't create a situation where b<B
    % Get rid of lake Vostock.
    % NOte: This might already have been done in the geometry data set, so possibly this could be commented away. 
    I=F.x>1000e3 & F.x < 1600e3 & F.y>-500e3 & F.y<-200e3  ;
    B(I)=b(I); % shift bed upwards towards lower ice surface and ignore lake
    
end



if contains(FieldsToBeDefined,'rho')
    rho=Frho(F.x,F.y);
    rhow=1030;
else
    rho=NaN;
    rhow=NaN;
end

end




