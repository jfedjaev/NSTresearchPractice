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
fc_low = 2; % low cut-off frequency of 8 Hz
fc_high = 50; % high cut-off frequency of 30 Hz


%% filter signal with 8th order butterworth filter
[b,a] = butter(8, [fc_low/(fs/2), fc_high/(fs/2)]);
filtered_data = filtfilt(b,a,input);



end

