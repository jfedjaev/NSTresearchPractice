function detrended_data = detrendData(input, pos)
%% This function detrends data based on subtracting the amplitude mean on a trial basis
%  Inputs:
%       data : the input data that needs to be detrended
%       pos  : starting position of the individual trials

%% initialize data
fs = 200;   % 200 Hz standard sample rate for Biopac EEG recordings
t_trial = 8;    % trials length of 8 seconds
n_smpls = fs * t_trial;


%% detrend data and save to new variable 
for i=1:n_smpls:length(input)
    % extract trials channel-wise
    c1 = input(i:i+n_smpls-1,1);
    c2 = input(i:i+n_smpls-1,2);
    c3 = input(i:i+n_smpls-1,3);
    
    % calculate mean
    c1_mean = mean(c1);
    c2_mean = mean(c2);
    c3_mean = mean(c3);
    
    % subtract mean from trial
    detrended_data(i:i+n_smpls-1, 1) = c1 - c1_mean;
    detrended_data(i:i+n_smpls-1, 2) = c2 - c2_mean;
    detrended_data(i:i+n_smpls-1, 3) = c3 - c3_mean;    
end

%% plot
% plot(detrended_data(:, 1))
% figure 
% plot(detrended_data(:, 2))
% figure
% plot(detrended_data(:, 3))


end %fct

