function [Y] = Objective_subfc(input)
%OBJECTIVE_SUBFC Summary: Function to minimise for optimisation
%   Function takes a row vector describing combustor geometry within upper
%   and lower geometry bounds
%   Function returns a scalar to minimise based on growth rates of modes
%
%   Last update : 21/05/2021


% Input.txt values for optimisation
DISP_FIGS       = false; % Specify whether to save display figures (speeds up output)     
SMALL_PLOTS     = false; % Small figures for smaller screens             
SAVE_PDFS       = false; % Specify whether to save PDF copies (speeds up output)        
SAVE_FIGS       = false; % Specify whether to save .fig files (speeds up output)
SAVE_EIGS       = false; % Specify whether to save the eigenvalue file   
PLOT_MODES      = 0;     % Number of modes to plot
RUN_OPTIM       = true;  % Specify whether to run optimisation


% Retrieve data from Optimisation.txt file
filename='./Inputs/Optimisation.txt';
fid=fopen(filename);

C_title = textscan(fid, '%s', 5);               % Read title
C_cell  = textscan(fid, '%f %f %f %f %f');      % Read numeric data
fclose(fid);

BOUND_METHOD    = C_cell{1};    % Specify which method to use to constrain geometry     
POP_SIZE        = C_cell{2};    % Specify population size for GA             
MAX_GEN         = C_cell{3};    % Specify maximum generations for GA        
ELITE_COUNT     = C_cell{4};    % Specify elite count for GA
MAX_GR          = C_cell{5};    % Specify maximum GR for termination


% Set up geometry file to be tested
len_x = length(input)/2;
x_loop = zeros(1,len_x);
for i = 1:len_x-1
    x_loop(i+1) = x_loop(i) + input(i);
end
r_loop = input(len_x + 1:2 * len_x);

filename2='./Inputs/Geometry.txt';
fid1=fopen(filename2);
C_title1 = textscan(fid1, '%s', 4);            % Read title
C_cell1  = textscan(fid1, '%f %f %f %f');      % Read numeric data
fclose(fid1);

fid2=fopen('./Inputs/Geometry.txt','w');
fprintf(fid2, 'x[m] \t r[m] \t SectionIndex \t TubeIndex \n');

loop = ([x_loop; r_loop; C_cell1{3}.'; C_cell1{4}.']);

fprintf(fid2, '%f \t \t %f \t \t %f \t \t %f \n', loop);
fclose(fid2);


% Run OSCILOS_opt with geometry between upper and lower bounds
addpath('./SubFunctions')
run Geometry_subfc
run Mean_flow_subfc
run Flame_subfc
run BC_subfc
run Solver_subfc


% Data_num stores the frequency and growth rate of each mode of response
GR = data_num(:,2);


% Global variable indicates if all GR are below the maximum and thus the
% algorithm terminates (see 'GA_out_subfc')
global terminate
if GR <= MAX_GR
    terminate = true;
end


% Scalar output for optimisation to minimise is the modified sum of the
% softplus of growth rates
% May introduce alternative functions to minimise
Y = sum(log(1 + exp((GR-MAX_GR)/10)));

end
