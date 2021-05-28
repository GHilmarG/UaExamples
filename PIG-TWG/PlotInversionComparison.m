

%%
clearvars File
File(1)="PIG-TWG-Inverse-PIG-TWG-Meshk-logA-logC-MatlabOptimization-GradientBased-I-adjoint-RHA=E-RHC=E-IHC=FP-IHA=FP-Weertman-1-InverseRestartFile.mat";
File(2)="PIG-TWG-Inverse-PIG-TWG-Meshk-logA-logC-MatlabOptimization-GradientBased-M-adjoint-RHA=E-RHC=E-IHC=FP-IHA=FP-Weertman-1-InverseRestartFile.mat";
File(3)="PIG-TWG-Inverse-PIG-TWG-Meshk-logA-logC-MatlabOptimization-HessianBased-M-adjoint-RHA=E-RHC=E-IHC=FP-IHA=FP-Weertman-1-InverseRestartFile.mat";



fig=FindOrCreateFigure('Inverse Parameter Optimisation');
clf(fig)

for I=1:numel(File)
    load(File(I))
    
    semilogy(RunInfo.Inverse.Iterations,RunInfo.Inverse.J,'-o','LineWidth',2)
    hold on
    
end


ylabel('J')
legend('Gradient I','Gradient M','Hessian')

xlabel('Inverse iteration') ;
