% example of P3 analysis
%
% get help for P3 function by typing 'help p3'
%
% In this example, the subject focused on the characters in the word 'CAT'. Please note
% that Figure 4 and 5 are meaningless, since the script uses signals for all characters 'CAT'
% (if restricted to one of the three characters, these Figures would be meaningful - see description below)
%
% The analysis shows:
%
% 1) A difference between standard and oddball responses (i.e., responses to rows/columns that do or do not contain the desired character)
%    See the two averaged waveforms (at Channel 11/Cz) and their statistical difference (in r2) in Figure 1
%
% 2) The topographical distribution of the P300 potential (measured in r2 between standard and oddball) at 310 ms; Figure 2
%
% 3) The discriminability between standard and oddball as a function of time and channels - Figure 3
%
% 4) The responses to the different columns at Cz (stimuli 1-6) and rows (7-12); Figure 4
%
% 5) Averaged responses for each character in the matrix for channel Cz (as the average between respective row and column response)
%
% (C) Gerwin Schalk 10/02-12/02
% (C) parts Scott Makeig, Arnaud Delorme, EEGlab

[res1ch, res2ch, ressqch, stimdata] = p3('AAS010R01.mat', 240, 11, 650, 1, 310, 'eloc64.txt', '');
