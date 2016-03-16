function [ errstr ] = getError( cs_obj )
%GETERROR returns cs_obj error with de
errstr = query(cs_obj,':system:error?');
end

