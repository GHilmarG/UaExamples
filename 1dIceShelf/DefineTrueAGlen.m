function [UserVar,AGlen,n]=DefineTrueAGlen(Experiment,coordinates,CtrlVar)

    
    x=coordinates(:,1); y=coordinates(:,2);
    sx=25e3 ; sy=25e3;
    
    n=3 ;  AGlen=3.0e-9+zeros(size(coordinates,1),1) ; % kPa year about -20 degrees Celcius
    AGlen=AGlen.*(1+100*exp(-(x.*x/sx^2+y.*y./sy^2)));


end
