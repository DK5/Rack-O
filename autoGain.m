function autoGain( obj1 )
%autoGain gets a measure from the lock-in and sets the proper sensetivity
%   ampl is the measurement
%   obj1 is the Lock-in object

level = [2e-9,5e-9,10e-9,20e-9,50e-9,100e-9,200e-9,500e-9...
    ,1e-6,2e-6,5e-6,10e-6,20e-6,50e-6,100e-6,200e-6,500e-6...
    ,1e-3,2e-3,5e-3,10e-3,20e-3,50e-3,100e-3,200e-3,500e-3,1];
scale = 0.9*level;

ampl = str2double(query(obj1, 'outp? 4'));  % get data

logic = ampl<scale;     % find scale
[~,ind] = max(logic);   % proper scale index is the first bigger

clevel = str2double(query(obj1, 'sens?'))+1; % read the sensitivity

if clevel<ind   % if not at the proper scale
    fprintf(obj1, ['sens ',num2str(ind-1)]);
    autoGain(obj1); % check scaling again
end

