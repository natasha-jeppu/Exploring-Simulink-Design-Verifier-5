% This script runs the mutant files in a batch for property proving using
% SLDV. The SLDV options are given below as an aid. In this file the
% options have been set to 
%
%     opts.Mode = 'PropertyProving'; % Set mode to property proving
%     opts.ProvingStrategy = 'FindViolation'; % Find violations instead of prove - FASTER
%     opts.MaxViolationSteps = 30; % Set max steps to 30
%     opts.MaxTestCaseSteps = 600; % Set max steps to 600 (10 min)
%
% A report file reports.txt is generated. Mutants that are killed are
% denoted by the proof being falsified. To know the mutants that have not
% been killed look for the keyword "Proven valid within bound"
% find "Proven valid within bound" report.txt in the DOS prompt can give
% you the list of mutant files that have not been killed.
 
% Copyright (c) Natasha.Jeppu@gmail.com



% MaxViolationSteps - {20} specifies the maximum steps to search for
% violations when using the proving strategy FindViolation.
%
% ProvingStrategy -  [{'Prove'} | 'FindViolation' | 'ProveWithViolationDetection']
% specifies which property proving strategy should be used.  The Prove strategy
% verifies properties hold for any length simulation.  The FindViolation strategy
% verifies there are no violations up to a limited number of steps. The
% 'ProveWithViolationDetection' strategy verifies properties hold for any
% length simulation, but it is more efficient in detecting violations.
%
% ProofAssumptions - [{'UseLocalSettings'} | 'EnableAll' | 'DisableAll']
% specifies which Proof Assumption blocks should be used.  Only used during
% property proving mode.
%
% Assertions - [{'UseLocalSettings'} | 'EnableAll' | 'DisableAll']
% specifies which assertion block inputs should be used as proof objectives.
% Only used during property proving mode.
%
% Mode - [ 'DesignErrorDetection' | {'TestGeneration'} | 'PropertyProving']
% selects the processing mode.
%
% MaxTestCaseSteps - {10000} specifies the maximum number of simulation steps
% Simulink Design Verifier takes when attempting to satisfy a test objective.

d=dir('mutant*.slx'); % get all files staring with mutant
diary reports.txt      % start a diary to log
datetime
disp('=========================================================');
for i = 1:length(d)
    bdclose all
    filemdl = d(i).name;
    model_name = strrep(d(i).name,'.slx','');  % without slx extension
    tic
    disp('=========================================================');
    disp(['Running Prover for ... ' d(i).name]);
    open_system(filemdl)              % open model
    opts = sldvoptions(model_name);   % get the options
    opts.Mode = 'PropertyProving';  % Set mode to property proving
    opts.ProvingStrategy = 'FindViolation'; % Find violations instead of prove - FASTER
    opts.MaxViolationSteps = 10; % Set max steps to 10
    opts.MaxTestCaseSteps = 600; % Set max steps to 600
    
    [STATUS,FILENAMES] = sldvrun(model_name,opts);   % Analyze the model
    load(FILENAMES.DataFile); % load the data file
    disp(['Model ' filemdl ', Status: ' sldvData.Objectives.status]); % Display the status Fail/Valid
    toc
end
disp('=========================================================');
bdclose all    % close all models
diary off