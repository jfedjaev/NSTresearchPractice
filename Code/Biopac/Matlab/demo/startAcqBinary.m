function [retval, X] = startAcqBinary(dothdir,libname,mptype, mpmethod, sn, DURATION, T_BLANK, T_CUE_ON, T_CUE, T_PERIOD, nCh, cueOn);


%% Connect
fprintf(1,'Connecting...\n');

[retval, sn] = calllib(libname,'connectMPDev',mptype,mpmethod,sn);

if ~strcmp(retval,'MPSUCCESS')
    fprintf(1,'Failed to Connect.\n');
    calllib(libname, 'disconnectMPDev');
    return
end

fprintf(1,'Connected\n');

%% Configure
fprintf(1,'Setting Sample Rate to 200 Hz\n');
retval = calllib(libname, 'setSampleRate', 5.0);

if ~strcmp(retval,'MPSUCCESS')
    fprintf(1,'Failed to Set Sample Rate.\n');
    calllib(libname, 'disconnectMPDev');
    return
end

fprintf(1,'Sample Rate Set\n');


%% set acquisition channels
if nCh == 2
    fprintf(1,'Setting to Acquire on Channels 1 and 2\n');
    aCH = [int32(1),int32(1),int32(0),int32(0),int32(0),int32(0),int32(0),int32(0),int32(0),int32(0),int32(0),int32(0),int32(0),int32(0),int32(0),int32(0)];
end
if nCh == 3
    fprintf(1,'Setting to Acquire on Channels 1, 2 and 3\n');
    aCH = [int32(1),int32(1),int32(1),int32(0),int32(0),int32(0),int32(0),int32(0),int32(0),int32(0),int32(0),int32(0),int32(0),int32(0),int32(0),int32(0)];
end


% if mptype is not MP150
if mptype ~= 101
    %then it must be the mp35 (102) or mp36 (103)
    if nCh == 3
        aCH = [int32(1),int32(1),int32(1),int32(0)];
    elseif nCh == 2
        aCH = [int32(1),int32(1),int32(2),int32(0)];
    end
end

[retval, aCH] = calllib(libname, 'setAcqChannels',aCH);

if ~strcmp(retval,'MPSUCCESS')
    fprintf(1,'Failed to Set Acq Channels.\n');
    calllib(libname, 'disconnectMPDev');
    return
end

fprintf(1,'Channels Set\n');

%% start to acquire
fprintf(1,'Start Acquisition Daemon\n');

retval = calllib(libname, 'startMPAcqDaemon');

if ~strcmp(retval,'MPSUCCESS')
    fprintf(1,'Failed to Start Acquisition Daemon.\n');
    calllib(libname, 'disconnectMPDev');
    return
end

fprintf(1,'Start Acquisition for %f seconds. \n', DURATION);

retval = calllib(libname, 'startAcquisition');

if ~strcmp(retval,'MPSUCCESS')
    fprintf(1,'Failed to Start Acquisition.\n');
    calllib(libname, 'disconnectMPDev');
    return
end

%% Download and Plot samples in realtime
fprintf(1,'Download and Plot samples for %f seconds in Real-Time\n', DURATION);
numRead = 0;
numValuesToRead = 200*nCh; %collect 1 second worth of data points per iteration
remaining = DURATION*200*nCh; % collect samples with 200 Hz per Channel for #duration
tbuff(1:numValuesToRead) = double(0); %initialize the correct amount of data
bval = 0;
offset = 1;

% create new figure
figure;

