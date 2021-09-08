%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% GEOMETRY BOUNDS
%
% This subroutine sets the geometry bounds for shape optimisation and saves
% the initial geometry in ./Outputs/Initialisation
%
%%%%%%%% SEE BOTTOM OF SCRIPT TO ENTER LINEAR EQUALITY CONSTRAINTS %%%%%%%%
% 
% Last update : 25/05/2021
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Retrieve combustor data from Geometry.txt file

filename='./Inputs/Geometry.txt';
fid=fopen(filename);

C_title = textscan(fid, '%s', 4);           % Read title
C_cell = textscan(fid, '%f %f %f %f');      % Read numeric data
fclose(fid);

x_sample       = C_cell{1}; % Axial references                   
r_sample       = C_cell{2}; % Radius

%% Save initial geometry as output

copyfile ./Inputs/Geometry.txt ./Outputs/Initialisation/Initial_geometry.txt

%% Set geometry limits

% Error message if BOUND_METHOD is outside of limit 0 <= BOUND < 100
if BOUND_METHOD < 0 || BOUND_METHOD >= 100
    error("Optimisation file: Unsupported geometry bound. Set as an integer, x, below 100 to vary all measurements x%, or set as 0 and specify geometry limits in Geometry_bounds.txt.")
end

len = length(r_sample);
nvars = 2*len;

% Set limits based on chosen bound method
if BOUND_METHOD == 0
    % Read an input file with the stated bounds
    filename1='./Inputs/Geometry_bounds.txt';
    fid1=fopen(filename1);

    C_title1 = textscan(fid1, '%s', 4);           % Read title
    C_cell1  = textscan(fid1, '%f %f %f %f');     % Read numeric data
    fclose(fid1);

    lb_x = C_cell1{1}; % Axial lengths lower bound                   
    ub_x = C_cell1{2}; % Axial lengths upper bound
    lb_r = C_cell1{3}; % Radial lower bound 
    ub_r = C_cell1{4}; % Radial upper bound
    
    lb = [lb_x; lb_r];
    ub = [ub_x; ub_r];
end

if BOUND_METHOD > 0
    % Geometry limits are set as +/- BOUND_METHOD %
    range = BOUND_METHOD / 100;
    lb_x = [(1-range)*diff(x_sample); 0];
    ub_x = [(1+range)*diff(x_sample); 0];

    lb = [lb_x; (1-range)*r_sample];
    ub = [ub_x; (1+range)*r_sample];
end

%% Linear equality constraint for genetic algorithm

Aeq = zeros(nvars, nvars);
beq = zeros(nvars, 1);

% Ensures outllet radius matches the radius just before the outlet
Aeq(nvars-1,nvars-1) = 1;
Aeq(nvars-1,nvars) = -1;

%%%%%%% USER DEFINED LINEAR CONSTRAINTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% % FOR RIJKE: Total length sums to 1.1m 
% Aeq(1,1) = 1;
% Aeq(1,2) = 1;
% beq(1) = 1.1;

% % FOR PALIES: First two radii are equal
% Aeq(nvars/2+1,nvars/2+1) = 1;
% Aeq(nvars/2+1,nvars/2+2) = -1;
% % and final two radii are equal
% Aeq(nvars/2+2,nvars-1) = 1;
% Aeq(nvars/2+2,nvars) = -1;

% % User defined constraints below:
% Aeq(-,-) = -;
% Aeq(-,-) = -;
% beq(-) = -;
