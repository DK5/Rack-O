% finding quiet frequency

% Connect devices
lk = GPcon(2);  % lock-in
fg = GPcon(25); % function generator

setTrace(lk,1,7,0,0,0); % set trace 1 as Rn = magnitude noise
refSRC(lk,'external');  % set reference source to external
ampl(fg,1);             % set amplitude to 1V
output(fg,'on50');      % set output to 50 ohm
sampleRate(lk,'max');   % set sample rate to max

% data arrays
data = zeros(489,50);

% Scanning frequencies
for FREQ = 25:2:1001
    freq(fg,FREQ);
    execute(fg);
    pause(0.5);
    for k = 1:50
        line = 0.5*(FREQ-25+2);
        data(line,k) = askTrace(lk,1);
        pause(0.001);
    end
end

avg = mean(data,2);          % standard deviation
[minVal, ind] = min(avg); % get minimum std and its index
fbest = 25+2*(ind-1);       % best frequency
