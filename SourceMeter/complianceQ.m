function [ inCompliance ] = complianceQ( sm_obj, func )
%complianceQ( sm_obj ) checks if the sourceMeter is in compliance
%   sm_obj = source meter object
%   returns 1 if in compliance; else 0

switch lower(func)
    case 'c'
        str = 'CURR';
    case 'v'
        str = 'VOLT';
end

for i=1:10
    inCompliance = str2double(query(sm_obj,[':sense:',str,':protection:tripped?']));
    if inCompliance
        break
    end
end

