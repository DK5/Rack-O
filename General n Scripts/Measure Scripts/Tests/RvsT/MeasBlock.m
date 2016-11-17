function [interpData] = MeasBlock(kData,pData,filename)
    %%  Generating raw data
%     kData(isnan(kData(:,1)),:) = [];    % delete all NaN values where there is no time stamp
    klen = size(kData,1);               % get kData rows size

    pData(isnan(pData(:,1)),:) = [];% delete all NaN values where there is no time stamp
    ppms_len = size(pData,1);           % get kData rows size

    rawData = NaN(klen+ppms_len,6);         % generate raw data which will contain ppms & kData
    rawData(1:klen,1) = kData(:,1);         % insert time values of kData
    rawData(1:klen,4:6) = kData(:,2:end);   % insert data values of kData into proper cols
    rawData((klen+1):end,1:3) = pData ;     % insert PPMS data (time&values)

    %{  
        rawData
        ----------------------------------------------------------
        1-time | 2-temp | 3-field | 4-volt1 | 5- volt2 | 6-current
        ----------------------------------------------------------
          ...  |   NaN  |   NaN   | ...         ...         ...
         kData |   NaN  |   NaN   | ...        kData        ...
          ...  |   NaN  |   NaN   | ...         ...         ...
          ...       PPMS_Data     |   NaN   |   NaN    |    NaN
          ...       PPMS_Data     |   NaN   |   NaN    |    NaN
    %}


    %%  Sorting raw data by time
    sortData = sortrows(rawData,1); % sort by time (1st col) and get sorted rows indices
    %%  Interpolating
    interpData = InterpBlock(sortData);
    %%	Write data to the end of the file
    dlmwrite(filename,interpData,'-append','delimiter','\t','newline','pc','precision',7);
    type(filename)
    %%  Reset Workspace
    clearvars k p kData pData
end