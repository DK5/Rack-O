clear
limits = 2:14;

for i = limits
    for j=limits
        x = [i i+1 i+1 i] + 0.5;
        y = [j j j+1 j+1] + 0.5;
        patch(x,y,i)
        axis([min(limits) max(limits) min(limits) max(limits)] + 0.5)
        axis square
    end
end