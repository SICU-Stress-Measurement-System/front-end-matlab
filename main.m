
function main
  %MAIN insert documentation here
  
  eegfilename = input('Enter CSV filename for EEG data: ', 's');

  Fs = 128;      % sampling frequency (Hz)
  interval = 10; % monitoring interval (s)
                 % ... used for plots and for calculating rate of change

  % Patient Baseline Data
  
  
  % Create figure window
  f = figure('units', 'normalized', 'Position', [0 0 1 1], 'Visible', 'off');
  plotWidth = 0.25;
  textWidth = 0.15;
  textHeight = 0.085;
  cardiacTitle = uicontrol('Style', 'text', 'String', 'Cardiac Stress Index:', 'units', 'normalized', 'Position', [0.05 0.9 textWidth*2, textHeight], 'FontSize', 20, 'FontWeight', 'bold');
  cardiacSI = uicontrol('Style', 'text', 'String', 'XX', 'units', 'normalized', 'Position', [0.325 0.9 textWidth*0.5, textHeight], 'FontSize', 20, 'FontWeight', 'bold')
  cognitiveTitle = uicontrol('Style', 'text', 'String', 'Cognitive Stress Index:', 'units', 'normalized', 'Position', [0.6 0.9 textWidth*2 textHeight], 'FontSize', 20, 'FontWeight', 'bold');
  HRplot = axes('Position', [0.05 0.6 plotWidth plotWidth], 'Title', 'Heart Rate vs Time')
  xlabel('Time (s)')
  ylabel('Heart Rate (bpm)')
  
  HRplot = axes('Position', [0.05 0.2 plotWidth plotWidth], 'Title', 'Heart Rate Variability vs Time')
  xlabel('Time (s)')
  ylabel('HRV (s)')
  
  % Read in EEG data for plots
  eegdata = csvread(eegfilename, 13, 2)';
  % Eliminate reference channel data
  eegdata = eegdata(1:14, :);
  datapoints = size(eegdata);
  prefrontal = eegdata(11:14, :);
  time = (1:datapoints(2))*(1/Fs);
  eegPlots1 = axes('Position', [0.6 0.79 plotWidth*1.5 plotWidth*0.3])
  plot(time, prefrontal(1, :))
  hold on
  title('Electrical Activity in Right Prefrontal Region')
  eegPlots2 = axes('Position', [0.6 0.68 plotWidth*1.5 plotWidth*0.3])
  plot(time, prefrontal(2, :))
  eegPlots3 = axes('Position', [0.6 0.57 plotWidth*1.5 plotWidth*0.3])
  plot(time, prefrontal(3, :))
  eegPlots4 = axes('Position', [0.6 0.46 plotWidth*1.5 plotWidth*0.3])
  plot(time, prefrontal(4, :))
  xlabel('Time (s)')
  
  % Sum signals in the prefrontal region
  prefrontalsum = sum(prefrontal);
  % Break up by monitoring interval and compute beta frequency power in each
  % interval
  beta_range = [13 30];
  interval_index = 1;
  for i = 1:interval*Fs:length(prefrontalsum)
    interval_first = i;
    interval_last = i+interval*Fs-1;
    if (interval_last <= length(prefrontalsum))
      interval_data = prefrontalsum(i:i+interval*Fs-1);
    else
      interval_last = length(prefrontalsum);
      interval_data = prefrontalsum(i:end);
    end
    time_intervals(interval_index) = time(interval_last);
    % Compute Average Power in Beta Frequency range (for this interval)
    BfP_intervals(interval_index) = bandpower(interval_data, Fs, beta_range);
    % Compute Average Power across all frequencies (for this interval)
    TfP_intervals(interval_index) = bandpower(interval_data);
    interval_index = interval_index+1;
  end
  
  betaFreqPlot = axes('Position', [0.75 0.15 plotWidth*0.75 plotWidth*0.75])
  xlabel('Time (s)')
  hold on
  plot(time_intervals, BfP_intervals)
  hold on
  title('Beta Frequency Power in Prefrontal Region')
  
  
  %% Compute Static Values
  
  % Compute Beta Frequency Power: Displayed value represents average BfP
  % across the entire time period
  BfPvalue = bandpower(prefrontalsum, Fs, beta_range);
  
  % Rate of change calculations
  BfPRoC_intervals = (BfP_intervals(2:end)-BfP_intervals(1:end-1))/interval;
  BfPRoC_intervals = [0 BfPRoC_intervals];
  % Displayed value represents average Rate of Change across the entire time
  % period
  BfPRoCvalue = mean(BfPRoC_intervals);
  
  % Stress Index Calculations
  cogSI_intervals = (BfP_intervals./TfP_intervals) .* 1.1 .^(BfPRoC_intervals)
  % Displayed value is average stress index
  cogSIvalue = mean(cogSI_intervals);
  
  
  %% Display Static Values
  
  cognitiveSI   = uicontrol('Style', 'text', 'String', num2str(cogSIvalue, 3), 'units', 'normalized', 'Position', [0.88 0.9 textWidth*0.5, textHeight], 'FontSize', 20, 'FontWeight', 'bold')
  BfPlabel      = uicontrol('Style', 'text', 'String', 'Total Beta Frequency Power (W/Hz):', 'units', 'normalized', 'Position', [0.5 0.3 textWidth*0.7, textHeight*0.75])
  BfPdisplay    = uicontrol('Style', 'text', 'String', num2str(BfPvalue, 3), 'units', 'normalized', 'Position', [0.63 0.32 textWidth*0.3, textHeight*0.6], 'FontSize', 18, 'FontWeight', 'bold')
  BfPRoClabel   = uicontrol('Style', 'text', 'String', 'Average Rate of Change of Beta Frequency Power (W/Hz/s):', 'units', 'normalized', 'Position', [0.5 0.175 textWidth*0.75, textHeight])
  BfPRoCdisplay = uicontrol('Style', 'text', 'String', num2str(BfPRoCvalue, 3), 'units', 'normalized', 'Position', [0.63 0.18 textWidth*0.3, textHeight*0.6], 'FontSize', 18, 'FontWeight', 'bold')
  
  HR         = uicontrol('Style', 'text', 'String', ' Average Heart Rate (bpm):', 'units', 'normalized', 'Position', [0.31 0.8 textWidth*0.6, textHeight*0.6])
  HRRoC      = uicontrol('Style', 'text', 'String', 'Average Rate of Change of Heart Rate (bpm^2):', 'units', 'normalized', 'Position', [0.31 0.7 textWidth*0.6, textHeight*0.8])
  PACs       = uicontrol('Style', 'text', 'String', 'Premature Atrial Contractions:', 'units', 'normalized', 'Position', [0.31 0.4 textWidth*0.6, textHeight*0.5])
  PVCs       = uicontrol('Style', 'text', 'String', 'Premature Ventricular Contractions:', 'units', 'normalized', 'Position', [0.31 0.3 textWidth*0.6, textHeight*0.75])
  SDNN       = uicontrol('Style', 'text', 'String', 'Overall Heart Rate Variability:', 'units', 'normalized', 'Position', [0.31 0.2 textWidth*0.6, textHeight*0.6])
  
  HRvalue    = uicontrol('Style', 'text', 'String', 'XX', 'units', 'normalized', 'Position', [0.4 0.8 textWidth*0.5, textHeight*0.6], 'FontSize', 18, 'FontWeight', 'bold')
  HRRoCvalue = uicontrol('Style', 'text', 'String', 'XX', 'units', 'normalized', 'Position', [0.4 0.7 textWidth*0.5, textHeight*0.6], 'FontSize', 18, 'FontWeight', 'bold')
  PACvalue   = uicontrol('Style', 'text', 'String', 'XX', 'units', 'normalized', 'Position', [0.4 0.4 textWidth*0.5, textHeight*0.6], 'FontSize', 18, 'FontWeight', 'bold')
  PVCvalue   = uicontrol('Style', 'text', 'String', 'XX', 'units', 'normalized', 'Position', [0.4 0.3 textWidth*0.5, textHeight*0.6], 'FontSize', 18, 'FontWeight', 'bold')
  SDNNvalue  = uicontrol('Style', 'text', 'String', 'XX', 'units', 'normalized', 'Position', [0.4 0.2 textWidth*0.5, textHeight*0.6], 'FontSize', 18, 'FontWeight', 'bold')
  
  set(f, 'Visible', 'on')
  
end
