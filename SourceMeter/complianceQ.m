function [ inCompliance ] = complianceQ( sm_obj )
%complianceQ( sm_obj ) checks if the sourceMeter is in compliance
%   sm_obj = source meter object
%   returns 1 if in compliance; else 0

inCompliance = query(sm_obj,':calculate2:limit:fail?');

end

