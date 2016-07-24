function ZeroV( nv_obj, switch_obj ,delay )
store_nv(nv_obj);
Vcontmeasure(nv_obj)
relative(nv_obj,'OFF')
closeCH(switch_obj, 3, 1, 1);
closeCH(switch_obj, 4, 1, 1);
pause(delay)
% IntegrationTime( nv_obj , delay/100 )
% close all
% V=[];
% diff_counter=0;
% while diff_counter<=5;
%     [ vals ] = read2( nv_obj )
%     V=[V vals];
%     diff_counter=sum(abs(diff(V))*1e9<5)
%     subplot(2,1,1)
%         plot(V*1e9)
%         ylabel(' V [ nV ]')
%     subplot(2,1,2)
%         plot((diff(V))*1e9)
%         ylabel('diff V [ nV ]')
%     pause(delay)
% end
relative(nv_obj,'ON')

openCH(switch_obj, 3, 1, 1);
openCH(switch_obj, 4, 1, 1);
