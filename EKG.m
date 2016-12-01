a = arduino('/dev/cu.usbmodem1421','Uno');
%%
clc
close all
clearvars -except a
i = 0;
tic;

while true
    i = i + 1;
    time(i) = toc;

    volt(i) = readVoltage(a,0);
   
    figure(2)
    
    plot(time,volt)
    
    hold on
    
    xlim([time(i)-20 time(i)]);
    
    drawnow
   
end





