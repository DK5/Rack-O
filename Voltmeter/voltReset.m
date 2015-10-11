function voltReset( volt_obj )
%voltReset( volt_obj ) brings 2182 voltmeter to its defaults

fprintf(volt_obj,':*RST');          % Reset
fprintf(volt_obj,':SYSTem:PRESet');	% Return to SYSTem:PRESet defaults

end

