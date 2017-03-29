%% This function start the acquisition using the MP36 device
% optional arguments: plot signal in  real time


function retval = acquisition
%% initialize & set path and load library // WINDOWS ONLY for now
mptype = 103;   % 103 for MP36 device (see mpdev.h)
mpmethod = 10;  % communication type 10 for USB
sn = 'auto';    % with 'auto' the first responding MP36 device will be used

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
    retval = startAcquisition(dothdir,libname,mptype, mpmethod, sn);
   
    if ~strcmp(retval,'MPSUCCESS')
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

%%


%% unload library
unloadlibrary(libname);

end


