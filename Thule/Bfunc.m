function B=Bfunc(x,y,BedName)





%%   new parameter set
R=800e3 ;
Bc=900;
Bl=-2000;
Ba=1100;
%%

switch BedName

    case "-Thule-"

        r=sqrt(x.*x+y.*y) ;
        theta=atan2(y,x);


        rc=0;
        l=R -  cos(2*theta).*R/2 ;            % theta-dependent wavelength
        a=Bc - (Bc-Bl)*(r-rc).^2./(R-rc).^2;  % quadratic term in r
        B=Ba*cos(3*pi*r./l)+a ;               %

    case "-ThuleNS-"

        r=sqrt(x.*x+y.*y) ;
        theta=pi/2 ;

        rc=0;
        l=R -  cos(2*theta).*R/2 ;            % theta-dependent wavelength
        a=Bc - (Bc-Bl)*(r-rc).^2./(R-rc).^2;  % quadratic term in r
        B=Ba*cos(3*pi*r./l)+a ;

    otherwise

        error("Case not found")

end

end
