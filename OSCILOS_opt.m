%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% OSCILOS_opt v1.0
%
% This program is the optimising version of OSCILOS_lite - the program
% optimises the shape of a thermoacoustically unstable combustor using a
% genetic algorithm (GA) and determines an improved geometry for further
% analysis.
%
% Please update the input files before running this script. More
% information about the required inputs is included in the User Guide.
%
% Last update : 25/05/2021
%
% Authors: H. Jones, R. Gaudron and previous contributors (see full list on
% the OSCILOS website).
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% INITIALISATION
%
% This subroutine loads the 'Init.txt' file and initialises OSCILOS_opt

addpath('./SubFunctions')
run Init_subfc

%% Optimisation
%
% This subroutine initiates the shape optimisation in OSCILOS_opt

if RUN_OPTIM
    run Optimisation_subfc
end

%% GEOMETRY
%
% This subroutine loads the geometry from the file 'Geometry.txt', plots it
% and saves it in the output folder.

run Geometry_subfc

%% MEAN FLOW
%
% This subroutine loads the mean flow parameters at the inlet of the
% geometry from the file 'Mean_flow.txt'. The mean conservation equations
% are then solved and the mean flow variables are obtained throughout the
% geometry. The mean velocity and mean temperature across the geometry are
% then plotted and saved in the output folder.

run Mean_flow_subfc

%% FLAME MODEL
%
% This subroutine loads the flame model from the file 'Flame.txt'. The gain
% and phase of the corresponding Flame Model are then plotted and saved in
% the output folder. If heat perturbations are not present inside the
% domain, this step has no impact on the final result.

run Flame_subfc

%% BOUNDARY CONDITIONS
%
% This subroutine loads the acoustic boundary conditions at the inlet and 
% outlet of the geometry from files 'Inlet.txt' and 'Outlet.txt'
% respectively. The acoustic reflection coefficient at the inlet and outlet
% are then plotted and saved in the output folder.

run BC_subfc

%% FREQUENCY-DOMAIN SOLVER
%
% This subroutine loads the scan range and number of initialisations - fed
% to the frequency-domain solver - from the file 'Scan_range.txt'. The
% solver then finds the eigenvalues of the system, and the corresponding
% eigenmodes. The eigenvalues are saved as an output file called
% 'Eigenvalues.txt'. A map of the eigenvalues in the range of interest is
% then plotted and saved in the output folder. A number of eigenmodes,
% represented as the modulus of the acoustic pressure and velocity, are
% also plotted and saved in the output folder.

run Solver_subfc

%% MESSAGE BOX

time=toc;
time_final=num2str(sprintf('%.2f',time));
if RUN_OPTIM
    if data_num(:,2) <= 0
        text=['Optimisation completed in ',time_final,' seconds'];
    else
        text=['Optimisation routine completed in ',time_final,' seconds without finding a stable geometry.'];
    end
else
    text=['Calculation completed in ',time_final,' seconds'];
end
cltext = " Close Plots ";
f = questdlg(text,'OSCILOS_opt','OK',	cltext, 'OK');
if f==cltext
    close all
end
if RUN_OPTIM
    if data_num(:,2) <= 0
        fprintf("\n Optimisation completed in %s seconds.\n",time_final)
    else
        fprintf("\n Optimisation routine completed in %s seconds without finding a stable geometry.\n",time_final)
    end
else
    fprintf("\n Calculation completed in %s seconds.\n",time_final)
end
