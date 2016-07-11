function ReadSMbuffer( cs_obj )
% Reading the buffer of the sourcemeter

data=query(cs_obj,[':TRACe:DATA?'])
vals = str2double(strsplit(data,','));      % Export readings to array
vals(isnan(vals))=[];
fprintf(cs_obj,[':TRACe:CLEar']);
query(cs_obj,[':TRACe:FREE?'])
