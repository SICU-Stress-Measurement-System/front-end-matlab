%% Setup
a = arduino('/dev/cu.usbmodem1421','Uno');

%% Loop
close all;    clc
clearvars -except a

i = 0;  tic;  % initialize index and time

while true
    % Update signal
    i = i + 1;
    t(i) = toc;
    v(i) = readVoltage(a,0);
    
    % Plot signal
    plot(t, v)
    xlim([t(i)-10 t(i)]);
    hold on
    drawnow
end
