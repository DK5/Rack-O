function varargout = MainFig2(varargin) 
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


% Last Modified by GUIDE v2.5 08-Jun-2016 16:54:03


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

%CLOSE DEVICES before opening them (just in case)
try
    try
        fclose(handles.PPMSObj);
%         PPMSObj = getappdata(0,'PPMSObj');
%         fclose(PPMSObj);
        
    end
%     handles = rmfield(handles, 'PPMSObj');
end
try
    try
        fclose(handles.switcher_obj);
    end
%     handles = rmfield(handles, 'switcher_obj');
end
try
    try
        fclose(handles.sc_obj);
    end
%     handles = rmfield(handles, 'sc_obj');
end
try
    try
        fclose(handles.nV_obj);
    end
%     handles = rmfield(handles, 'nV_obj');
end

%CONNECT TO devices
try 
    handles.PPMSObj= GPcon(15,2);
%     PPMSObj = GPcon(15,0);
%     setappdata(0,'PPMSObj',PPMSObj);
catch
    errordlg('Failed to initialize connection to PPMS!','Error 0x007');
end
try
    handles.switcher_obj = GPcon(5,2);
%     setappdata(0,'handles.switcher_obj',handles.switcher_obj);
catch
    errordlg('Failed to initialize connection to switcher!','Error 0x009');
end
try
    handles.sc_obj=GPcon(23,2);
%     setappdata(0,'handles.sc_obj',handles.sc_obj);
catch
    errordlg('Failed to initialize connection to SourceMeter!','Error 0x010');
end
try
    handles.nV_obj=GPcon(6,2);
%     setappdata(0,'handles.nV_obj',handles.nV_obj);
catch
    errordlg('Failed to initialize connection to nanoVoltmeter!','Error 0x011');
end
setappdata(0,'handles',handles)
%timer
mainTimer = timer;
mainTimer.Name = 'Main GUI Timer';
mainTimer.ExecutionMode = 'fixedRate';
mainTimer.Period = 0.5;
mainTimer.TimerFcn = 'timer_function';
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
    cellCommands = {str};
elseif size(cellCommands,1) < index
    % put in the end of the array
    cellCommands{end+1,1} = str;
else
    cellCommands = [cellCommands(1:index-1);{str};cellCommands(index:end)];
end
cellCommands = cellTab(cellCommands);
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
if size(cellCommands,1) == 1
	cellCommands{index} = [];
else
    cellCommands(index) = [];
end
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


