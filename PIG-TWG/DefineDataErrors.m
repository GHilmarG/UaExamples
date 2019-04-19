function [uError,vError,wError]=DefineDataErrors(coordinates,Xint,Yint,GF,CtrlVar,uError,vError,wError)
    
    % use this to modify date errors
    
    if nargin~=8 ; error(' wrong number of input arguments')  ; end
    
    
    x=coordinates(:,1); y=coordinates(:,2);
    
%     if isempty(strfind(CtrlVar.AdjointGrad,'A'))
%         fprintf(' Only inverting for C so I set errors over the floating part to a large value \n')
%         uError=uError+(1-GF.node)*1e10;
%         vError=vError+(1-GF.node)*1e10;
%     end
    
    if isempty(strfind(CtrlVar.AdjointGrad,'C'))
        fprintf(' Only inverting for AGlen so I set errors over the grounding part to a large value \n')
        uError=uError+GF.node*1e10;
        vError=vError+GF.node*1e10;
         I=y> -350e3 & x > -1660e3 &  x<  -1550e3;
         uError(~I)=1e10; vError(~I)=1e10;
         
          fprintf(' Setting errors outside of PIG ice shelf to a large valueedit D \n')
         I= x> -1500e3  | x< -1600e3 | y >-200e3 | y <-400e3;  uError(I)=1e10 ;  vError(I)=1e10 ;
    end
    
    I= x> -1200e3  | x< -1800e3 | y >0 | y <-600e3;  uError(I)=1e10 ;  vError(I)=1e10 ;

    load('DataErrorMask.mat','I')  % this is a mask where I discovered that meas were clearly incorrect
                                   % possibly related to interpolation errors
    uError(I)=1e10 ;  vError(I)=1e10 ;
    
end

