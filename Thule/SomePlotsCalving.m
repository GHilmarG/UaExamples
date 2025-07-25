


CurDir=pwd ;


[~,hostname]=system('hostname') ;

if contains(hostname,"DESKTOP-G5TCRTD")

    UserVar.ResultsFileDirectory="F:\Runs\Calving\Thule\ResultsFiles\";

elseif contains(hostname,"DESKTOP-BU2IHIR")

    UserVar.ResultsFileDirectory="D:\Runs\Calving\Thule\ResultsFiles\";

elseif contains(hostname,"C17777347")

    UserVar.ResultsFileDirectory="D:\Runs\Calving\Thule\ResultsFiles\";

else

    error("case not implemented")

end

cd(UserVar.ResultsFileDirectory) ; 

% 30km = 14km
% 20km = 9.3km
% 10km = 4.6km
%  5km = 2.3km
% 2.5km = 1.16km

%  1.5 experiments

fEx="1.1";
fEx="2.0";
% fEx="RR"; 
% fEx="Max"; 
% fEx="Min"; 

fEx="Thule-C-Tmin-C-NV2k0-10km" ;
% fEx="Thule-C-Tmax-C-NV2k0-10km" ;
fEx="Thule-P-SSmax-10km-Cxy-";
fEx="Thule-P-SSmin-10km-Cxy-";

switch fEx

    case "2.0"

        SubString(1)="NV-=+2k0-Thule-";
        IRange=1;

    case "1.1"
        % 1.1 experiments

        SubString(1)="NV-=+1k1-Thule-";

        IRange=1:1;


    case "RR"

        SubString(1)="T-C-RR-BMCF-MR4-SM-u-cl-mu0k1-Ini-geo-100-Strip1-SW=100km-AD=0-RR-BMCF-int-asRacmo-dhdtLim1-PIG-TWG-MeshFile30km-PIG-TWG";
        SubString(2)="T-C-RR-BMCF-MR4-SM-u-cl-mu0k1-Ini-geo-100-Strip1-SW=100km-AD=0-RR-BMCF-int-asRacmo-dhdtLim1-PIG-TWG-MeshFile20km-PIG-TWG";
        SubString(3)="T-C-RR-BMCF-MR4-SM-u-cl-mu0k1-Ini-geo-100-Strip1-SW=100km-AD=0-RR-BMCF-int-asRacmo-dhdtLim1-PIG-TWG-MeshFile10km-PIG-TWG";
        SubString(4)="T-C-RR-BMCF-MR4-SM-u-cl-mu0k1-Ini-geo-100-Strip1-SW=100km-AD=0-RR-BMCF-int-asRacmo-dhdtLim1-PIG-TWG-MeshFile5km-PIG-TWG";  % not done


        IRange=4;

    otherwise

        SubString(1)=fEx;
        IRange=1:1;

end


CreateVideo=true;
CalcVAF=false;

if CalcVAF
    TimeStep=5;
else
    TimeStep=10;
end

if CreateVideo

    for I=IRange
        ReadPlotSequenceOfResultFiles(FileNameSubstring=SubString(I),PlotTimestep=TimeStep,PlotType="-ubvb-B-") ;
    end

end

col=["r","b","g","m","c"] ;
DataCollect=cell(5,1) ; 


if CalcVAF

    fig=FindOrCreateFigure("VAF"); clf(fig);

    for I=IRange

        DataCollect{I}=ReadPlotSequenceOfResultFiles(FileNameSubstring=SubString(I),PlotType="-collect-",PlotTimestep=TimeStep) ;

    end

    for I=IRange

        if I==IRange(1)
            VAF0=DataCollect{I}.VAF(1);  % The ref value
        else
            hold on
        end


        yyaxis left
        plot(DataCollect{I}.time, (DataCollect{I}.VAF-VAF0)/1e9,'-o',color=col(I));
        tt=ylim;
        ylabel(" VAF (km^3)")
        yyaxis right
        AreaOfTheOcean=3.625e14; % units m^2.
        ylim(tt*1000*1e9/3.62e14) ;
        ylabel(" Equvivalent global sea level change (mm)")

        xlabel("time (yr)") ;

        %FindOrCreateFigure("Grounded area");
        %plot(DataCollect.time,DataCollect.GroundedArea/1e6,'-or');
        %xlabel("time (yr)") ; ylabel(" Grounded area(km^2)")

    end

fig.CurrentAxes.YAxis(1).Exponent=0;

% 30km = 14km
% 20km = 9.3km
% 10km = 4.6km
%  5km = 2.3km
% 2.5km = 1.16km
    %legend("30km","20km","10km","5km") ;   title("VC=1.1")
    legend("14 km","9.3 km","4.6 km","2.3 km") ;

    if  fEx=="RR"
        title("Retreat rate = 1k/yr if v > 1km/yr")
    elseif fEx=="1.1"
        title("$c= 1.1 \times \boldmath{v} \cdot \boldmath{n} $",Interpreter="latex")
    end

    % f=gcf; exportgraphics(f,'VAF-VC1k1.pdf')

end

cd(CurDir)