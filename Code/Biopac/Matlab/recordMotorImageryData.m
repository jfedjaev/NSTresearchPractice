%%  Record data from BIOPAC MP36 using a cue experiment for motor imagery movements
%   Author:         Juri Fedjaev
%   Last modified:  06/04/17

function [retval, recording] = recordMotorImageryData(numTrials)
%%  Parameters for cue experiment
T_BLANK  = 2;
T_CUE_ON = 3;
T_CUE    = 2;
T_PERIOD = 8;
DURATION = numTrials * T_PERIOD;

recording.ch1 = double(0); % data set that will be recorded 
recording.ch2 = double(0);

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

%% start Acquisition Daemon Demo
try
    fprintf(1,'Acquisition Daemon Demo...\n');
    [retval, recording.ch1, recording.ch2] = startAcquisitionWithCue(dothdir,libname,mptype, mpmethod, sn, DURATION, T_BLANK, T_CUE_ON, T_CUE, T_PERIOD);

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