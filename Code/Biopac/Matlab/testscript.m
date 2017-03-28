%%  Biopac API test script
%   Author: Juri Fedjaev 
%   Date:   27/03/2017
%%

pathToDLL = ['C:\Program Files (x86)\BIOPAC Systems, Inc\BIOPAC Hardware API 2.2 Education\x64\mpdev.dll'];
pathToHeader = ['C:\Program Files (x86)\BIOPAC Systems, Inc\BIOPAC Hardware API 2.2 Education\'];

%% testrun
mpdevdemo(pathToDLL, pathToHeader, 103, 10,'auto')