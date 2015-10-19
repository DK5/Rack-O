limits = 2:14;
ax = get(gca);
label = num2str((limits)','%02d');
fontSize = 14;

set(gca,'XAxisLocation','top');
set(gca,'YDir','reverse');
set(gca,'XTick',(limits)');
set(gca,'YTick',(limits)');
set(gca,'XTickLabel',label);
set(gca,'YTickLabel',label);
set(gca,'FontSize',fontSize);
axis([min(limits) max(limits) min(limits) max(limits)] + 0.5);
axis square;

for i = limits
    for j = (i+1):max(limits)
        
        Q = randi(2,1)-1;
        x1 = [i i+1 i+1 i] + 0.5;
        y1 = [j j j+1 j+1] + 0.5;
        x2 = y1;
        y2 = x1;
        
        if ~Q;           
            patch(x1,y1,'green');
            patch(x2,y2,'green');
        else      
            patch(x1,y1,'red');
            patch(x2,y2,'red');
        end
        
        if i == j
            patch(x,y,'white');
        end
        
        pause(1/10);
    end
end
