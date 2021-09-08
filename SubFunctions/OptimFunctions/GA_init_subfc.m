%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% GENETIC ALGORITHM INITIALISATION
%
% This subroutine initialises the genetic algorithm
% 
% Last update : 21/03/2021
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Optimisation initialisation

% Set random number seed for reproduceable optimisation results
rng(0, 'twister');

% Retrieve data from Optimisation.txt input file
filename1='./Inputs/Optimisation.txt';
fid1=fopen(filename1);

C_title1 = textscan(fid1, '%s', 5);               % Read title
C_cell1  = textscan(fid1, '%f %f %f %f %f');      % Read numeric data
fclose(fid1);

BOUND_METHOD    = C_cell1{1};    % Specify which method to use to constrain geometry     
POP_SIZE        = C_cell1{2};    % Specify population size for GA             
MAX_GEN         = C_cell1{3};    % Specify maximum generations for GA        
ELITE_COUNT     = C_cell1{4};    % Specify elite count for GA 
MAX_GR          = C_cell1{5};    % Specify maximum GR for termination

%% Set genetic algorithm parameters

opts = optimoptions(@ga, 'OutputFcn', @GA_out_subfc, ...
                    'MutationFcn', {@mutationadaptfeasible}, ...
                    'CrossoverFraction', 0.2, ...
                    'PopulationSize', POP_SIZE, ...
                    'MaxGenerations', MAX_GEN, ...
                    'EliteCount', ELITE_COUNT, ...
                    'FunctionTolerance', 1e-6, ...
                    'PlotFcn', @gaplotbestf);
