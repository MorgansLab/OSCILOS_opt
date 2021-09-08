function [state,options,optchanged] = GA_out_subfc(options,state,flag)
% GA_OUT_SUBFC Summary: Provides termination criteria for the GA and varies
% crossover fraction for a broader initial search
%
%   Last update : 12/05/2021

optchanged = false; % In general no GA options change after each generation
global terminate % Global termination variable (see Objective_subfc)

Current_gen = state.Generation + 1;
Max_gen = options.MaxGenerations;
if Current_gen <= Max_gen
    fprintf("Simulating generation %d of %d.\n ", [Current_gen Max_gen])
end

switch flag
    case 'init'
        
    case {'iter','interrupt'}
        % Increase crossover fraction after half of generations to allow
        % for a broader initial search which later becomes more focused
        if state.Generation == ceil(options.MaxGenerations/2)
            options.CrossoverFraction = 0.8;
            optchanged = true; % GA options have changed
        end
        
        % Terminate algorithm if all growth rates fall below an input value
        if terminate == true
            state.StopFlag = 'y';
            disp('All growth rates are below maximum.')
        end
        % Terminate algorithm after no improvement in best performer over a
        % number of generations
        if state.Generation == ceil(options.MaxGenerations/2)
            if state.Generation - state.LastImprovement >= 10
                state.StopFlag = 'y';
                disp('No improvement over many generations.')
            end
        end
        
    case 'done'
        
end

