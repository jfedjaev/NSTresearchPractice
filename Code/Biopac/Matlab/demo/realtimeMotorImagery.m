%%  real time motor imagery application for control of a katana robot
%   Author:         Juri Fedjaev
%   Last modified:  12-05-2017
%   Parameters:
%       numTrials : number of trials to execute
%       robotON : turn on/off robot control

function [retval] = realtimeMotorImagery(numTrials, robotOn)
%% get SVM model file
filename = uigetfile;   
load(filename); % 'SVMModel' is the name of the variable 

%% init robot and get object
addpath('katana')
katana = initKatana;


%%  Parameters for cue experiment
nCh = 3;
cueOn = 1;
T_BLANK  = 2;
T_CUE_ON = 3;
T_CUE    = 2;
T_PERIOD = 8;
DURATION = numTrials * T_PERIOD;




%% ------ initialize & set path and load library --------------------------
mptype = 103;   % 103 for MP36 device (see mpdev.h)
mpmethod = 10;  % communication type 10 for USB
sn = 'auto';    % with 'auto' the first responding MP36 device will be used
%duration = 3;  % recording duration in seconds

libname = 'mpdev';
doth = 'mpdev.h';
dll = ['C:\Program Files (x86)\BIOPAC Systems, Inc\BIOPAC Hardware API 2.2 Education\x64\mpdev.dll'];
dothdir = ['C:\Program Files (x86)\BIOPAC Systems, Inc\BIOPAC Hardware API 2.2 Education\'];

%check if the library is already loaded
if libisloaded(libname)
    calllib(libname, 'disconnectMPDev');
    unloadlibrary(libname);
end

% turn off annoying enum warnings
warning off MATLAB:loadlibrary:enumexists;

% load the biopac library
loadlibrary(dll,strcat(dothdir,doth));
fprintf(1,'\nMPDEV.DLL LOADED!!!\n');
libfunctions(libname, '-full');


%% ------------------------ start Acquisition Daemon ----------------------
% Connect
fprintf(1,'Connecting...\n');

[retval, sn] = calllib(libname,'connectMPDev',mptype,mpmethod,sn);

if ~strcmp(retval,'MPSUCCESS')
    fprintf(1,'Failed to Connect.\n');
    calllib(libname, 'disconnectMPDev');
    return
end
fprintf(1,'Connected\n');

% Configure
fprintf(1,'Setting Sample Rate to 200 Hz\n');
retval = calllib(libname, 'setSampleRate', 5.0);

if ~strcmp(retval,'MPSUCCESS')
    fprintf(1,'Failed to Set Sample Rate.\n');
    calllib(libname, 'disconnectMPDev');
    return
end

fprintf(1,'Sample Rate Set\n');


% set acquisition channels
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

% start to acquire
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

%% ------------------------------------------------------------------

%% Download and Plot samples in realtime
fprintf(1,'Download and Plot samples for %f seconds in Real-Time\n', DURATION);
numRead = 0;
numValuesToRead = 200*nCh; %collect 1 second worth of data points per iteration
remaining = DURATION*200*nCh; % collect samples with 200 Hz per Channel for #duration
tbuff(1:numValuesToRead) = double(0); %initialize the correct amount of data
bval = 0;
offset = 1;




%% stop acquisition && unload library
fprintf(1,'Stop Acquisition\n');

retval = calllib(libname, 'stopAcquisition');
if ~strcmp(retval,'MPSUCCESS')
    fprintf(1,'Failed to Stop\n');
    calllib(libname, 'disconnectMPDev');
    return
end

% disconnect
fprintf(1,'Disconnecting...\n')
retval = calllib(libname, 'disconnectMPDev');

unloadlibrary(libname);


end