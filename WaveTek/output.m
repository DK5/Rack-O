function output( obj1, state )
%output sets the output of the FG
%   state: 'off' | 'on50' | 'on0' or 0 | 1 | 2

if ischar(state)    % cancel case sensetivity
    state = lower(state);
end

switch state
    case {0,'0','off'}
        val = '0';
    case {1,'1','on50'}
        val = '1';
    case {2,'2','on0'}
        val = '2';
    otherwise
        error('Invalid input')
end

try
    fprintf(obj1, ['output ',val]);
catch
    disp('Error');
end

