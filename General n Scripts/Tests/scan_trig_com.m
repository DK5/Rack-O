load scan_trig_com.mat
executeIVspan(nv_obj, sm_obj,'V',0,15,100);
deltaExecuteSpan(nv_obj, sm_obj,'V',0,15);    % Delta measurement (Voltage): center 0[V] , span  15[V] , 1 samples

