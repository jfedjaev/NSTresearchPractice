%
% This program predicts the first character in session 12, run 01, using a very simple classification method
% This classification method uses only one sample (at 310ms) and one channel (Cz) for classification
% 
% (C) Gerwin Schalk; Dec 2002

fprintf(1, '2nd Wadsworth Dataset for Data Competition:\n');
fprintf(1, 'Data from a P300-Spelling Paradigm\n');
fprintf(1, '-------------------------------------------\n');
fprintf(1, '(C) Gerwin Schalk 2002\n\n');

% load data file
fprintf(1, 'Loading data file for session 12, run 01\n');
load AAS012R01.mat;

samplefreq=240;
triallength=round(600*samplefreq/1000);     % samples in one evoked response
max_stimuluscode=12;
titlechar='ABCDEFGHIJKLMNOPQRSTUVWXYZ123456789-';

classtimems=310;
classtime=round(classtimems*samplefreq/1000);  % time used for classification (310 ms)
classelectrode=11;                             % electrode used for classification (Cz)

% get a list of the samples that divide one character from the other
idx=find(PhaseInSequence == 3);                                % get all samples where PhaseInSequence == 3 (end period after one character)
charsamples=idx(find(PhaseInSequence(idx(1:end-1)+1) == 1));   % get exactly the samples at which the trials end (i.e., the ones where the next value of PhaseInSequence equals 1 (starting period of next character))

% this determines the first and last intensification to be used here
% in this example, this results in evaluation of intensification 1...180 (180 = 15 sequences x 12 stimuli)
starttrial=min(trialnr)+1;                                     % intensification to start is the first intensification
endtrial=max(trialnr(find(samplenr < charsamples(1))));        % the last intensification is the last one for the first character

stimulusdata=zeros(max_stimuluscode, triallength);
stimuluscount=zeros(max_stimuluscode);

% go through all intensifications and calculate classification results after each
fprintf(1, 'Going through all intensifications for the first character\n');
for cur_trial=starttrial:endtrial
 % get the indeces of the samples of the current intensification
 trialidx=find(trialnr == cur_trial);
 % get the data for these samples (i.e., starting at time of stimulation and triallength samples
 trialdata=signal(min(trialidx):min(trialidx)+triallength-1, :);
 cur_stimuluscode=max(StimulusCode(trialidx));
 stimulusdata(cur_stimuluscode, :)=stimulusdata(cur_stimuluscode, :)+trialdata(:, classelectrode)';
 stimuluscount(cur_stimuluscode)=stimuluscount(cur_stimuluscode)+1;
end % session

% calculate average responses for each of the stimuli
for stim=1:max_stimuluscode
 stimulusdata(stim, :)=stimulusdata(stim, :)/stimuluscount(stim);
end

timems=[1:triallength]/samplefreq*1000;
displaymin=min(min(stimulusdata));
displaymax=max(max(stimulusdata));

fprintf(1, 'Plotting results ...\n');
figure(5);
clf;
max_response=-100000000000000000;
% plot averaged responses for each of the 36 grid positions
for x=1:6
 for y=1:6
  h=subplot(6, 6, x+(y-1)*6);
  avgresponse=mean(stimulusdata([x (y-1)+7], :), 1); 
  % determine current response (i.e., current classification result)
  cur_response=avgresponse(classtime);
  % determine highest response
  if (cur_response > max_response)
     max_response=cur_response;
     cur_x=x;
     cur_y=y;
  end
  plot(timems, avgresponse);
  title(titlechar(x+(y-1)*6));
  axis([min(timems) max(timems) displaymin displaymax]);
  %set(h, 'XGrid', 'on');
  set(h, 'XTick', []);
  set(h, 'XTickLabel', []);
  %set(h, 'YGrid', 'on');
  set(h, 'YTick', []);
  set(h, 'YTickLabel', []);
 end
end

% show the character with the highest classification result in the matrix
x=cur_x;
y=cur_y;
h=subplot(6, 6, x+(y-1)*6);
hold on;
avgresponse=mean(stimulusdata([x (y-1)+7], :), 1); 
cur_response=avgresponse(classtime);
plot(classtimems, cur_response, 'ro');
fprintf(1, 'Predicted character is: %c\n', titlechar(x+(y-1)*6));
fprintf(1, '(we make no statement about whether this prediction is correct or not - this is just an example)\n');
fprintf(1, 'DONE !!\n');

