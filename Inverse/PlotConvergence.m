
%%
load Nod3-MeshIndependentI-iC-AdjointRestart.mat

%
%AdjointResultsPlots(CtrlVar.UserVar,CtrlVar,MUA,BCs,s,b,h,S,B,ub,vb,ud,vd,l,alpha,rho,rhow,g,GF,...
%                InvStartValues,Priors,Meas,BCsAdjoint,Info,InvFinalValues,xAdjoint,yAdjoint)

%
figure   
[It,~]=size(Info.JoptVector);
semilogy(0:It-1,Info.JoptVector(:,1),'-ro') ; hold on
labels{1}=sprintf('Nod%i Prematrix %s',MUA.nod,CtrlVar.MeshIndependentAdjointGradients);


load Nod3-MeshIndependentP-iC-AdjointRestart.mat

[It,~]=size(Info.JoptVector);
semilogy(0:It-1,Info.JoptVector(:,1),'-bo') ; hold on
labels{2}=sprintf('Nod%i Prematrix %s',MUA.nod,CtrlVar.MeshIndependentAdjointGradients);



load Nod3-MeshIndependentM-iC-AdjointRestart.mat

[It,~]=size(Info.JoptVector);
semilogy(0:It-1,Info.JoptVector(:,1),'-go') ; hold on
labels{3}=sprintf('Nod%i Prematrix %s',MUA.nod,CtrlVar.MeshIndependentAdjointGradients);


load Nod6-MeshIndependentI-iC-AdjointRestart.mat

[It,~]=size(Info.JoptVector);
semilogy(0:It-1,Info.JoptVector(:,1),'-r+') ; hold on
labels{4}=sprintf('Nod%i Prematrix %s',MUA.nod,CtrlVar.MeshIndependentAdjointGradients);


load Nod6-MeshIndependentP-iC-AdjointRestart.mat

[It,~]=size(Info.JoptVector);
semilogy(0:It-1,Info.JoptVector(:,1),'-b+') ; hold on
labels{5}=sprintf('Nod%i Prematrix %s',MUA.nod,CtrlVar.MeshIndependentAdjointGradients);

load('Nod6-MeshIndependentM-iC-AdjointRestart.mat','MUA','CtrlVar','Info')

[It,~]=size(Info.JoptVector);
semilogy(0:It-1,Info.JoptVector(:,1),'-g+') ; hold on
labels{6}=sprintf('Nod%i Prematrix %s',MUA.nod,CtrlVar.MeshIndependentAdjointGradients);



load('Nod10-MeshIndependentI-iC-AdjointRestart.mat','MUA','CtrlVar','Info')

[It,~]=size(Info.JoptVector);
semilogy(0:It-1,Info.JoptVector(:,1),'-rx') ; hold on
labels{7}=sprintf('Nod%i Prematrix %s',MUA.nod,CtrlVar.MeshIndependentAdjointGradients);
load('Nod10-MeshIndependentP-iC-AdjointRestart.mat','MUA','CtrlVar','Info')

[It,~]=size(Info.JoptVector);
semilogy(0:It-1,Info.JoptVector(:,1),'-bx') ; hold on
labels{8}=sprintf('Nod%i Prematrix %s',MUA.nod,CtrlVar.MeshIndependentAdjointGradients);

load('Nod10-MeshIndependentM-iC-AdjointRestart.mat','MUA','CtrlVar','Info')

[It,~]=size(Info.JoptVector);
semilogy(0:It-1,Info.JoptVector(:,1),'-gx') ; hold on
labels{9}=sprintf('Nod%i Prematrix %s',MUA.nod,CtrlVar.MeshIndependentAdjointGradients);



load('Nod10-MeshIndependentM-iC-AdjointRestart.mat','MUA','CtrlVar','Info')

[It,~]=size(Info.JoptVector);
semilogy(0:It-1,Info.JoptVector(:,1),'-gx') ; hold on
labels{9}=sprintf('Nod%i Prematrix %s',MUA.nod,CtrlVar.MeshIndependentAdjointGradients);



















legend(labels)
xlabel('Iteration') ; ylabel('Cost function')