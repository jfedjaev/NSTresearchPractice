%% This is a script for the Zurich Katana Robot 
%  Author:  Juri Fedjaev
%  Last modified:   04/05/17

clear, clc, close all

%% initialize SOAP object 
katana = py.KatanaSoap.KatanaSoap();

%% initialize robot arm & calibrate
katana.calibrate();
