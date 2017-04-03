%% === constants ===

% the time window relative to each event that may be used for classification
epoch_range = [-0.2 0.8];

% time ranges over which per-channel features should be extracted
time_ranges = [0.25 0.3; 0.3 0.35; 0.35 0.4; 0.4 0.45; 0.45 0.5; 0.5 0.6];

% regularization parameter for the shrinkage LDA
lambda = 0.1;

%% === train an ERP classifier ===

% load the calibration data set
load ERP_CALIB

% identify the sample latencies at which relevant events occur and their 
% associated target class (=0 no error, 1=error)
train_events = strcmp({ERP_CALIB.event.type},'S 11') | strcmp({ERP_CALIB.event.type},'S 12') | strcmp({ERP_CALIB.event.type},'S 13');
train_latencies = round([ERP_CALIB.event(train_events).latency]);
train_labels = (~strcmp({ERP_CALIB.event(train_events).type},'S 11'))*2-1;
model = train_erp(ERP_CALIB.data,ERP_CALIB.srate,train_latencies,train_labels,epoch_range,time_ranges,lambda);


%% === apply the classifier to each event in the test data ===
load ERP_TEST

% determine the relevant event latencies and true labels
test_events = strcmp({ERP_TEST.event.type},'S 11') | strcmp({ERP_TEST.event.type},'S 12') | strcmp({ERP_TEST.event.type},'S 13');
test_latencies = round([ERP_TEST.event(test_events).latency]);
test_labels = (~strcmp({ERP_TEST.event(test_events).type},'S 11'))*2-1;

% also get the sample range that is used to extract epochs relative to the events
epoch_samples = round(epoch_range(1)*ERP_TEST.srate) : round(epoch_range(2)*ERP_TEST.srate);

% for each test event...
predictions = [];
for e=1:length(test_latencies)
    % extract the epoch
    EPO = ERP_TEST.data(:,epoch_samples + test_latencies(e));
    % classify it and record the prediction
    predictions(e) = test_erp(EPO,model);
end

%% === evaluate the loss on the test set ===
loss = eval_mcr(test_labels,predictions);
fprintf('The mis-classification rate on the test set is %.2f percent.\n',100*loss);
