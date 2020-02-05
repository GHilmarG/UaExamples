%%
%load C-Estimate.mat ; 
load('E:\Runs\PIG-TWG\C-Estimate.mat')
FC=scatteredInterpolant(xC,yC,C); 
save('FC.mat','FC')



%load AGlen-Estimate.mat ; 
load('E:\Runs\PIG-TWG\AGlen-Estimate.mat')
FA=scatteredInterpolant(xA,yA,AGlen); 
save('FA.mat','FA')


