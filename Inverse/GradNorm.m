function [J,Jele,Area,EleArea]=GradNorm(MUA,f)

%
% J=0.5(  int (dfdx^2+dfdy^2) dx dy) / Area
% 
%  J=<dfdx | dfdx >
% dJ=<dfdx | dNdx > ? var her
%

ndim=2;
[points,weights]=sample('triangle',MUA.nip,ndim);

fnod=reshape(f(MUA.connectivity,1),MUA.Nele,MUA.nod);

dfdx=zeros(MUA.Nele,MUA.nip);
dfdy=zeros(MUA.Nele,MUA.nip);


Jele=zeros(MUA.Nele,1);
EleArea=Jele;

for Iint=1:MUA.nip
    
    Deriv=MUA.Deriv(:,:,:,Iint);
    detJ=MUA.DetJ(:,Iint);
    for I=1:MUA.nod
        dfdx(:,Iint)=dfdx(:,Iint)+Deriv(:,1,I).*fnod(:,I);
        dfdy(:,Iint)=dfdy(:,Iint)+Deriv(:,2,I).*fnod(:,I);
    end
    
    detJw=detJ*weights(Iint);
    fint=(dfdx(:,Iint).*dfdx(:,Iint)+dfdy(:,Iint).*dfdy(:,Iint))/2 ;
    
    %fint=(dfdx(:,Iint).^p+dfdy(:,Iint).^p)/p ;
    
    Jele=Jele+fint.*detJw;
    EleArea=EleArea+detJw;
    
end

Area=sum(EleArea);
J=sum(Jele)/Area;

Jele=Jele./EleArea ; % needed if want these not to be affected by element area

