function [UserVar,C,m,q,muk]=DefineSlipperyDistribution(UserVar,CtrlVar,MUA,F)

q=nan; muk=nan;

m=3 ; C=0.0145300017528364 ; % m=3
%m=1 ; C=1.13263129082193    ; % m=1

C=C+zeros(MUA.Nnodes,1);

end
