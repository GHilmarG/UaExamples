function [DxDx,DyDy,DxDy,DyDx]=DDxyMatrix(MUA)

% calculates the [dNdx dNdx ] and [dNdy dNdy] matrices
%
%
%  {DxDx]_{pq}=<dN_p/dx , N_q/dx>
%
% DxDy=DyDx'
%
% D=[Dxx Dxy ; Dyx Dyy]   is symmetrical
%
%
%  I= 0.5 int  ( (dAdx)^2 + (dAdy)^2) dx dy
% had the units A^2 , hence might want to normalize with mean A
%
%  I = 0.5 int  ( (dAdx)^2 + (dAdy)^2) dx dy
%    = <dAdx | dAdx >
%    = 0.5 int   (A_p dNdx_p )^2 + ...
%   
% 
%
%
% dI_q= int ( (dAdx dNdx_q + dAdy dNdy_q) = int (A_p dNdx_p dNdx_q +  A_p dNdy_p dNdy_q )
%     [DxDx] [A] + [DyDy] A
%    
%



ndim=2;  neq=MUA.Nnodes;


dxdx=zeros(MUA.Nele,MUA.nod,MUA.nod);
dydy=zeros(MUA.Nele,MUA.nod,MUA.nod);
dxdy=zeros(MUA.Nele,MUA.nod,MUA.nod);
dydx=zeros(MUA.Nele,MUA.nod,MUA.nod);

for Iint=1:MUA.nip
    
    %fun=shape_fun(Iint,ndim,MUA.nod,MUA.points) ; % nod x 1   : [N1 ; N2 ; N3] values of form functions at integration points
    
    Deriv=MUA.Deriv(:,:,:,Iint);
    detJ=MUA.DetJ(:,Iint);
    
    detJw=detJ*MUA.weights(Iint);
    
    for Inod=1:MUA.nod
        for Jnod=1:MUA.nod
            dxdx(:,Inod,Jnod)=dxdx(:,Inod,Jnod)+Deriv(:,1,Inod).*Deriv(:,1,Jnod).*detJw;
            dydy(:,Inod,Jnod)=dydy(:,Inod,Jnod)+Deriv(:,2,Inod).*Deriv(:,2,Jnod).*detJw;
            dxdy(:,Inod,Jnod)=dxdy(:,Inod,Jnod)+Deriv(:,1,Inod).*Deriv(:,2,Jnod).*detJw;
            dydx(:,Inod,Jnod)=dydx(:,Inod,Jnod)+Deriv(:,2,Inod).*Deriv(:,1,Jnod).*detJw;
        end
    end
end

Iind=zeros(MUA.nod*MUA.nod*MUA.Nele,1);
Jind=zeros(MUA.nod*MUA.nod*MUA.Nele,1);

XXval=zeros(MUA.nod*MUA.nod*MUA.Nele,1);
YYval=zeros(MUA.nod*MUA.nod*MUA.Nele,1);
XYval=zeros(MUA.nod*MUA.nod*MUA.Nele,1);
%YXval=zeros(MUA.nod*MUA.nod*MUA.Nele,1);

istak=0;
for Inod=1:MUA.nod
    for Jnod=1:MUA.nod
        
        Iind(istak+1:istak+MUA.Nele)=MUA.connectivity(:,Inod);
        Jind(istak+1:istak+MUA.Nele)=MUA.connectivity(:,Jnod);
        XXval(istak+1:istak+MUA.Nele)=dxdx(:,Inod,Jnod);
        YYval(istak+1:istak+MUA.Nele)=dydy(:,Inod,Jnod);
        XYval(istak+1:istak+MUA.Nele)=dxdy(:,Inod,Jnod);
 %       YXval(istak+1:istak+MUA.Nele)=dydx(:,Inod,Jnod);
        istak=istak+MUA.Nele;
        
    end
    
end

DxDx=sparse2(Iind,Jind,XXval,neq,neq);
DyDy=sparse2(Iind,Jind,YYval,neq,neq);
DxDy=sparse2(Iind,Jind,XYval,neq,neq);
%DyDx=sparse2(Iind,Jind,YXval,neq,neq);

DyDx=DxDy';

%M=(M+M.')/2 ; % I know that the matrix must be symmetric, but numerically this may not be strickly so



end



