
function   [UserVar,A,n]=DefineAGlenDistribution(UserVar,CtrlVar,MUA,F)

persistent FA


% Check if we already have a file with an estimate for A.
if isempty(FA)

    if isfile(UserVar.Files.AInterpolant) 

        load(UserVar.Files.AInterpolant,"AGlen","n","xA","yA")
        FA=scatteredInterpolant(xA,yA,AGlen) ;
        
    end

end

if ~isempty(FA)

    A=FA(F.x,F.y);
    n=3 ; % assuming this was the value used, can be changed by creating an interpolant for n as well

else

    n=3;
    T=-10 ;
    A=AGlenVersusTemp(T)+zeros(MUA.Nnodes,1) ;
   
end


end

