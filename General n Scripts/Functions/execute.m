function execute(obj,commands)
% OneLineCMD=[];
% for k=1:length(commands)
%     OneLineCMD=[OneLineCMD,commands{k},';'];
% end
% fprintf(obj,OneLineCMD);

for k=1:length(commands)
    a=commands{k};
    fprintf(obj,commands{k});
end


