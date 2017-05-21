%% Plot graphics for repor
raw = recording.X;
pos     = recording.trial;

%% first plot with raw data
figure 
subplot(3,1,1)
plot(1:1000, raw(1:1000,1), '-r')
title('Raw EEG signal data for the first 1000 samples')
hold on, subplot(3,1,2) 
plot(1:1000, raw(1:1000,2), '-b')
ylabel('Voltage V')
hold on, subplot(3,1,3)
plot(1:1000, raw(1:1000,3), '-g')
xlabel('Sample n')


%% plot with detrended, filtered data
detrended_dataset = detrendData(raw, pos);
filtered_dataset = filterData(detrended_dataset, pos);

%% normalize and scale data
X_data_mean = mean(filtered_dataset);
X_data_std = std(filtered_dataset);
X_data_norm = bsxfun(@rdivide, filtered_dataset, X_data_std);

%% plot
figure 
subplot(3,1,1)
plot(1:1000, X_data_norm(1:1000,1), '-r')
title('Detrended, filtered and normalized EEG signal')
hold on, subplot(3,1,2) 
plot(1:1000, X_data_norm(1:1000,2), '-b')
ylabel('Voltage V (normalized)')
hold on, subplot(3,1,3)
plot(1:1000, X_data_norm(1:1000,3), '-g')
xlabel('Sample n')
