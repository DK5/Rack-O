function [ CommandsTab] = cellTab( CommandsCell)
%Tab identation

CommandsTab = strtrim(CommandsCell); % remove all tabs
TABS = zeros(length(CommandsTab),1);
counter = 0;

% counts TAB
for i = 1:length(CommandsTab)
    if iscell(CommandsTab{i,1})
        % it is cell
        CommandsTabCell = CommandsTab{i,1};
        for j = 1:length(CommandsTabCell)
            str = CommandsTabCell{j,1}(1:3);
            switch str
                case {'for','Sca'}
                    TABS(i)=counter;
                    counter = counter+1;
                case 'end'
                    counter = counter-1;
                    TABS(i)=counter;
                otherwise
                    TABS(i)=counter;
            end
            tab = repmat('    ',1,TABS(i));
            CommandsTabCell{j,1} = [tab, CommandsTabCell{j,1}];
        end
        CommandsTab{i,1} = CommandsTabCell;
    else
        % write TAB
        str = CommandsTab{i,1}(1:3);
        switch str
            case {'for','Sca'}
                TABS(i)=counter;
                counter=counter+1;
            case 'end'
                counter=counter-1;
                if counter == -1
                    error('End statement cannot be above loop');
                end
                TABS(i)=counter;
            otherwise
                TABS(i)=counter;
        end
        % applies TAB to cells
        tab = repmat('    ',1,TABS(i));
        CommandsTab{i,1} = [tab, CommandsTab{i,1}];
    end
    
end

end