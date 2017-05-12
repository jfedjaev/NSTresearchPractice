function [onsets_shifted] = shiftLabels(pos, T_CUE_ON)
%% This function shifts the EEG trial labels to MI location 
%  Inputs:
%       pos : trial onset at sample n 
%       T_CUE_ON : cue onset in experiment (in seconds)
%       T_CUE : duration of cue display in experiment
%  Outputs:
%       onsets_shifted : shifted trial onsets (at cue)

%% initialize data
fs = 200;   % 200 Hz standard sample rate for Biopac EEG recordings

%% shift onsets
for i=1:length(pos)
    pos(i) = pos(i) + fs*T_CUE_ON;
end

onsets_shifted = pos;

end

