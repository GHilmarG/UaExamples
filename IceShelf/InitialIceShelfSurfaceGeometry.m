function s = InitialIceShelfSurfaceGeometry(UserVar,x,y)


hmin=5; hmax=300;

s=hmin+hmax*exp(-(y./50e3).^2).*exp(-x/50e3); 

end


