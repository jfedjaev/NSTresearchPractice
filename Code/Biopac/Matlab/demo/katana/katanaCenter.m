%% This is a script for the Zurich Katana Robot for moving left in the demo
%  Author:  Juri Fedjaev
%  Last modified:   12/05/17
function retval = katanaCenter(katana)
%% Parameters
%   inObj : katana soap object as delivered by initKatana function
%clear, clc, close all

%% need to explicitly specify int32 data type for python interface
min = int32(0);
max = int32(30500); 
ax1 = int32(1);
ax2 = int32(2);
ax3 = int32(3);
ax4 = int32(4);
ax5 = int32(5);
ax6 = int32(6); % axis 6 is the gripper

%% execute center-movement
katana.closeGripper;
katana.moveMotAndWait(ax2, -max/2); % correct; axis 2 needs negativ values
katana.moveMotAndWait(ax3, -0.75*max); % correct; axis 3 needs negativ values   
katana.moveMotAndWait(ax4, max/3);   % correct
katana.moveMotAndWait(ax5, max);
katana.moveMotAndWait(ax1, 0.5*max); % correct: choose values in range of [0.3, 0.6]

%% 
retval = 1;

end


