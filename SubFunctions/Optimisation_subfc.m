%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% OPTIMISATION
%
% This subroutine uses a genetic algorithm to optimise the combusor
% geometry with optimisation parameters defined in Optimisation.txt
% 
% Last update : 21/04/2021
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Plot initial shape and eigenvalues

fprintf("Plotting initial shape and eigenvalues... ");

% See OSCILOS_opt for subfunction details
run Geometry_subfc
run Mean_flow_subfc
run Flame_subfc
run BC_subfc
run Solver_subfc

% Save initial geometry performance
copyfile ./Outputs/Results ./Outputs/Initialisation
delete Outputs/Results/*

fprintf("Done.\n ");

if data_num(:,2) <= 0
    warning("Geometry is already stable so optimisation may be unnecessary. Click 'Continue' to proceed with optimisation.")
end

%% Initialise Optimisation
%
% This subroutine loads the 'Optimisation.txt' file and initialises the
% optimisation

fprintf("Optimising...\n ");

addpath('./SubFunctions/OptimFunctions')
run GA_init_subfc

%% Geometry Constraints
%
% This subroutine sets the combustor geometry constraints for optimisation

run Geometry_bounds_subfc

%% Optimise using OSCILOS
%
% This function runs the genetic algorithm and optimises geometry using
% Objective_subfc and terminates the algorithm based on GA_out_subfc

[var_best, func_best, exitflag] = ga(@Objective_subfc, nvars, [], [], ...
    Aeq, beq, lb, ub, [], opts);

%% Plot Results
%
% This subroutine restores the original 'Init.txt' variables to plot and
% save the optimised combustor geometry

run Plot_results_subfc