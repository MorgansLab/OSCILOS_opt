%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% INITIALISATION
%
% This subroutine loads the 'Init.txt' file and initialises OSCILOS_opt
% 
% Last update : 24/11/2020
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Initialisation

clear all; close all; clc;
tic;
addpath('./SubFunctions/SubsubFunctions')

delete Outputs/Initialisation/*
delete Outputs/Results/*

OSCILOS_OPT_VERSION='1.0';

%% Printing message on screen

fprintf("---------------------------------------------------------------\n")
fprintf("\t\t OSCILOS_opt version %s\n",OSCILOS_OPT_VERSION)
fprintf("---------------------------------------------------------------\n\n")
fprintf(" Initialising OSCILOS_opt... ");

%% Retrieving the data from the input file

filename1='./Inputs/Init.txt';
fid1=fopen(filename1);

C_title1    = textscan(fid1, '%s', 7);                  % read title
C_cell1     = textscan(fid1, '%f %f %f %f %f %f %f');   % read numeric data
fclose(fid1);

DISP_FIGS       = C_cell1{1}~=0; % Specify whether to save display figures (speeds up output)     
SMALL_PLOTS     = C_cell1{2}~=0; % Small figures for smaller screens             
SAVE_PDFS       = C_cell1{3}~=0; % Specify whether to save PDF copies (speeds up output)        
SAVE_FIGS       = C_cell1{4}~=0; % Specify whether to save .fig files (speeds up output)
SAVE_EIGS       = C_cell1{5}~=0; % Specify whether to save the eigenvalue file   
PLOT_MODES      = C_cell1{6};    % Number of modes to plot
RUN_OPTIM       = C_cell1{7}~=0; % Specify whether to run optimisation

fprintf("Done.\n ");