%% === start cue experiment ===
if cueOn == 1
    %% initialize figure
    addpath('disp_cue');
    FigHandle = figure;
    set(FigHandle, 'OuterPosition', [1680, 0, 1680, 1050]);
    drawnow
    
    
    fprintf(1,'Starting cue experiment...\n');
    fprintf(1,'Total duration: %d \n', DURATION);
    fprintf(1,'Period length: %d \n', T_PERIOD);
    %% create timer for experiment
    tmr_delete_all_timers = timer('ExecutionMode', 'singleShot', ...
        'StartDelay', DURATION, ...
        'TimerFcn', {@deleteAllTimers});
    start(tmr_delete_all_timers);
    
    %% create timer object for blank
    tmr_blank = timer('ExecutionMode', 'FixedRate', ...
        'Period', T_PERIOD, ...
        'TimerFcn', {@draw_blank});
    start(tmr_blank);
    
    %% create timer object for cross
    tmr_cross = timer('ExecutionMode', 'FixedRate', ...
        'StartDelay', T_BLANK, ...
        'Period', T_PERIOD, ...
        'TimerFcn', {@draw_cross});
    start(tmr_cross);
    
    %% create timer object for right cue
    tmr_right = timer('ExecutionMode', 'FixedRate', ...
        'StartDelay', T_CUE_ON, ...
        'Period', 3*T_PERIOD, ...
        'TimerFcn', {@draw_rightarrow});
    start(tmr_right);
    
    %% create timer object for cross after cue
    tmr_cross_after_cue = timer('ExecutionMode', 'FixedRate', ...
        'StartDelay', T_CUE_ON + T_CUE, ...
        'Period', T_PERIOD, ...
        'TimerFcn', {@draw_cross});
    start(tmr_cross_after_cue);
    
    %% create timer object for left cue
    tmr_left = timer('ExecutionMode', 'FixedRate', ...
        'StartDelay', T_CUE_ON + T_PERIOD, ...
        'Period', 3*T_PERIOD, ...
        'TimerFcn', {@draw_leftarrow});
    start(tmr_left);
    
    %% create timer object for up cue // or nothing cue
    tmr_up = timer('ExecutionMode', 'FixedRate', ...
        'StartDelay', T_CUE_ON + 2*T_PERIOD, ...
        'Period', 3*T_PERIOD, ...
        'TimerFcn', {@draw_uparrow});
    start(tmr_up);
end

%% loop until there still some data to acquire
tic
while(remaining > 0)
    if numValuesToRead > remaining
        numValuesToRead = remaining;
    end
    
    [retval, tbuff, numRead]  = calllib(libname, 'receiveMPData',tbuff, numValuesToRead, numRead);
    
    if ~strcmp(retval,'MPSUCCESS')
        fprintf(1,'Failed to receive MP data.\n');
        calllib(libname, 'disconnectMPDev');
        return
    else
        buff(offset:offset+double(numRead(1))-1) = tbuff(1:double(numRead(1)));
        
        %% Process
        len = length(buff);
        ch1data = buff(1:nCh:len);
        ch2data = buff(2:nCh:len);
        if nCh == 3
            ch3data = buff(3:nCh:len);
        end
        X(1:len) = (1:len);
        %% plot graph
        if cueOn == 0   %�plot graph if cue is not on
            pause(1/100);
            subplot(3,1,1);
            plot(X(1:length(ch1data)),ch1data,'g-');
            title('Data Plot of for Channel 1 and 2');
            subplot(3,1,2);
            plot(X(1:length(ch2data)),ch2data,'b-');
            subplot(3,1,3);
            plot(X(1:length(ch3data)),ch3data,'r-');
            xlabel('Nth Sample');
        else
            drawnow
        end
    end
    offset = offset + double(numValuesToRead);
    remaining = remaining-double(numValuesToRead);
end
t_dur = toc;
fprintf(1, 'Acquired data for %f seconds.\n', t_dur);

%% save data
if nCh == 2
    ch1 = ch1data;
    ch2 = ch2data;
    X = [ch1', ch2'];   % merge data in Matrix X for return value
end
if nCh == 3
    ch1 = ch1data;
    ch2 = ch2data;
    ch3 = ch3data;
    X = [ch1', ch2', ch3'];   % merge data in Matrix X for return value
end

%% stop acquisition
fprintf(1,'Stop Acquisition\n');

retval = calllib(libname, 'stopAcquisition');
if ~strcmp(retval,'MPSUCCESS')
    fprintf(1,'Failed to Stop\n');
    calllib(libname, 'disconnectMPDev');
    return
end

%% disconnect
fprintf(1,'Disconnecting...\n')
retval = calllib(libname, 'disconnectMPDev');
end