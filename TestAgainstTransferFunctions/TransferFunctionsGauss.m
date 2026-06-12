function [sAna,uAna,vAna,wAna]=TransferFunctionsGauss(UserVar,CtrlVar,MUA,F)

%%



xMUA=MUA.coordinates(:,1) ; yMUA=MUA.coordinates(:,2) ;


Nfft=1024;
xgrid=linspace(min(xMUA),max(xMUA),Nfft); ygrid=linspace(min(yMUA),max(yMUA),Nfft);

[X,Y]=ndgrid(xgrid,ygrid);




nx=length(xgrid) ; ny=length(ygrid) ; dx=xgrid(2)-xgrid(1);dy=ygrid(2)-ygrid(1);

alpha=CtrlVar.alpha ; 
% h0=mean(F.h); C0=mean(F.C); 
h0=FEintegrate2D(CtrlVar,MUA,F.h)   ;  h0=sum(h0)/MUA.Area; 
C0=FEintegrate2D(CtrlVar,MUA,F.C)   ;  C0=sum(C0)/MUA.Area; 
rho0=FEintegrate2D(CtrlVar,MUA,F.rho) ;  rho0=sum(rho0)/MUA.Area; 


m=mean(F.m);
g=F.g;
eta=1/(2*mean(F.AGlen));
time=F.time;
taud=rho0*g*sin(alpha)*h0 ; 
u0=C0*taud^m;


% Define perturbations
db=UserVar.ampl_b*h0*exp(-X.^2./UserVar.sigma_bx^2-Y.^2./UserVar.sigma_by^2); 
db=db-mean(db(:)) ;

dc=UserVar.ampl_c*exp(-X.^2./UserVar.sigma_cx^2-Y.^2./UserVar.sigma_cy^2); 
dc=dc-mean(dc(:)) ;

ds=dc*0;  % for the time being
%

ds=ifft2(ds); db=ifft2(db); dc=ifft2(dc);
k=fftspace(nx,dx); k(1)=eps ;
l=fftspace(ny,dy); l(1)=eps ;

% multiply transfer functions with corresponding basal perturbations
% do inverse fft and only keep the real part


sAnalytical=real(fft2(SSTREAM_Tss_t_3d_m(k,l,time,alpha,h0,eta,C0,rho0,g,m).*ds)+...
    fft2(SSTREAM_Tsb_t_3d_m(k,l,time,alpha,h0,eta,C0,rho0,g,m).*db)+...
    fft2(SSTREAM_Tsc_t_3d_m(k,l,time,alpha,h0,eta,C0,rho0,g,m).*dc));

uAnalytical=real(fft2(SSTREAM_Tus_t_3d_m(k,l,time,alpha,h0,eta,C0,rho0,g,m).*ds)+...
    fft2(SSTREAM_Tub_t_3d_m(k,l,time,alpha,h0,eta,C0,rho0,g,m).*db)+...
    fft2(SSTREAM_Tuc_t_3d_m(k,l,time,alpha,h0,eta,C0,rho0,g,m).*dc));

vAnalytical=real(fft2(SSTREAM_Tvs_t_3d_m(k,l,time,alpha,h0,eta,C0,rho0,g,m).*ds)+...
    fft2(SSTREAM_Tvb_t_3d_m(k,l,time,alpha,h0,eta,C0,rho0,g,m).*db)+...
    fft2(SSTREAM_Tvc_t_3d_m(k,l,time,alpha,h0,eta,C0,rho0,g,m).*dc));


wAnalytical=real(fft2(SSTREAM_Tws_t_3d_m(k,l,time,alpha,h0,eta,C0,rho0,g,m).*ds)+...
    fft2(SSTREAM_Twb_t_3d_m(k,l,time,alpha,h0,eta,C0,rho0,g,m).*db)+...
    fft2(SSTREAM_Twc_t_3d_m(k,l,time,alpha,h0,eta,C0,rho0,g,m).*dc));

sAnalytical=sAnalytical+h0 ;
uAnalytical=uAnalytical+u0 ;



% interpolate analytical values onto the numerical FE mesh

Fs = griddedInterpolant(X,Y,sAnalytical) ; sAna = Fs(xMUA,yMUA); 
Fu = griddedInterpolant(X,Y,uAnalytical) ; uAna = Fu(xMUA,yMUA); 
Fv = griddedInterpolant(X,Y,vAnalytical) ; vAna = Fv(xMUA,yMUA); 
Fw = griddedInterpolant(X,Y,wAnalytical) ; wAna = Fw(xMUA,yMUA); 


%%

end