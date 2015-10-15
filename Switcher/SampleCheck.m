function [ CheckMatrix ] = SampleCheck(switch_obj,cs_obj,Vcomp)
% This function goes over all the permutation of the sample connections and
% checks for cuts.
% Blue  or 0   = Not checked (yet or at all)
% Green or 0.5 = Checked and works well (short)
% Red   or 1   = Checked and broken (cut)
terminal( cs_obj, 'rear' )
openAllCH(switch_obj);
CheckMatrix = zeros(12);
compliance( cs_obj , 'v' , Vcomp );

for i = 3:14
    for j = (i+1):14
        switchCurrent (switch_obj,'on', i, j);% Switches between legs i and j
        current( cs_obj,'on',0.01 );         % Apply current
        if cutShort(cs_obj);                 % Checks not in compliance
            CheckMatrix(i-2,j-2) = 0.5;
            CheckMatrix(j-2,i-2) = 0.5;
        else                                 % Error of current doesn't flow
            CheckMatrix(i-2,j-2) = 1;
            CheckMatrix(j-2,i-2) = 1;
        end
        current( cs_obj,'off',0.01 );        % Stops current
        switchCurrent (switch_obj,'off', i, j)
        image(3:14,3:14,64*CheckMatrix);               % Shows was is the situation at the moment
        drawnow
    end
end