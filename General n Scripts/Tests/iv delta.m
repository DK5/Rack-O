load iv delta.mat;
setupIV(nv_obj,sm_obj);    % IV setup

[Idata,Vdata] = executeIVspan(nv_obj, sm_obj,'C',0,1,3);   % IV measurement (Current): center 0[uA] , span  1[uA] , 3 steps
I{end+1*(s==1),s} = Idata;     % IV current
V{end+1*(s==1),s} = Vdata;     % IV voltage

[Id,Vd] = deltaExecuteSpan(nv_obj, sm_obj,'C',0,1,1);    % Delta measurement (Current): center 0[uA] , span  1[uA] , 1 repeats
dI(end+1*(s==1),s) = Id(2);    % span/2 current, differential current  (dI/2)
dV(end+1*(s==1),s) = Vd(2);    % span/2 current, differential voltage  (dV/2)
dR(end+1*(s==1),s) = Vd(2)/Id(2);  % differential resistance

executeIV(nv_obj, sm_obj,'C',-1,1,2);    % IV measurement (Current): start -1[uA] , stop  1[uA] , spacing 2[uA]

