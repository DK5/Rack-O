function sampleRate( obj1 , rate )
%sampleRate sets the LOck-in sample-rate to 62.5mHz (0) through 512Hz(13)
%or Trigger(14)
%   obj1 is the Lock-in object
%   rate is the rate level (0-14), max frequency = 'MAX'
    if(strcmpi(rate,'max'))
        fprintf(obj1, 'srat 13');
    else
        if(rate<0 || rate>14)
            error('Invalid input');
        end
        fprintf(obj1, ['srat ',num2str(rate)]);
    end
end