function txt_Stop_field_Callback(hObject, eventdata, handles)
% hObject    handle to txt_Stop_field (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_Stop_field as text
%        str2double(get(hObject,'String')) returns contents of txt_Stop_field as a double


function mf_rate_edit_Callback(hObject, eventdata, handles)
% hObject    handle to mf_rate_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mf_rate_edit as text
%        str2double(get(hObject,'String')) returns contents of mf_rate_edit as a double


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
    try
        newstring = cellTab(newstring')';	% add TABs
    catch
        errordlg('End statement cannot be above loop','Error 0x');
        return;
    end
    % Set the new cell array to the list box
    set(h, 'string', newstring);

function h = del_item_from_list_box(h, index)
% del_item_from_list_box - removes items to the listbox
% H = del_item_from_list_box(H, index)
% H listbox handle
% index - index to remove 
% STRING a new item to display
strings = get(h,'string');   % listbox string cell array
if isempty(strings)
    return;
end

for ind = 1:length(index)
    lineStr = strings{index(ind)};
    if strcmp(lineStr,'End')
        errordlg('Cannot delete End statement!','Error 0x004');
        return
    elseif strcmp(lineStr,'End Sequence')
        errordlg('Cannot delete End Sequence statement!','Error 0x005');
        return
    end
end
strings(index) = [];
set(h,'value',min(min(ind)+1,length(strings))); 
set(h,'string',strings); 
% L = length(strings);
% if isempty(strings)
% elseif index==L 
% else
%     newstring = {strings{1:(index-1)} strings{index+1:end}};
%     set(h,'string',newstring);
% end


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
currChar = get(handles.figure1,'CurrentCharacter');
if isequal(currChar,char(13)) % char(13) = enter key
   %call the pushbutton callback
   btnPause_Callback(hObject, eventdata, handles);
end


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
try
    del_item_from_list_box(handles.CommandList,index_selected);
    delete_command_str(index_selected);
catch
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

cla(handles.axes1);                                   % Reset Graph

set(handles.H_text_status,'String', '0');
set(handles.temp_text_status,'String', '---');        % Reset Live Data feed
set(handles.helium_level_text_status,'String', '---');
set(handles.pressure_text_status,'String', '---');


% Update handles structure
guidata(handles.figure1, handles);


% --- Executes on button press in write_to_file_button.
function write_to_file_button_Callback(hObject, eventdata, handles)
% hObject    handle to write_to_file_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

FileName = get(handles.file_name_edit,'String');  %get the desired filename
close_ind = getappdata(0,'cell_ind');
ListCommands = get(handles.CommandList,'string');
contents = getappdata(0,'cellCommands');
save(FileName,'close_ind','ListCommands','contents');

add_command_str(['load ',FileName,'.mat'],1);

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
        % to change, change w in fopen to a
    end
end

fclose(FID);

eval(['edit ',FileName,'.m']);   %show the file
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
varargout = load_file_dialog(figure(load_file_dialog)); % calls verification dialog
%excecution function goes here


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
currChar = get(handles.figure1,'CurrentCharacter');
if isequal(currChar,char(13)) % char(13) = enter key
   %call the pushbutton callback
   write_to_file_button_Callback(hObject, eventdata, handles);
end


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


% --- Executes on button press in choose_file_btn.
function choose_file_btn_Callback(hObject, eventdata, handles)
% hObject    handle to choose_file_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,FilePath] = uigetfile('*.m','Select the MATLAB file containing Commands');
if FileName==0
    errordlg('Error Reading File','Error 0x002');
    return
end
% setappdata(0,'FileName',FileName);
% setappdata(0,'FilePath',FilePath);
% setappdata(0,'Button','Choose'); %let dialog know what button is calling it
% varargout = load_file_dialog(figure(load_file_dialog));   %open verification load_file_dialog
FileName = [FilePath,FileName(1:end-2),'.mat'];
load(FileName,'ListCommands','contents');  % get listbox contents
set(handles.CommandList,'string',ListCommands);
setappdata(0,'cellCommands',contents);

% --- Executes on selection change in chamber_mode_popup.
function chamber_mode_popup_Callback(hObject, eventdata, handles)
% hObject    handle to chamber_mode_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns chamber_mode_popup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from chamber_mode_popup

%WHEN TIME'S COME: ADD THESE LINES:

action = contents{get(hObject,'Value')}; %id of selceted action
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
            try
                fclose(handles.PPMSObj)
            end
%             handles = rmfield(handles, 'PPMSObj');
        end
        try
            try
                fclose(handles.switcher_obj)
            end
%             handles = rmfield(handles, 'switcher_obj');
        end
        try
            try
                fclose(handles.sc_obj)
            end
%             handles = rmfield(handles, 'sc_obj');
        end
        try
            try
                fclose(handles.nV_obj)
            end
%             handles = rmfield(handles, 'nV_obj');
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
uiwait(ChannelMatrix);  % open and wait for channel  selection
matrixes = getappdata(0,'matrixes');    % get channels
configs = ~cellfun(@isempty,matrixes);  % convert to logical array
sums = sum(sum(configs,1),2);           % sum on every cofig
sums(:,:,~sums) = [];                   % delete empty configs
configs(:,:,~sums) = [];                % delete empty configs
% setappdata(0,'configs',configs);        % set app data
k = find(configs);                      % find non-zero elements -> linear index
[row,col,~] = ind2sub(size(configs),k);	% sub-index
close_ind = [row,col];                  % generate array
sizes = squeeze(sums)';                 % size of each config
cell_ind = mat2cell(close_ind,sizes);   % rows & cols ordered in cell array
setappdata(0,'cell_ind',cell_ind);      % set app data


% --- Executes on button press in sample_chk_btn.
function sample_chk_btn_Callback(hObject, eventdata, handles)
% hObject    handle to sample_chk_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CheckMatrix(getappdata(0,'handles.switcher_obj'),getappdata(0,'handles.sc_obj')); %should be changed to samplecheck


% --- Executes on button press in btnUp.
function btnUp_Callback(hObject, eventdata, handles)
% hObject    handle to btnUp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
index = get(handles.CommandList, 'Value');  % get selected index
allstring = get(handles.CommandList, 'string'); % get strings from listbox
len = length(allstring);    % number of lines
cellCommands = getappdata(0,'cellCommands');    % get commands cell array

if ~isempty(find(index==1))
    errordlg('Top line in program cannot be moved up','Error 0x');
elseif ~isempty(find(index==len))
    errordlg('End of program cannot be moved','Error 0x');
else
    select = allstring(index);
    allstring(index) = [];
    allstring = [allstring(1:min(index-2));select;allstring(min(index-1):end)];
    try
        allstring = cellTab(allstring);
        set(handles.CommandList,'String',allstring);   % set new order
        set(handles.CommandList,'Value',(min(index-2)+(1:length(index))));   % set selection to the moved line
    catch
        errordlg('End statement can''t be above its loop');
    end
    
    commands = cellCommands(index);  % get selcted commannd index
    cellCommands(index) = [];
    cellCommands = [cellCommands(1:min(index-2));commands;cellCommands(min(index-1):end)];
    try
        cellCommands = cellTab(cellCommands);
        setappdata(0,'cellCommands',cellCommands);
    catch
        errordlg('End statement can''t be above its loop');
    end
end



% --- Executes on button press in btnDown.
function btnDown_Callback(hObject, eventdata, handles)
% hObject    handle to btnDown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
index = get(handles.CommandList, 'Value');
allstring = get(handles.CommandList, 'string');
len = length(allstring);
indLen = length(index);

cellCommands = getappdata(0,'cellCommands');    % get commands cell array

if ~isempty(find(index==len))
    errordlg('End of program cannot be moved','Error 0x');
else
    select = allstring(index);
    allstring(index) = [];
    ind = max(index) - indLen + 1;
    if max(index)==len-1
        ind = ind-1;    % don't move under END SEQENCE
    end
    allstring = [allstring(1:ind);select;allstring(ind+1:end)];
    try
        allstring = cellTab(allstring);
        set(handles.CommandList,'String',allstring);   % set new order
        set(handles.CommandList,'Value',(ind+(1:indLen)));   % set selection to the moved line
    catch
        errordlg('End statement can''t be above its loop');
    end
    commands = cellCommands(index);  % get selcted commannd index
    cellCommands(index) = [];
    cellCommands = [cellCommands(1:ind);commands;cellCommands(ind+1:end)];
    try
        cellCommands = cellTab(cellCommands);
        setappdata(0,'cellCommands',cellCommands);
    catch
        errordlg('End statement can''t be above its loop');
    end
end


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
data = cell(2,2);
data{1,1} = 'Temprature';   % title
data{1,2} = '°K';           % units

data{2,1} = 'Field';
data{2,2} = 'Oe';

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
currChar = get(handles.figure1,'CurrentCharacter');
if isequal(currChar,char(13)) %char(13) == enter key
   %call the pushbutton callback
   btnSMadd_Callback(hObject, eventdata, handles);
end


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
choice = get(hObject,'Value');
units = get(hObject,'UserData');
unit = units{choice,3};
set(handles.txtVoltSetUnit,'String',unit);
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
data = cell(1,3);

data{1,1} = 'Integration Time'; % name
data{1,2} = 'IntegrationTime';  % function callback
data{1,3} = 'mS';             % units

set(hObject,'UserData',data);

% --- Executes on button press in btnConfig.
function btnConfig_Callback(hObject, eventdata, handles)
% hObject    handle to btnConfig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
funcFlag = get(handles.mnuVoltSet,'Value');  % Choice
Options = get(handles.mnuVoltSet,'UserData');% get data from menu
setValue = get(handles.edtVoltSet,'String');

% add item to sequence
commandLine = ['Set ',Options{funcFlag,1},' to ',setValue,Options{funcFlag,3}];
index = get(handles.CommandList,'Value');
add_item_to_list_box(handles.CommandList,commandLine,index);
functionStr = [Options{funcFlag,2},'(nv_obj, ',setValue,');'];
add_command_str(functionStr,index);


% --- Executes on selection change in mnuMeas.
function mnuMeas_Callback(hObject, eventdata, handles)
% hObject    handle to mnuMeas (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns mnuMeas contents as cell array
%        contents{get(hObject,'Value')} returns selected item from mnuMeas


% --- Executes during object creation, after setting all properties.
function mnuMeas_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mnuMeas (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
data = cell(3,2);
data{1,1} = '1 Shot Voltage';
data{1,2} = 'Add command';

data{2,1} = 'Continously';
data{2,2} = 'read(nv_obj);';

data{3,1} = 'Delta Mode';
data{3,2} = 'DeltaMode();';

set(hObject,'UserData',data);


% --- Executes on button press in btnMeas.
function btnMeas_Callback(hObject, eventdata, handles)
% hObject    handle to btnMeas (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
funcFlag = get(handles.mnuMeas,'Value');  % Choice
Options = get(handles.mnuMeas,'UserData');% get data from menu

% add item to sequence
commandLine = ['Measure Voltage ',Options{funcFlag,1}];
index = get(handles.CommandList,'Value');
add_item_to_list_box(handles.CommandList,commandLine,index);
add_command_str(Options{funcFlag,2},index);


function edtVoltSet_Callback(hObject, eventdata, handles)
% hObject    handle to edtVoltSet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
currChar = get(handles.figure1,'CurrentCharacter');
if isequal(currChar,char(13)) %char(13) == enter key
   %call the pushbutton callback
   btnVoltSet_Callback(hObject, eventdata, handles);
end


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
currChar = get(handles.figure1,'CurrentCharacter');
if isequal(currChar,char(13)) % char(13) = enter key
   %call the pushbutton callback
   btnSetParam_Callback(hObject, eventdata, handles);
end

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
        unitStr = '[°K';
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
add_command_str([functionStr,'    %',commandStr],index);


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
methodFlag = get(handles.rdoSteps,'Value');
switch paramflag
    case 1
        ParameterStr = 'Temp';
        functionStr = 'TEMP(PPMSObj,Temp(k),10,1);';
        indStr = 'k';
        unitStr = '[°K]';
        if str2double(initValStr)<1.7 || str2double(targetValStr)<1.7
            errordlg('Temperature can''t go below 1.7K');
            return;
        end
    case 2
        ParameterStr = 'H';
        functionStr = 'FIELD(PPMSobj,H(j),10,1,1);';
        indStr = 'j';
        unitStr = '[Oe]';
        if str2double(initValStr) > 9e4 || str2double(targetValStr) > 9e4
            errordlg('Magnetic field can''t go above 90,000 Oe (= 9T)');
            return;
        end
end

if methodFlag
    methodStr = 'steps';
    correct = floor(abs(str2double(methodVal)));	% steps must be natural number
    methodVal = num2str(correct);
    set(handles.edtStep,'String',methodVal);    % rewrite value
    defStr = [ParameterStr,' = ','linspace(',initValStr,',',targetValStr,',',methodVal,');'];
else
    methodStr = 'spacing';
    initVal = str2double(initValStr);
    targetVal = str2double(targetValStr);
    space = str2double(methodVal);
    interval = abs(initVal-targetVal);
    space = interval/floor(interval/space); % there must be natural number of steps
    methodVal = num2str(space);
    set(handles.edtStep,'String',methodVal);
    defStr = [ParameterStr,' = ',initValStr,':',methodVal,':',targetValStr,';'];
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


% --- Executes on button press in rdoSpace.
function rdoSteps_Callback(hObject, eventdata, handles)
% hObject    handle to rdoSpace (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.txt_MethodUnit,'String','');
% Hint: get(hObject,'Value') returns toggle state of rdoSpace


% --- Executes on button press in rdoSpace.
function rdoSpace_Callback(hObject, eventdata, handles)
% hObject    handle to rdoSpace (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
unit = get(handles.txt_initValUnit,'String');
set(handles.txt_MethodUnit,'String',unit);
% Hint: get(hObject,'Value') returns toggle state of rdoSpace


% --- Executes on button press in btnScanSwitch.
function btnScanSwitch_Callback(hObject, eventdata, handles)
% hObject    handle to btnScanSwitch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% update listbox
commandStr = 'Scan on switcher configurations';
index = get(handles.CommandList,'Value');
add_item_to_list_box(handles.CommandList,commandStr,index);
add_item_to_list_box(handles.CommandList,'end',index+1);

% update commands in script
sendCommand = { ['% ',commandStr];...
                'for s = 1:length(close_ind)';...
                'rows = close_ind{s}(:,1);';...
                'cols = close_ind{s}(:,2);';...
                'for ch = 1:size(rows,1)';...
                'closeCH(switcher_obj,rows(ch),cols(ch),1);';...
                'end'};
add_command_str(sendCommand,index);
add_command_str('end',index+1);


% --- Executes on selection change in mnuSet.
function mnuSet_Callback(hObject, eventdata, handles)
% hObject    handle to mnuSet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns mnuSet contents as cell array
%        contents{get(hObject,'Value')} returns selected item from mnuSet


% --- Executes during object creation, after setting all properties.
function mnuSet_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mnuSet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btnSetSource.
function btnSetSource_Callback(hObject, eventdata, handles)
% hObject    handle to btnSetSource (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


function edtTargetSet_Callback(hObject, eventdata, handles)
% hObject    handle to edtTargetSet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edtTargetSet as text
%        str2double(get(hObject,'String')) returns contents of edtTargetSet as a double


function edtRateSet_Callback(hObject, eventdata, handles)
% hObject    handle to edtRateSet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edtRateSet as text
%        str2double(get(hObject,'String')) returns contents of edtRateSet as a double


% --- Executes on selection change in popupmenu18.
function popupmenu18_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu18 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu18


% --- Executes on selection change in mnuScan.
function mnuScan_Callback(hObject, eventdata, handles)
% hObject    handle to mnuScan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns mnuScan contents as cell array
%        contents{get(hObject,'Value')} returns selected item from mnuScan


% --- Executes during object creation, after setting all properties.
function mnuScan_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mnuScan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
data = cell(6,3);
% option 1
data{1,1} = 'Temperature';    % title
data{1,2} = '°K';               % units
data{1,3} = 'current';          % function name

% option 2
data{2,1} = 'Field';
data{2,2} = 'Oe';
data{2,3} = 'FIELD';

% option 3
data{3,1} = 'Current List';
data{3,2} = 'uA';
data{3,3} = 'current';

% option 4
data{4,1} = 'Voltage';
data{4,2} = 'uV';
data{4,3} = 'voltage';

set(hObject,'UserData',data);


function edtRateScan_Callback(hObject, eventdata, handles)
% hObject    handle to edtRateScan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edtRateScan as text
%        str2double(get(hObject,'String')) returns contents of edtRateScan as a double


% --- Executes on button press in btnOpenPlot.
function btnOpenPlot_Callback(hObject, eventdata, handles)
% hObject    handle to btnOpenPlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
