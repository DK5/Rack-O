% if instrument is V:
% Connects/disconnects the extra Nano-Voltmeter that is connected to C15,C16
% to the instument place as R5,R6.
% That means that after using this function with 'V' and 'ON', legs 5,6 can
% measure Voltage.
% e.g.:     ExtraInstrument(Switch,'V','ON')

% if instrument is I:
% Connects/disconnects the extra current-source that is connected to C1,C2
% to the instument place as R5,R6.
% That means that after using this function with 'I' and 'ON', legs 5,6 can
% be used as current source.
% e.g.:     ExtraInstrument(Switch,'I','ON')

function ExtraInstrument(Switch,instrument,state)
switch lower(instrument)
    case 'i'
        x=1;
        y=2;
    case 'v'
        x=15;
        y=16;
end
switch lower(state)
	case 'on'
        %Opens all channels just in case
        openCH (Switch, 5, 1, 1)
        openCH (Switch, 6, 2, 1)
        openCH (Switch, 5, 15, 1)
        openCH (Switch, 6, 16, 1)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        closeCH (Switch, 5, x, 1)
        closeCH (Switch, 6, y, 1)
	case 'off'
        openCH (Switch, 5, x, 1)
        openCH (Switch, 6, y, 1)
end
end
        
        
        
        
        

