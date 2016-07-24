function A=SampleCheckCont(switch_obj,cs_obj)
% This function goes over all the permutation of the sample connections and
% checks for cuts.

A=zeros(14);
% Axis Properties
limits = 3:15;
% label = num2str((limits-1)','%02d');
% fontSize = 14;

% tic
% C=jet(1e6);
% toc

% set(gca,'XAxisLocation','top');
% set(gca,'YDir','reverse');
% set(gca,'XTick',(limits)');
% set(gca,'YTick',(limits)');
% set(gca,'XTickLabel',label);
% set(gca,'YTickLabel',label);
% set(gca,'FontSize',fontSize);
% axis([min(limits) max(limits) min(limits) max(limits)] + 0.5);
% axis square;

currentValue=100;
% Channel Checking
p=0;
t=0;
tic;
for i = limits(1:end-1)
    for j = (i+1):max(limits-1)
        % Apply Current
        switchCurrent (switch_obj,'on', i, j);  % Switches between legs i and j
        current(cs_obj,'on',currentValue);              % Apply current 
        
        % Square Coordinates
        x1 = [i i+1 i+1 i] + 0.5;
        y1 = [j j j+1 j+1] + 0.5;
        x2 = y1;
        y2 = x1;
        
        % Compliance
        [ isShort,res ]=cutShort(cs_obj);
        A(i,j)=res;
        t(p+1)=toc;
        tAVG=mean(diff(t));
        clc
        disp([num2str(round(p/65*100)),' %  ',...
            num2str(round(65*tAVG-t(end))),' sec left      running for ',...
            num2str(round(toc)),' sec ']);
        drawnow
        p=p+1;
%         res=round(abs(res))+1;
%         if res>1e6
%             res=1e6;
%         end
%         colores=C(res,:);
%             patch(x1,y1,colores);
%             patch(x2,y2,colores);
       
%         drawnow
        % Turn off current
        current( cs_obj,'off',currentValue );       
        switchCurrent (switch_obj,'off', i, j);
        
    end
end
% AA=A;
% A(end+1,:)=0;
A(1:2,:)=[];
A(:,1:2)=[];
A=A+A';
imagesc(A)
colorbar
set(gca, 'XTick', [1:12], 'XTickLabel', [3:14],...
         'YTick', [1:12], 'YTickLabel', [3:14]);
     
     