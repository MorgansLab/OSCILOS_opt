%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% PLOT OPTIMISATION RESULTS
%
% This subroutine plots the final results of optimisation
% 
% Last update : 21/04/2021
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Save final combustor geometry

len_x = length(var_best)/2;
x_best = zeros(1,len_x);
for i = 1:len_x-1
    x_best(i+1) = x_best(i) + var_best(i);
end
r_best = var_best(len_x + 1:2 * len_x);

filename='./Inputs/Geometry.txt';
fid=fopen(filename);
C_title = textscan(fid, '%s', 4);            % Read title
C_cell  = textscan(fid, '%f %f %f %f');      % Read numeric data
fclose(fid);

best = ([x_best; r_best; C_cell{3}.'; C_cell{4}.']);

fid1=fopen('./Inputs/Geometry.txt','w');
fprintf(fid1, 'x[m] \t r[m] \t SectionIndex \t TubeIndex \n');
fprintf(fid1, '%f \t \t %f \t \t %f \t \t %f \n', best);
fclose(fid1);

copyfile ./Inputs/Geometry.txt ./Outputs/Results/Final_geometry.txt

%% Retrieve data from Init.txt to plot optimised geometry

clear variables

filename2='./Inputs/Init.txt';
fid2=fopen(filename2);

C_title2    = textscan(fid2, '%s', 7);                 % read title
C_cell2     = textscan(fid2, '%f %f %f %f %f %f %f');  % read numeric data
fclose(fid2);

DISP_FIGS       = C_cell2{1}~=0; % Specify whether to save display figures (speeds up output)     
SMALL_PLOTS     = C_cell2{2}~=0; % Small figures for smaller screens             
SAVE_PDFS       = C_cell2{3}~=0; % Specify whether to save PDF copies (speeds up output)        
SAVE_FIGS       = C_cell2{4}~=0; % Specify whether to save .fig files (speeds up output)
SAVE_EIGS       = C_cell2{5}~=0; % Specify whether to save the eigenvalue file   
PLOT_MODES      = C_cell2{6};    % Number of modes to plot
RUN_OPTIM       = C_cell2{7}~=0; % Specify whether to run optimisation

%% Save GA plot

if SAVE_FIGS
    savefig('./Outputs/Results/GA_plot.fig')
end
if SAVE_PDFS
    GA_plot = openfig('./Outputs/Results/GA_plot.fig');
    save2pdf('./Outputs/Results/GA_plot',GA_plot,300)
    close(GA_plot)
end

%% Label plots

if DISP_FIGS
    fprintf("\n Figure 1: Initial Geometry\n ");
    fprintf("Figure 2: Initial Eigenvalue Map\n ");
    fprintf("Figure 3: Mean and Best Genetic Algorithm Score at Each Generation\n ");
    fprintf("Figure 4: Optimised Geometry\n ");
    fprintf("Figure 5: Optimised Eigenvalue Map\n ");
end