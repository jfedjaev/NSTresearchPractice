%% testing cue script for BCI experiment
% set path 
function launchCueExp(DURATION, T_BLANK, T_CUE_ON, T_CUE, T_PERIOD)
addpath('disp_cue'); 
FigHandle = figure;
set(FigHandle, 'OuterPosition', [1680, 0, 1680, 1050]);

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

%% create timer object for up cue
tmr_up = timer('ExecutionMode', 'FixedRate', ...
    'StartDelay', T_CUE_ON + 2*T_PERIOD, ...
    'Period', 3*T_PERIOD, ...
    'TimerFcn', {@draw_uparrow});
start(tmr_up);

function deleteAllTimers(hObj, eventdata)
fprintf(1,'Experiment finished!\nClosing figures and timers...\n')
delete(timerfind)
close all
fprintf(1,'Done.\n')
end

end

%% approach using pause()
% fig = figure;
% pause(2)
% draw_cross
% pause(1)
% draw_rightarrow
% pause(2)
% draw_cross
% pause(1)
% clf

%% old using tic toc & if()
% tic 
% while counter <= 10
%     % draw cross
%     if toc-counter*6-delta < 2 && toc-counter*6+delta > 2
%         draw_cross
%     end
%     
%     % draw arrow
%     if toc-counter*6-delta < 3 && toc-counter*6+delta > 3
%         switch state
%             case 1
%                 draw_rightarrow
%                 state = 2;
%             case 2
%                 draw_leftarrow
%                 state = 3;
%             case 3
%                 draw_uparrow
%                 state = 1;
%         end
%     end
%     
%     % clear figure / blank
%     if toc-counter*6-delta < 5 && toc-counter*6+delta > 5
%        clf 
%        counter = counter + 1;
%     end
%     toc
% end


