function [filtered_data] = filterData(input, pos)
%% This function filters the EEG data w/ bandpass + notch filters
%  Cutoff frequencies for BP: 8 and 30 Hz; 50 Hz for notch filter
%  Inputs:
%       data : the input data that needs to be detrended
%       pos  : starting position of the individual trials
%  Outputs:
%       filtered_data : filtered signal inputs

%% initialize data
fs = 200;   % 200 Hz standard sample rate for Biopac EEG recordings
t_trial = 8;    % trials length of 8 seconds
n_smpls = fs * t_trial;

%% filter trial wise with a bandpass filter 
for i=1:n_smpls:length(input)
   
end

end

