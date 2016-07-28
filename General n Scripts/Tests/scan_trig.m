load scan_trig.mat
setupIV(nv_obj,sm_obj);
executeIV(nv_obj, sm_obj,'C',0,15,3);
executeIVspan(nv_obj, sm_obj,'V',0,15,100);
deltaSetup(nv_obj,sm_obj);
deltaExecuteSpan(nv_obj, sm_obj,'C',-1,1);

