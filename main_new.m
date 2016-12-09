%% Microcontroller setup

a = arduino('COM5','Leonardo'); %'/dev/cu.usbmodem1421','Uno');


%% Main Section

close all;  clc
clearvars -except a

% Initialize axes objects
eegAx = subplot(2,1,1);  hold on
ekgAx = subplot(2,1,2);  hold on
title(eegAx, 'EEG')
title(ekgAx, 'EKG')
xlabel(ekgAx, 'Time (sec)')
co = get(groot, 'DefaultAxesColorOrder');

% Load LSL library
disp('Loading the library...');
lib = lsl_loadlib();

% Resolve EEG stream
disp('Resolving an EEG stream...');
result = {};
while isempty(result)
    result = lsl_resolve_byprop(lib,'type','EEG');
end

% Open LSL inlet
disp('Opening an inlet...');
inlet = lsl_inlet(result{1});
disp('Now receiving data...');
i = 0;  tic;  % initialize index and time

while true
    % Update signals
    i = i + 1;  t = toc;
    time(i,:) = t;
    eeg (i,:) = inlet.pull_sample();
    ekg (i,:) = readVoltage(a,'A0');
    
    % Plot signals
    plot(eegAx, time, eeg(:,1), 'Color',co(1,:))
    plot(eegAx, time, eeg(:,2), 'Color',co(5,:))
    plot(eegAx, time, eeg(:,3), 'Color',co(6,:))
    plot(eegAx, time, eeg(:,4), 'Color',co(7,:))
    xlim(eegAx, [t-10 t]);
    
    plot(ekgAx, time, ekg,      'Color',co(2,:))
    xlim(ekgAx, [t-10 t]);
    
    drawnow()
end
