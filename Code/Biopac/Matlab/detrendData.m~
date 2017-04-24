function dataset = detrendData(data, pos)
%% This function detrends data based on subtracting the amplitude mean on a trial basis
%  Inputs:
%       data : the input data that needs to be detrended
%       pos  : starting position of the individual trials

fs = 200;   % 200 Hz standard sample rate for Biopac EEG recordings
t_trial = 8;    % trials length of 8 seconds
n_smpls = fs * t_trial;

for i=1:length(data)-n_smpls
    % extract trials channel-wise
    c1 = data(i:i+n_smpls,1);
    c2 = data(i:i+n_smpls,2);
    c3 = data(i:i+n_smpls,3);
    
    % calculate mean
    c1_mean = mean(c1);
    c2_mean = mean(c2);
    c3_mean = mean(c3);
    
    % subtract mean from trial
    
    
    
end



end %fct

