function [ data ] = deltaSample( cs_obj , volt_obj , samples , models )
%deltaSample( csObj , voltObj , samples , models ) performs delta mode
%sample on spec ified number of models, and returns specified number of
%samples on each model
%   Detailed explanation goes here

setup_deltaMode(cs_obj , volt_obj , samples, 20e-6);
execute_deltaMode(cs_obj);

wait4read(volt_obj);

data = read(volt_obj);

end

