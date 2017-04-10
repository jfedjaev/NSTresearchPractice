%% This function sets the onset time of trials and classes
%  Author:  Juri Fedjaev
%  Last modified: 10//04/17

function [data] = getClassLabels(data, nCh)
%% define constants
TRIAL_LENGTH = 8; % in seconds
trial_lgth_smpls = TRIAL_LENGTH * data.numTrials * data.fs;
%sz = length(data.X);

%% set class label names
data.classes{1,1} = 'left arm';
data.classes{1,2} = 'right arm';
data.classes{1,3} = 'both arms';

%% get trial onset times
onsets = 1:(TRIAL_LENGTH*data.fs):trial_lgth_smpls;
data.trial = onsets; 

%% set corresponding trial labels
counter = 1;
for i=1:length(onsets)
    switch counter
        case 1
            ylab(i) = 1;
            counter = counter+1;
        case 2
            ylab(i) = 2;
            counter = counter+1;
        case 3
            ylab(i) = 3;
            counter = 1;
    end         
end

data.y = ylab; 


end