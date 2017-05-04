%% This is a script for the Zurich Katana Robot 
%  Author:  Juri Fedjaev
%  Last modified:   04/05/17

clear, clc, close all

%% need to explicitly specify int32 data type for python interface
min = int32(0);
max = int32(30500); 
ax1 = int32(1);
ax2 = int32(2);
ax3 = int32(3);
ax4 = int32(4);
ax5 = int32(5);
ax6 = int32(6); % axis 6 is the gripper

%% initialize SOAP object 
katana = py.KatanaSoap.KatanaSoap();

%% initialize robot arm & calibrate
katana.calibrate();
katana.closeGripper();
katana.fakeCalibration(ax6, min)   % needed to make gripper work
%katana.fakeCalibration(ax2, 0.5*max)    % make axis 2 work in both directions


%% initialize working position
katana.moveMotAndWait(ax1, 0.9*max) % correct
katana.moveMotAndWait(ax2, 0.3*max) % to check
katana.moveMotAndWait(ax3, max/2)

