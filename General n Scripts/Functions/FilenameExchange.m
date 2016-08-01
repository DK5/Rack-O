Temp=30;   % Temp(k)
Fiel=5000; % Fiel(h)
Filename='Nb_loop_@T=<T>K_@H=<H>.mat';  % Input filename by the user
b=strfind(Filename,'<');            % Finds beginings of variable names
n=strfind(Filename,'>');            % Finds endings of variable names
n=[0 n];                            % makes the for easy for use

newFilename=[];                     % Declare the output, the filename that will be saved
for t=1:length(b)
    newFilename=[newFilename,Filename(n(t)+1:b(t)-1)];  % Adding to the newFilename the 'in between' text (from the begining to < , and from > to < )
    varname=Filename(b(t)+1:n(t+1)-1);                  % Checks the variable name in the brackets <varname>
    switch varname
        case 'T'
            newFilename=[newFilename,num2str(Temp)];
        case 'H'
            newFilename=[newFilename,num2str(Fiel)];
            % More cases need to be added, I don't remember them all. do u?
    end  
end
newFilename=[newFilename,Filename(n(end)+1:end)];

if isempty(strfind(newFilename,'.mat'))==1
    newFilename=[newFilename,'.mat'];
end
newFilename  % you see? it's working!