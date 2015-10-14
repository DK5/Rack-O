function [ CheckMatrix ] = SampleCheck(switch_obj,cs_obj)
% This function goes over all the permutation of the sample connections and
% checks for cuts.
% Blue  or 0   = Not checked (yet or at all)
% Green or 0.5 = Checked and works well (short)
% Red   or 1   = Checked and broken (cut)

CheckMatrix=zeros(12);

for i=3:14
    for j=(i+1):14
        switchCurrent (switch_obj, i, j, 1) % Switches between legs i and j <------------- This closes the channels! after measurement it needs to open up!!!
%         sourceFunc( cs_obj , 'c')         % ??? Should apply current
%         [ vals ] = readSM( cs_obj );      % Reads the current
        if vals>0.95*current;               % Checks if current flows
            CheckMatrix(i-2,j-2)=0.5;
            CheckMatrix(j-2,i-2)=0.5;
        else                                % Error of current doesn't flow
            CheckMatrix(i-2,j-2)=1;
            CheckMatrix(j-2,i-2)=1;
        end
        image(64*CheckMatrix);              % Shows was is the situation at the moment
    end
end