B = 0;
R = 0.95;
G = 0.53;

fig = figure;

CheckMatrix=zeros(12);

x = 3:14;

ax1 = subplot(2,1,1,'Parent',fig);
plot(x,x);

set(ax1,'XAxisLocation','top');
set(ax1,'XLim',[2,14]);
set(ax1,'YLim',[2,14]);
set(ax1,'YDir','reverse');
set(ax1,'XTick',2.5:13.5);
set(ax1,'YTick',2.5:13.5);
set(ax1,'XTickLabel',num2str((3:14)'));
set(ax1,'YTickLabel',num2str((3:14)'));
axis square;

pos = get(gca,'position');
set(gca,'position',[pos(1)-0.1 pos(2)-0.1, pos(3)*2 pos(4)*2]);
pos = get(gca,'position');

for i=3:14
    for j=(i+1):14
%         switchCurrent (switch_obj,'on', i, j)% Switches between legs i and j
%         current( cs_obj,'on',0.01 )
        Q=randi(2,1)-1;
        if ~Q;           
            CheckMatrix(i-2,j-2)=G;
            CheckMatrix(j-2,i-2)=G;
        else                                 % Error of current doesn't flow
            CheckMatrix(i-2,j-2)=R;
            CheckMatrix(j-2,i-2)=R;
        end
        
%         current( cs_obj,'off',0.01 )
%         switchCurrent (switch_obj,'off', i, j)
        
        ax2 = subplot(2,1,2,'Parent',fig);
        image(3:14,3:14,64*CheckMatrix);               % Shows was is the situation at the moment

        set(ax2,'GridLineStyle','-');
        set(ax2,'XGrid','on');
        set(ax2,'YGrid','on');
        set(ax2,'XTick',2.5:13.5);
        set(ax2,'YTick',2.5:13.5);
        set(ax2,'XTickLabel',[]);
        set(ax2,'YTickLabel',[]);
        axis square;
        set(gca,'position',[pos(1) pos(2), pos(3) pos(4)]);
        
        drawnow;
    end

end




