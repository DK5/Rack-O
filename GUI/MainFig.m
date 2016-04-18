function varargout = MainFig(varargin) 
% MainFig M-file for MainFig.fig
%      MainFig, by itself, creates a new MainFig or raises the existing
%      singleton*.
%
%      H = MainFig returns the handle to a new MainFig or the handle to
%      the existing singleton*.
%
%      MainFig('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MainFig.M with the given input arguments.
%
%      MainFig('Property','Value',...) creates a new MainFig or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MainFig_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MainFig_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MainFig

% Last Modified by GUIDE v2.5 18-Mar-2016 11:20:41

% Begin initialization code - DO NOT EDIT
%clear all
%close all   %CLEANUP
clc
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MainFig_OpeningFcn, ...
                   'gui_OutputFcn',  @MainFig_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before MainFig is made visible.
function MainFig_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MainFig (see VARARGIN)

% Choose default command line output for MainFig
handles.output = hObject;

%CONNECT TO devices
try 
    PPMSObj= GPcon(15,0);
    setappdata(0,'PPMS',PPMSObj);
catch
    errordlg('Failed to initialize connection to PPMS!','Error 0x007');
end
try
    switcher_obj = GPcon(16,0);
    setappdata(0,'switcher_obj',switcher_obj);
catch
    errordlg('Failed to initialize connection to switcher!','Error 0x009');
end
try
    sm_obj=GPcon(10,0);
    setappdata(0,'sm_obj',sm_obj);
catch
    errordlg('Failed to initialize connection to SourceMeter!','Error 0x010');
end
%timer
mainTimer = timer;
mainTimer.Name = 'Main GUI Timer';
mainTimer.ExecutionMode = 'fixedRate';
mainTimer.Period = 0.5;
mainTimer.TimerFcn = 'live_data = timer_function(PPMSObj);';
mainTimer.StartDelay = 1.5;
start(mainTimer);

% Create cell array to store all commands
% every action on CommandList will be also on this cell array
% the format will be {'Command1;','Command2;'}
% to join all to one string - strjoin(CommandCell,'\n');
cellCommands = cell(1);
setappdata(0,'cellCommands',cellCommands);
% kCommands = cell(1);
% pCommands = cell(1);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MainFig wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MainFig_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Adds command line to the cell array
function add_command_str(str,index)
% str - command string
% index - index of command line
% activity - 'p'/'k'
cellCommands = getappdata(0,'cellCommands');
if isempty(cellCommands{1})
    % no commands yet
    cellCommands{1} = str;
elseif size(cellCommands,1) < index
    % put in the end of the array
    cellCommands{end+1,1} = str;
else
    cellCommands = [cellCommands(1:index-1);{str};cellCommands(index:end)];
end
setappdata(0,'cellCommands',cellCommands);
% % if activity == 'p'
% %     % write to pCommands
% % elseif activity = 'k'
% %     % write to kCommands
% % else
% %     % error
% % end

% --- Adds command line to the cell array
function delete_command_str(index)
% str - command string
% index - index of command line
% activity - 'p'/'k'
cellCommands = getappdata(0,'cellCommands');
cellCommands(index) = [];
setappdata(0,'cellCommands',cellCommands);
% % if activity == 'p'
% %     % write to pCommands
% % elseif activity = 'k'
% %     % write to kCommands
% % else
% %     % error
% % end

% --- Executes on button press in Set_Field.
function Set_Field_Callback(hObject, eventdata, handles)
% hObject    handle to Set_Field (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
approach = get(handles.set_mf_popup,'Value')-1;
%scan field step size check
StopField = str2num(get(handles.txt_Stop_field, 'String'));
rate = str2num(get(handles.mf_rate_edit, 'String'));
if(rate<10)
    errordlg('Rate must be bigger than 10!','Error 0x001')
    set(handles.mf_rate_edit,'String',10);
    return
elseif(rate>187)
    errordlg('Rate must be smaller that 187!','Error 0x005')
    set(handles.mf_rate_edit,'String',187);
    return
end
FIELD(handles.PPMSObj,StopField,rate,approach,mode);

function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function txt_destination_field_Callback(hObject, eventdata, handles)
% hObject    handle to txt_destination_field (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_destination_field as text
%        str2double(get(hObject,'String')) returns contents of txt_destination_field as a double


% --- Executes during object creation, after setting all properties.
function txt_destination_field_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_destination_field (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Set_scan_field.
function Set_scan_field_Callback(hObject, eventdata, handles)
% hObject    handle to Set_scan_field (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Start_Field = get(handles.txt_Start_field, 'String');
Stop_Field = get(handles.txt_Stop_field, 'String');
Num_of_steps = get(handles.mf_rate_edit, 'String');

index_selected = get(handles.CommandList, 'Value');
add_item_to_list_box(handles.CommandList, 'End' , index_selected);
add_item_to_list_box(handles.CommandList,...
    ['Scan field from ',Start_Field, ' [Oe] to ', Stop_Field, ' [Oe] in ', Num_of_steps, ' steps'], index_selected);


function txt_Start_field_Callback(hObject, eventdata, handles)
% hObject    handle to txt_Start_field (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_Start_field as text
%        str2double(get(hObject,'String')) returns contents of txt_Start_field as a double


% --- Executes during object creation, after setting all properties.
function txt_Start_field_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_Start_field (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txt_Stop_field_Callback(hObject, eventdata, handles)
% hObject    handle to txt_Stop_field (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_Stop_field as text
%        str2double(get(hObject,'String')) returns contents of txt_Stop_field as a double


% --- Executes during object creation, after setting all properties.
function txt_Stop_field_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_Stop_field (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function mf_rate_edit_Callback(hObject, eventdata, handles)
% hObject    handle to mf_rate_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mf_rate_edit as text
%        str2double(get(hObject,'String')) returns contents of mf_rate_edit as a double


% --- Executes during object creation, after setting all properties.
function mf_rate_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mf_rate_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Set_take_picture.
function Set_take_picture_Callback(hObject, eventdata, handles)
% hObject    handle to Set_take_picture (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%index_selected = get(handles.CommandList, 'Value')
%add_item_to_list_box(handles.CommandList, 'moty',index_selected);

ax_old = gca;
f_new = figure;
ax_new = copyobj(ax_old,f_new);
set(ax_new,'Position','default')
print(f_new,'AxesOnly','-dpng')
close %'f_new'


function h = add_item_to_list_box_end(h, newitem)
% ADDITEMTOLISTBOX - add a new items to the listbox
% H = ADDITEMTOLISTBOX(H, STRING)
% H listbox handle
% STRING a new item to display

    oldstring = get(h, 'string');
    if isempty(oldstring)
        newstring = newitem;
     elseif ~iscell(oldstring)
         newstring = {newitem oldstring};
    else
        newstring = {newitem oldstring{:}};
    end
    set(h, 'string', newstring);

function h = add_item_to_list_box(h, newitem, index)
% ADDITEMTOLISTBOX - add a new items to the listbox
% H = ADDITEMTOLISTBOX(H, STRING)
% H listbox handle
% STRING a new item to display

    oldstring = get(h, 'string'); % Get the cell array from the listbox. 
    
%     space = 0;
%     for i=1:(index-1) %% Move right the text according to the loops
%         item_selected = oldstring{i};
%         L = length(item_selected);
%         if L>(4+space)
%            if strcmp(item_selected((1+space):(4+space)), 'Scan')
%              space = space +3;
%            end
%         elseif L==(3+space)
%            if strcmp(item_selected((1+space):(3+space)), 'End')
%              space = space -3;
%            end
%         end
%    end
%     
%     for j=1:space
%         newitem = [' ', newitem];
%     end
     
    if isempty(oldstring)
        newstring = {newitem};
%     elseif ~iscell(oldstring)
%          newstring = {oldstring newitem};
    elseif size(oldstring,1) == 1
        add_item_to_list_box_end(h,newitem);
        return;
    else
        % Create the new cell array for the list box
        newstring = {oldstring{1:(index-1)},newitem,oldstring{index:end}};
    end
    % Set the new cell array to the list box
    set(h, 'string', newstring);

function h = del_item_from_list_box(h, index)
% del_item_from_list_box - removes items to the listbox
% H = del_item_from_list_box(H, index)
% H listbox handle
% index - index to remove 
% STRING a new item to display

    oldstring = get(h,'string');   % listbox string cell array
    if strcmp(oldstring{index},'End')
        errordlg('Cannot delete End statement!','Error 0x004');
        return
    elseif strcmp(oldstring{index},'End Sequence')
        errordlg('Cannot delete End Sequence statement!','Error 0x005');
        return
    end
    
    L = length(oldstring);
    
    if isempty(oldstring)
    elseif index==L 
    else
        newstring = {oldstring{1:(index-1)} oldstring{index+1:end}};
        set(h,'string',newstring);
    end
        
% --- Executes on selection change in CommandList.
function CommandList_Callback(hObject, eventdata, handles)
% hObject    handle to CommandList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns CommandList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from CommandList


% --- Executes during object creation, after setting all properties.
function CommandList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CommandList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

set(hObject, 'String', {'End sequence'});
set(hObject, 'UserData',cell(1));


% --- Executes on button press in btnPause.
function btnPause_Callback(hObject, eventdata, handles)
% hObject    handle to btnPause (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Waiting_time = get(handles.txt_waiting_time, 'String');
index_selected = get(handles.CommandList, 'Value');
add_item_to_list_box(handles.CommandList, ['Pause ',Waiting_time, ' [sec]' ], index_selected);
add_command_str(['pause(',Waiting_time,');'],index_selected);


function txt_waiting_time_Callback(hObject, eventdata, handles)
% hObject    handle to txt_waiting_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_waiting_time as text
%        str2double(get(hObject,'String')) returns contents of txt_waiting_time as a double


% --- Executes during object creation, after setting all properties.
function txt_waiting_time_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_waiting_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btnDeleteLine.
function btnDeleteLine_Callback(hObject, eventdata, handles)
% hObject    handle to btnDeleteLine (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
index_selected = get(handles.CommandList, 'Value');
del_item_from_list_box(handles.CommandList,index_selected);
delete_command_str(index_selected);

function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double

% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btnRemark.
function btnRemark_Callback(hObject, eventdata, handles)
% hObject    handle to btnRemark (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Remark = get(handles.txt_remark, 'String');         % get string
index_selected = get(handles.CommandList, 'Value'); % get index selcted in listbox
% add remark in the selected index
add_item_to_list_box(handles.CommandList, ['%%% ', Remark, ' %%%' ], index_selected);
set(handles.txt_remark,'String','');    % empty Edit Text
add_command_str(['% ',Remark],index_selected);


function txt_remark_Callback(hObject, eventdata, handles)
% hObject    handle to txt_remark (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_remark as text
%        str2double(get(hObject,'String')) returns contents of txt_remark as a double
currChar = get(handles.figure1,'CurrentCharacter');
if isequal(currChar,char(13)) %char(13) == enter key
   %call the pushbutton callback
   btnRemark_Callback(hObject, eventdata, handles);
end


% --- Executes during object creation, after setting all properties.
function txt_remark_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_remark (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Reset_button.
function Reset_button_Callback(hObject, eventdata, handles)
% hObject    handle to Reset_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.CommandList,'Value',1);
set(handles.CommandList,'String','End sequence');
setappdata(0,'cellCommands',cell(1));

function initialize_gui(hObject, handles, isreset)
% function used to reset all properies of gui

set(handles.txt_Stop_field,'String','100');  %Reset all H fields
set(handles.mf_rate_edit,'String','10');

set(handles.target_temp_edit,'String', '290');
set(handles.temp_rate_edit, 'String','12');      %Reset TEMP fields

set(handles.txt_remark,'String','');   %Reset REMARK Field

set(handles.txt_waiting_time,'String','1');    %Reset WAIT TIME field

set(handles.CommandList, 'String', {'End sequence'});  %Reset LISTBOX

set(handles.file_name_edit,'String', 'Enter File name'); %Reset filename field

set(handles.mnuXaxis,'Value',1);
set(handles.set_mf_popup,'Value',1);
set(handles.temprature_approach_popup,'Value',1);       %Reset popups
set(handles.chamber_mode_popup,'Value',1);
set(handles.mf_magnet_mode_popup,'Vaule',1);

cla(handles.axes1);                                   %Reset Graph

set(handles.H_text_status,'String', '0');
set(handles.temp_text_status,'String', '---');        %Reset Live Data feed
set(handles.helium_level_text_status,'String', '---');
set(handles.pressure_text_status,'String', '---');


% Update handles structure
guidata(handles.figure1, handles);


% --- Executes during object creation, after setting all properties.
function uipanel10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uipanel10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in write_to_file_button.
function write_to_file_button_Callback(hObject, eventdata, handles)
% hObject    handle to write_to_file_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

contents = getappdata(0,'cellCommands');
FileName = get(handles.file_name_edit,'String');  %get the desired filename

if strcmp(FileName,'Enter File name')    % make sure the user has entered a filename
     errordlg('Please Enter a File Name!','Error 0x003');  % user didnt
    return
end
FID = fopen([FileName,'.m'],'w');   
formatSpec = '%s\r\n';
[nrows,~] = size(contents); % number of commands 
for row = 1:nrows
    if iscell(contents{row})
        contents2 = contents{row};
        for row2 = 1:size(contents2,1)
            fprintf(FID,formatSpec,contents2{row2});   %write list in file - REWRITES EXISTING
        end
    else
        fprintf(FID,formatSpec,contents{row});   %write list in file - REWRITES EXISTING
        %to change, change w in fopen to a
    end
end

fclose(FID);
% type commands.m   %show the file
msgbox('File Saved.','Attention','Help');


% --- Executes on button press in execute_code_button.
function execute_code_button_Callback(hObject, eventdata, handles)
% Executes CURRENT code without file selection
% hObject    handle to execute_code_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


contents = get(handles.CommandList,'String');
setappdata(0,'listbox_contents',contents);
setappdata(0,'Button','Execute'); %let dialog know what button is calling it
varargout = load_file_dialog(figure(load_file_dialog)); %calls verification dialog
%excecution function goes here



% --- Executes during object creation, after setting all properties.
function execute_code_button_CreateFcn(hObject, eventdata, handles)
% hObject    handle to execute_code_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on selection change in mnuXaxis.
function mnuXaxis_Callback(hObject, eventdata, handles)
% hObject    handle to mnuXaxis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns mnuXaxis contents as cell array
%        contents{get(hObject,'Value')} returns selected item from mnuXaxis
contents = cellstr(get(hObject,'String'));
selected_item=contents{get(hObject,'Value')};
switch selected_item
    
    case 'sinc' 

[X,Y] = meshgrid(-8:.5:8);
R = sqrt(X.^2 + Y.^2) + eps;
Z = sin(R)./R;
mesh(Z)
axis auto
xlabel('X'); ylabel('Y'); zlabel('Z');

    case 'heart' 
            t = linspace(-pi,pi, 350);
 X = t .* sin( pi * sin(t)./t);
 Y = -abs(t) .* cos( pi * sin(t)./t);
 plot(X,Y);
 fill(X, Y, 'r');
end        
% --- Executes during object creation, after setting all properties.
function mnuXaxis_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mnuXaxis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in set_mf_popup.
function set_mf_popup_Callback(hObject, eventdata, handles)
% hObject    handle to set_mf_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns set_mf_popup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from set_mf_popup


% --- Executes during object creation, after setting all properties.
function set_mf_popup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to set_mf_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function file_name_edit_Callback(hObject, eventdata, handles)
% hObject    handle to file_name_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of file_name_edit as text
%        str2double(get(hObject,'String')) returns contents of file_name_edit as a double


% --- Executes during object creation, after setting all properties.
function file_name_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to file_name_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function uipushtool2_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%saveas(hObject,'pic.jpg');

fig = gcf;
set(fig,'PaperPositionMode','auto');
print('Full UI Screenpic','-dpng','-r0');

% --------------------------------------------------------------------
function uipushtool1_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in choose_file_btn.
function choose_file_btn_Callback(hObject, eventdata, handles)
% hObject    handle to choose_file_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName] = uigetfile('*.m','Select the MATLAB file containing ppMS commands');
if FileName==0
    errordlg('Error Reading File','Error 0x002');
    return
end
FID = fopen(FileName,'a');  %get file id
setappdata(0,'FileName',FileName);
setappdata(0,'Button','Choose'); %let dialog know what button is calling it
varargout = load_file_dialog(figure(load_file_dialog));   %open verification load_file_dialog


% --- Executes on selection change in chamber_mode_popup.
function chamber_mode_popup_Callback(hObject, eventdata, handles)
% hObject    handle to chamber_mode_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns chamber_mode_popup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from chamber_mode_popup

%WHEN TIME'S COME: ADD THESE LINES:

action=contents{get(hObject,'Value')}; %id of selceted action
CHAMBER(PPMSObj,action-1);


% --- Executes during object creation, after setting all properties.
function chamber_mode_popup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to chamber_mode_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in temprature_approach_popup.
function temprature_approach_popup_Callback(hObject, eventdata, handles)
% hObject    handle to temprature_approach_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns temprature_approach_popup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from temprature_approach_popup


% --- Executes during object creation, after setting all properties.
function temprature_approach_popup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to temprature_approach_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function target_temp_edit_Callback(hObject, eventdata, handles)
% hObject    handle to target_temp_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of target_temp_edit as text
%        str2double(get(hObject,'String')) returns contents of target_temp_edit as a double


% --- Executes during object creation, after setting all properties.
function target_temp_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to target_temp_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function temp_rate_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to temp_rate_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in set_Temp_btn.
function set_Temp_btn_Callback(hObject, eventdata, handles)
% hObject    handle to set_Temp_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Destination_temp = get(handles.target_temp_edit, 'String');
rate=str2num(get(handles.temp_rate_edit, 'String'));
approach = get(handles.temprature_approach_popup,'Value')-1;
%rate size check 
 if(rate<=0.0)
    errordlg('Rate must be bigger than 0!','Error 0x006')
    set(handles.mf_rate_edit,'String',0);
    return
elseif(rate>12)
    errordlg('Rate must be smaller that 12!','Error 0x007')
    set(handles.mf_rate_edit,'String',12);
    return
 end
TEMP(handles.PPMSObj,Destination_temp,rate,approach);


% --- Executes on selection change in mf_magnet_mode_popup.
function mf_magnet_mode_popup_Callback(hObject, eventdata, handles)
% hObject    handle to mf_magnet_mode_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns mf_magnet_mode_popup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from mf_magnet_mode_popup


% --- Executes during object creation, after setting all properties.
function mf_magnet_mode_popup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mf_magnet_mode_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function [output] = timer_function(PPMSObj)
%Function that contains all Live Data functions for pulling information
%about the ppms.
% Function will return a structure with 6 fields:
% output.Pressure - will contain the current pressure in the chamber
% output.TempQ - will contain QUERY INFORMATION (set, rate and approach) regarding the temprature
% output.Temp - will contain current temprature via ReadPPMSData
% output.FieldQ - will contain QUERY INFORMATION (set, rate, approach and MagnetMode) regarding the magnetic field
% output.Field - will contain current magnetic field via ReadPPMSData
% output.ChamberQ - will contain QUERY information about current chamber valving status

%Queries
output.TempQ=TempQ(PPMSObj);
output.FieldQ=FieldQ(PPMSObj);
output.ChamberQ=ChamberQ(PPMSObj);
%Data
output.Pressure=ReadPPMSData(PPMSObj,19);
output.Temp=ReadPPMSData(PPMSObj,1);
output.Field=ReadPPMSData(PPMSObj,2);
%output.Helium=also get helium level
%Done readind data, now printing
%Magnetic field
set(handles.mf_target_status,'String', num2str(output.FieldQ{1}));
set(handles.mf_rate_status,'String', num2str(output.FieldQ{2}));
set(handles.mf_approach_status,'String', output.FieldQ{3});
set(handles.mf_magnet_mode_status,'String', output.FieldQ{4});
set(handles.H_text_status,'String', num2str(output.Field));
%Temp
set(handles.temp_text_status,'String', num2str(output.Temp));
set(handles.temp_target_status,'String', num2str(output.TempQ{1}));
set(handles.temp_rate_status,'String', num2str(output.TempQ{2}));
set(handles.temp_approach_status,'String', output.TempQ{1});
%Pressure
set(handles.pressure_text_status,'String', num2str(output.Pressure));
%Chamber Status
set(handles.chamber_mode_status,'String', output.ChamberQ);
%Helium
%set(handles.helium_level_status,'String', num2str(output.Helium));
guidata(hObject, handles);  %update data
%se tu


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
selection = questdlg('Are you sure you want to quit?',...
      'Close Request Function',...
      'Yes','No','Yes'); 
   switch selection, 
      case 'Yes',
          try
             fclose(PPMSObj);
          catch
             errordlg('Failed to terminate connection to PPMS!','Error 0x008'); 
          end
          try
             fclose(switcher_obj);
          catch
             errordlg('Failed to terminate connection to Switcher!','Error 0x011'); 
          end
          try
             fclose(sm_obj);
          catch
             errordlg('Failed to terminate connection to ScourceMeter!','Error 0x012'); 
          end
          delete(hObject);
      case 'No'
      return 
   end


% --- Executes on button press in channel_matrix_btn.
function channel_matrix_btn_Callback(hObject, eventdata, handles)
% hObject    handle to channel_matrix_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ChannelMatrix(getappdata(0,'switcher_obj'));

% --- Executes on button press in sample_chk_btn.
function sample_chk_btn_Callback(hObject, eventdata, handles)
% hObject    handle to sample_chk_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CheckMatrix(getappdata(0,'switcher_obj'),getappdata(0,'sm_obj')); %should be changed to samplecheck


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in btnUp.
function btnUp_Callback(hObject, eventdata, handles)
% hObject    handle to btnUp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
index = get(handles.CommandList, 'Value');  % get selected index
allstring = get(handles.CommandList, 'string'); % get strings from listbox
len = length(allstring);    % number of lines
if index == 1
%     errordlg('Top line in program cannot be moved up','Error 0x');
elseif index == len
%     errordlg('End of program cannot be moved','Error 0x');
else
    string = allstring{index};  % get selcted string
    del_item_from_list_box(handles.CommandList, index); % delete from index
    add_item_to_list_box(handles.CommandList, string, index-1); % add to upper index
    set(handles.CommandList,'Value',index-1);   % set selection to the moved line
    
    cellCommands = getappdata(0,'cellCommands');    % get commands cell array
    command = cellCommands{index};  % get selcted commannd index
    delete_command_str(index);  % delete from cell array
    add_command_str(command,index-1);   % add to the new index
end



% --- Executes on button press in btnDown.
function btnDown_Callback(hObject, eventdata, handles)
% hObject    handle to btnDown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
index = get(handles.CommandList, 'Value');
allstring = get(handles.CommandList, 'string');
string = allstring{index};
len = length(allstring);
if index == len-1
%     errordlg('Bottom line in program cannot be moved down','Error 0x');
elseif index == len
%     errordlg('End of program cannot be moved','Error 0x');
else
    del_item_from_list_box(handles.CommandList, index);
    add_item_to_list_box(handles.CommandList, string, index+1);
    set(handles.CommandList, 'Value',index+1);
    cellCommands = getappdata(0,'cellCommands');
    command = cellCommands{index};
    delete_command_str(index);
    add_command_str(command,index+1);
end

% --- Executes on selection change in popupmenu9.
function popupmenu9_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu9 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu9


% --- Executes during object creation, after setting all properties.
function popupmenu9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit17_Callback(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit17 as text
%        str2double(get(hObject,'String')) returns contents of edit17 as a double


% --- Executes during object creation, after setting all properties.
function edit17_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton27.
function pushbutton27_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit18_Callback(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit18 as text
%        str2double(get(hObject,'String')) returns contents of edit18 as a double


% --- Executes during object creation, after setting all properties.
function edit18_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton24.
function pushbutton24_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit16_Callback(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit16 as text
%        str2double(get(hObject,'String')) returns contents of edit16 as a double


function edit19_Callback(hObject, eventdata, handles)
% hObject    handle to edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit19 as text
%        str2double(get(hObject,'String')) returns contents of edit19 as a double


% --- Executes during object creation, after setting all properties.
function edit19_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton28.
function pushbutton28_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in mnuYaxis.
function mnuYaxis_Callback(hObject, eventdata, handles)
% hObject    handle to mnuYaxis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns mnuYaxis contents as cell array
%        contents{get(hObject,'Value')} returns selected item from mnuYaxis


% --- Executes during object creation, after setting all properties.
function mnuYaxis_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mnuYaxis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in mnuParameter.
function mnuParameter_Callback(hObject, eventdata, handles)
% hObject    handle to mnuParameter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns mnuParameter contents as cell array
%        contents{get(hObject,'Value')} returns selected item from mnuParameter


% --- Executes during object creation, after setting all properties.
function mnuParameter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mnuParameter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
data = cell(2,1);
data{1} = 'Temprature';
data{2} = 'Field';
set(hObject,'UserData',data);


% --- Executes on button press in btnWait4.
function btnWait4_Callback(hObject, eventdata, handles)
% hObject    handle to btnWait4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
paramflag = get(handles.mnuParameter,'Value');
Options = get(handles.mnuParameter,'UserData');
switch paramflag
    case 1
        functionStr = 'wait4temp(PPMSObj);';
    case 2
        functionStr = 'wait4field(PPMSobj);';
end

commandStr = ['Wait for ',Options{paramflag}];
index = get(handles.CommandList,'Value');
add_item_to_list_box(handles.CommandList,commandStr,index);
% update commands in script
add_command_str(functionStr,index);


% --- Executes on selection change in mnuSM.
function mnuSM_Callback(hObject, eventdata, handles)
% hObject    handle to mnuSM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns mnuSM contents as cell array
%        contents{get(hObject,'Value')} returns selected item from mnuSM


% --- Executes during object creation, after setting all properties.
function mnuSM_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mnuSM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
data = cell(6,3);
% option 1
data{1,1} = 'Apply Current';    % title
data{1,2} = 'mA';               % units
data{1,3} = 'current';          % function name

% option 2
data{2,1} = 'Apply Voltage';
data{2,2} = 'mV';
data{2,3} = 'voltage';

% option 3
data{3,1} = 'Current List';
data{3,2} = 'mA';
data{3,3} = '';

% option 4
data{4,1} = 'Measure Current';
data{4,2} = 'c';

% option 5
data{5,1} = 'Measure Voltage';
data{5,2} = 'v';

% option 5
data{6,1} = 'Measure Resistance';
data{6,2} = 'r';

set(hObject,'UserData',data);

% --- Executes on button press in btnSMadd.
function btnSMadd_Callback(hObject, eventdata, handles)
% hObject    handle to btnSMadd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
funcFlag = get(handles.mnuSM,'Value');
Options = get(handles.mnuSM,'UserData');
index = get(handles.CommandList,'Value');

if funcFlag < 4
    target = get(handles.edtSM,'String');
    commandLine = [Options{funcFlag,1},' of ',target,Options{funcFlag,2}];
    add_item_to_list_box(handles.CommandList,commandLine,index);
    % add command line to file
    functionStr = [Options{funcFlag,3},'(sm_obj, ''on'',',target,');'];
    add_command_str(functionStr,index);
else
    commandLine = Options{funcFlag,1};
    add_item_to_list_box(handles.CommandList,commandLine,index);
    % add command line
    functionStr = ['oneShot(sm_obj, ''',Options{funcFlag,2},''');'];
    add_command_str(functionStr,index);
end



function edtSM_Callback(hObject, eventdata, handles)
% hObject    handle to edtSM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edtSM as text
%        str2double(get(hObject,'String')) returns contents of edtSM as a double


% --- Executes during object creation, after setting all properties.
function edtSM_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edtSM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in mnuVoltSet.
function mnuVoltSet_Callback(hObject, eventdata, handles)
% hObject    handle to mnuVoltSet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns mnuVoltSet contents as cell array
%        contents{get(hObject,'Value')} returns selected item from mnuVoltSet


% --- Executes during object creation, after setting all properties.
function mnuVoltSet_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mnuVoltSet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
data = cell(5,2);
data{1,1} = 'Integration Time';
data{1,2} = 'mA';
data{2,1} = 'Apply Voltage';
data{2,2} = 'mV';
data{3,1} = 'Current List';
data{3,2} = 'mA';
data{4,1} = 'Measure Current';
data{5,1} = 'Measure Voltage';
set(hObject,'UserData',data);

% --- Executes on button press in btnVoltSet.
function btnVoltSet_Callback(hObject, eventdata, handles)
% hObject    handle to btnVoltSet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in mnuVoltMeas.
function mnuVoltMeas_Callback(hObject, eventdata, handles)
% hObject    handle to mnuVoltMeas (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns mnuVoltMeas contents as cell array
%        contents{get(hObject,'Value')} returns selected item from mnuVoltMeas


% --- Executes during object creation, after setting all properties.
function mnuVoltMeas_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mnuVoltMeas (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
data = cell(5,2);
data{1,1} = '1 Shot Voltage';
data{2,1} = 'Continously';
data{3,1} = 'Delta Mode';
set(hObject,'UserData',data);


% --- Executes on button press in btnVoltAdd.
function btnVoltAdd_Callback(hObject, eventdata, handles)
% hObject    handle to btnVoltAdd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
funcFlag = get(handles.mnuSM,'Value');
Options = get(handles.mnuSM,'UserData');
target = get(handles.edtSM,'String');
commandLine = [Options{funcFlag,1},' of ',target,Options{funcFlag,2}];
add_item_to_list_box(commandLine,index);


function edtVoltSet_Callback(hObject, eventdata, handles)
% hObject    handle to edtVoltSet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edtVoltSet as text
%        str2double(get(hObject,'String')) returns contents of edtVoltSet as a double


% --- Executes during object creation, after setting all properties.
function edtVoltSet_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edtVoltSet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edtSetVal_Callback(hObject, eventdata, handles)
% hObject    handle to edtSetVal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edtSetVal as text
%        str2double(get(hObject,'String')) returns contents of edtSetVal as a double


% --- Executes during object creation, after setting all properties.
function edtSetVal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edtSetVal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btnSetParam.
function btnSetParam_Callback(hObject, eventdata, handles)
% hObject    handle to btnSetParam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
paramflag = get(handles.mnuParameter,'Value');
targetStr = get(handles.edtSetVal,'String');
rate = get(handles.edtRate,'String');
switch paramflag
    case 1
        ParameterStr = 'Temprature';
        functionStr = ['TEMP(PPMSObj,',targetStr,',',rate,',10,1);'];
        unitStr = '[�K';
    case 2
        ParameterStr = 'Field';
        functionStr = ['FIELD(PPMSobj,',targetStr,',',rate,',1,1);'];
        unitStr = '[Oe';
end

% update listbox
commandStr = ['Set ',ParameterStr,' to ', targetStr,unitStr,']',...
                ' in rate ',rate,unitStr,'/sec]'];
index = get(handles.CommandList,'Value');
add_item_to_list_box(handles.CommandList,commandStr,index);

% update commands in script
add_command_str(functionStr,index);


function edtRate_Callback(hObject, eventdata, handles)
% hObject    handle to edtRate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edtRate as text
%        str2double(get(hObject,'String')) returns contents of edtRate as a double


% --- Executes during object creation, after setting all properties.
function edtRate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edtRate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edtTargetVal_Callback(hObject, eventdata, handles)
% hObject    handle to edtTargetVal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edtTargetVal as text
%        str2double(get(hObject,'String')) returns contents of edtTargetVal as a double


% --- Executes during object creation, after setting all properties.
function edtTargetVal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edtTargetVal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btnScan.
function btnScan_Callback(hObject, eventdata, handles)
% hObject    handle to btnScan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
initValStr = get(handles.edtInitVal,'String');
targetValStr = get(handles.edtTargetVal,'String');
methodVal = get(handles.edtStep,'String');
paramflag = get(handles.mnuParameter,'Value');
Options = get(handles.mnuParameter,'UserData');
methodFlag = get(handles.rdnSteps,'Value');
switch paramflag
    case 1
        ParameterStr = 'Temp';
        functionStr = 'TEMP(PPMSObj,Temp(j),10,1);';
        indStr = 'k';
        unitStr = '[�K]';
    case 2
        ParameterStr = 'H';
        functionStr = 'FIELD(PPMSobj,H(j),10,1,1);';
        indStr = 'j';
        unitStr = '[Oe]';
end

if methodFlag
    methodStr = 'steps';
    defStr = [ParameterStr,' = ',initValStr,':',methodVal,':',targetValStr,';'];
else
    methodStr = 'spacing';
    defStr = [ParameterStr,' = ','linspace(',initValStr,',',targetValStr,',',methodVal,');'];
end

% update listbox
commandStr = ['Scan ',Options{paramflag},' from ',initValStr,unitStr,' to ',...
    targetValStr,unitStr,' by ',methodStr,' of ', methodVal,unitStr];
index = get(handles.CommandList,'Value');
add_item_to_list_box(handles.CommandList,commandStr,index);
add_item_to_list_box(handles.CommandList,'end',index+1);

% update commands in script
sendCommand = {defStr;['for ',indStr,'=1:length(',ParameterStr,')'];functionStr};
add_command_str(sendCommand,index);
add_command_str('end',index+1);


function edtStep_Callback(hObject, eventdata, handles)
% hObject    handle to edtStep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edtStep as text
%        str2double(get(hObject,'String')) returns contents of edtStep as a double


% --- Executes during object creation, after setting all properties.
function edtStep_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edtStep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edtInitVal_Callback(hObject, eventdata, handles)
% hObject    handle to edtInitVal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edtInitVal as text
%        str2double(get(hObject,'String')) returns contents of edtInitVal as a double


% --- Executes during object creation, after setting all properties.
function edtInitVal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edtInitVal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in rdoSpace.
function rdoSpace_Callback(hObject, eventdata, handles)
% hObject    handle to rdoSpace (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rdoSpace


% --- Executes on button press in rdnSteps.
function rdnSteps_Callback(hObject, eventdata, handles)
% hObject    handle to rdnSteps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rdnSteps


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over txt_remark.
function txt_remark_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to txt_remark (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)