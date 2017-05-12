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




%% initialize & set path and load library // WINDOWS ONLY for now
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

%% start Acquisition Daemon 
try
    fprintf(1,'Acquisition Daemon Demo...\n');
    [retval, recording.X] = realTimeAcq(dothdir,libname,mptype, mpmethod, sn, DURATION, T_BLANK, T_CUE_ON, T_CUE, T_PERIOD, nCh, cueOn);

    if ~strcmp(retval,'MPSUCCESS')
        delete(timerfind);
        fprintf(1,'Acquisition Daemon Demo Failed.\n');
        calllib(libname, 'disconnectMPDev')
    end
    
catch
    % disonnect cleanly in case of system error
    calllib(libname, 'disconnectMPDev');
    unloadlibrary(libname);
    % return 'ERROR' and rethrow actual systerm error
    retval = 'ERROR';
    rethrow(lasterror);
end


%% unload library
unloadlibrary(libname);


end