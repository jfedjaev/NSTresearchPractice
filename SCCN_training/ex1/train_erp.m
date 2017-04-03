function model = train_erp(EEG, Fs, ev_lats, ev_labels, epo_range, time_ranges, lambda)
% Train an ERP classifier on the given data
% Model = train_erp(Data,SamplingRate,EventLatencies,EventLabels,EpochRange,TimePoints,Lambda)
%
% In:
%   Data : raw multi-channel EEG signal, size is [#channels x #samples]
%
%   SamplingRate : sampling rate of the data, in Hz
%
%   EventLatencies : vector of sample offsets at which events occur
%
%   EventLabels : vector of true labels for each event (-1 = first class, +1 = second class)
%
%   EpochRange : time range relative to each event that shall be used for training
%                this is a 2-element vector with values in seconds [begin, end]
%
%   TimeRanges : time ranges in seconds relative to the epoch event
%                this is a [#ranges x 2] matrix with ranges in the rows
%                these ranges determine the time windows for which average features
%                should be extracted from the epochs
%
%   Lambda : regularization parameter for shrinkage LDA (between 0 and 1)
%
% Out:
%   Model : matlab struct that contains the model's parameters
%           (classifier weights, temporal filter)

% convert the epoch range into a vector sample offsets relative to the event
% (e.g., [-3,-2,-1,0,1,2,3,4,5,6])
wnd = round(epo_range(1)*Fs) : round(epo_range(2)*Fs);

% convert time ranges into a cell array of sample offset vectors that can be 
% used to index the time points within an epoch
for r=1:length(time_ranges)
    model.ranges{r} = 1 + (round(time_ranges(r,1)*Fs) : round(time_ranges(r,2)*Fs)) - wnd(1);
end

% extract training epochs (EPO is a 3d array of size (#channels x #samples x #trials)
EPO = EEG(:, repmat(ev_lats,length(wnd),1) + repmat(wnd',1,length(ev_lats)));
EPO = reshape(EPO,size(EPO,1),[],length(ev_lats));

% determine number of channels, epoch time points, trials, and number of time ranges
[nbchan,pnts,trials] = size(EPO);
nbranges = size(time_ranges,1);

% extract features for each epoch
% features is a [#trials x #dims] matrix of feature vectors per trial
features = zeros(trials, nbranges * nbchan);
for e=1:length(ev_lats)
    % get epoch X and subtract per-trial mean
    X = EPO(:,:,e) - repmat(mean(EPO(:,:,e),2),1,size(EPO,2));
    
    % extract per-trial features
    trialfeatures = zeros(nbranges,nbchan);
    % for each time range...
    for r=1:length(model.ranges)
        % calculate the mean for each channel and store it
        trialfeatures(r,:) = mean(X(:,model.ranges{r})');
    end
    
    % turn per-trial features into a vector and store
    features(e,:) = trialfeatures(:);
end

% train shrinkage LDA classifier (TODO: fill in)

model.w = ...
model.b = ...
