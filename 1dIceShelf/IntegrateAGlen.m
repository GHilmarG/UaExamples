function [q ] = IntegrateAGlen(x)
    
    q=x*0;
    for I=1:numel(x)
        q(I)=quadgk(@DefineAGlenDistribution,-100e3,x(I));
    end
    
    figure ; plot(x,q)
    
end

