function varargout = MainFig3(varargin) 
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


% Last Modified by GUIDE v2.5 10-Aug-2016 14:09:46


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
        fclose(handles.PPMS_obj);
%         PPMS_obj = getappdata(0,'PPMS_obj');
%         fclose(PPMS_obj);
        
    end
%     handles = rmfield(handles, 'PPMS_obj');
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
    handles.PPMS_obj= GPcon(15,0);
%     PPMS_obj = GPcon(15,0);
%     setappdata(0,'PPMS_obj',PPMS_obj);
catch
    errordlg('Failed to initialize connection to PPMS!','Error 0x007');
end
try
    handles.switcher_obj = GPcon(5,0);
%     setappdata(0,'handles.switcher_obj',handles.switcher_obj);
catch
    errordlg('Failed to initialize connection to switcher!','Error 0x009');
end
try
    handles.sc_obj=GPcon(23,0);
%     setappdata(0,'handles.sc_obj',handles.sc_obj);
catch
    errordlg('Failed to initialize connection to SourceMeter!','Error 0x010');
end
try
    handles.nV_obj=GPcon(6,0);
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
if isempty(cellCommands)
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
cellCommands = cellTab(cellCommands);	% add TABs
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
FIELD(handles.PPMS_obj,StopField,rate,approach,mode);


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

    if isempty(oldstring)
        newstring = {newitem};
%     elseif ~iscell(oldstring)
%          newstring = {oldstring newitem};
    elseif size(oldstring,1) == 1
        if ~iscell(oldstring)
        	newstring = {newitem oldstring};
        else
            newstring = {newitem ,oldstring{:}};
        end
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

function endseq = del_item_from_list_box(h, index)
% del_item_from_list_box - removes items to the listbox
% H = del_item_from_list_box(H, index)
% H listbox handle
% index - index to remove 
% STRING a new item to display
strings = get(h,'string');   % listbox string cell array
endseq = 0;
if isempty(strings)
    return;
end

count = 0;
for ind = 1:length(index)
    lineStr = strtrim(strings{index(ind)});
    switch lineStr(1:3)
        case {'Sca','Whi'}
            count = count + 1;
        case 'end'
            count = count - 1;
            if count < 0
                errordlg('Cannot delete End statement without its scan!','Error 0x004');
                return;
            end
        case 'End'
            errordlg('Cannot delete End Sequence statement!','Error 0x005');
            endseq = 1;
            return;
    end
end
strings(index) = [];
strings = cellTab(strings);	% add TABs
set(h,'value',min(min(index),length(strings))); 
set(h,'string',strings); 


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

% --- Executes on key press with focus on CommandList and none of its controls.
function CommandList_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to CommandList (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
key = eventdata.Key;
switch lower(key)
    case 'delete'
        btnDeleteLine_Callback(handles.btnDeleteLine, eventdata, handles);    % call the pushbutton callback
    case 'w'
        btnUp_Callback(handles.btnUp,eventdata,handles);
    case 'd'
        btnDown_Callback(handles.btnDown,eventdata,handles);
    case 'c'    % copy
        copyind = get(hObject,'value');
        listStr = get(hObject,'string');
        len = length(listStr);	% number of lines
        copyind(copyind==len) = [];     % don't copy end of program
        cellCommands = getappdata(0,'cellCommands');	% get commands cell array
        copyList = listStr(copyind);
        copyCommands = cellCommands(copyind);
        setappdata(0,'copyCommands',copyCommands);
        setappdata(0,'copyList',copyList);
    case 'v'    % paste
        copyCommands = getappdata(0,'copyCommands');
        copyList = getappdata(0,'copyList');
        index = max(get(hObject,'value'));
        allstring = get(hObject,'string');
        allstring = [allstring(1:(index-1));copyList;allstring(index:end)];
        try
            allstring = cellTab(allstring);
            set(handles.CommandList,'String',allstring);   % set new order
            set(handles.CommandList,'Value',index-1+copyind);   % set selection to the moved line
        catch
    %         errordlg('End statement can''t be above its loop');
        end
        cellCommands = getappdata(0,'cellCommands');
        cellCommands = [cellCommands(1:(index-1));copyCommands;cellCommands(index:end)];
        try
            cellCommands = cellTab(cellCommands);
            setappdata(0,'cellCommands',cellCommands);
        catch
    %         errordlg('End statement can''t be above its loop');
        end
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
    endseq = del_item_from_list_box(handles.CommandList,index_selected);
    if ~endseq
        delete_command_str(index_selected);
    end
catch
    errordlg('Error while deleting line');
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


% --- Executes on button press in btnSaveFile.
function btnSaveFile_Callback(hObject, eventdata, handles)
% hObject    handle to btnSaveFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
FileName = get(handles.file_name_edit,'String');  % get the desired filename
[FileName,dir] = uiputfile('*.m','Save Script',FileName);
if ~dir
%     errordlg('No directory was chosen');
    return;
end
close_ind = getappdata(0,'cell_ind');
ListCommands = get(handles.CommandList,'string');   % get commands list window
contents = getappdata(0,'cellCommands');        % get code
contents = [['load ',FileName(1:end-2),'.mat;'];contents];   % load data in script

% if strcmp(FileName,'Enter File name')    % make sure the user has entered a filename
%      errordlg('Please Enter a File Name!','Error 0x003');  % user didnt
%     return
% end

FileName = [dir,FileName(1:end-2)];
eval(['save(','''',FileName,'.mat','''',',''close_ind'',''ListCommands'',''contents'');']);

eval(['FID = fopen(',['''',FileName,'.m'''],',''w'');']);
% FID = fopen(['''',FileName,'.m'''],'w');   
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

eval(['edit ','''',FileName,'''','.m']);   %show the file
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
   btnSaveFile_Callback(hObject, eventdata, handles);
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
contents = get(hObject,'string');
action = contents{get(hObject,'Value')}; %id of selceted action
CHAMBER(PPMS_obj,action-1);


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
TEMP(handles.PPMS_obj,Destination_temp,rate,approach);


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
                fclose(handles.PPMS_obj)
            end
%             handles = rmfield(handles, 'PPMS_obj');
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
close_ind = [col,row+2];                  % generate array
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
%     errordlg('Top line in program cannot be moved up','Error 0x');
elseif ~isempty(find(index==len))
%     errordlg('End of program cannot be moved','Error 0x');
else
    select = allstring(index);
    allstring(index) = [];
    allstring = [allstring(1:min(index-2));select;allstring(min(index-1):end)];
    try
        allstring = cellTab(allstring);
        set(handles.CommandList,'String',allstring);   % set new order
        set(handles.CommandList,'Value',(min(index-2)+(1:length(index))));   % set selection to the moved line
    catch
%         errordlg('End statement can''t be above its loop');
    end
    
    commands = cellCommands(index);  % get selcted commannd index
    cellCommands(index) = [];
    cellCommands = [cellCommands(1:min(index-2));commands;cellCommands(min(index-1):end)];
    try
        cellCommands = cellTab(cellCommands);
        setappdata(0,'cellCommands',cellCommands);
    catch
%         errordlg('End statement can''t be above its loop');
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
%         errordlg('End statement can''t be above its loop');
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
data{1,1} = 'Temperature';   % title
data{1,2} = 'wait for temperature to be reached';           % hint

data{2,1} = 'Field';
data{2,2} = 'wait for magnetic field to be reached';

set(hObject,'UserData',data);

% --- Executes on selection change in mnuParameter.
function mnuParameter_Callback(hObject, eventdata, handles)
% hObject    handle to mnuParameter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
choice = get(hObject,'Value');
options = get(hObject,'UserData');
set(handles.txtHint,'string',options{choice,2});


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


% --- Executes on selection change in mnuConfig.
function mnuConfig_Callback(hObject, eventdata, handles)
% hObject    handle to mnuConfig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
choice = get(hObject,'Value');
data = get(hObject,'UserData');
set(handles.txtHint,'string',data{choice,4});    % set hint in window
set(handles.edtVoltSet,'string',data{choice,5});
unit = data{choice,3};
if iscell(unit)
    set(handles.mnuConfigParam,'visible','on');
    set(handles.mnuConfigParam,'string',unit);
    set(handles.txtVoltSetUnit,'String','');
else
    set(handles.mnuConfigParam,'visible','off');
    set(handles.txtVoltSetUnit,'String',unit);
end

% --- Executes during object creation, after setting all properties.
function mnuConfig_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mnuConfig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
data = cell(4,5);

data{1,1} = 'Compliance'; % name
data{1,2} = 'compliance(sm_obj,<>);';  % function callback
data{1,3} = 'V';             % units
data{1,4} = 'Set compliance level of the Source-Meter.';             % hint
data{1,5} = '2';

data{2,1} = 'Terminal'; % name
data{2,2} = 'terminal(nv_obj,<>);';  % function callback
data{2,3} = {'Rear';'Front'};             % units
data{2,4} = 'Set terminal of the Nano-Voltmeter.';             % hint
data{2,5} = ''; 
% data{3,1} = 'Points'; % name
% data{3,2} = 'xPointM';  % function callback
% data{3,3} = {'2';'4'};             % units

data{3,1} = 'Integration Time'; % name
data{3,2} = 'IntegrationTime(nv_obj,<>); Tintegration = <>;';	% function callback
data{3,3} = 'sec';	% units
data{3,4} = 'Set integration time of the Nano-Voltmeter.';             % hint
data{3,5} = '0.02';

data{4,1} = 'Temperature Interval'; % name
data{4,2} = 'dT = <>;';	% function callback
data{4,3} = '°K';	% units
data{4,4} = 'Set interval of Temperature sensetivity, affects on fast wait4 and fast while-do.';             % hint
data{4,5} = '0.1';

data{5,1} = 'Field interval'; % name
data{5,2} = 'dH = <>;';	% function callback
data{5,3} = 'Oe';	% units
data{5,4} = 'Set interval of Field sensetivity, affects on fast wait4 and fast while-do.';             % hint
data{5,5} = '1';

set(hObject,'UserData',data);

% --- Executes on button press in btnConfig.
function btnConfig_Callback(hObject, eventdata, handles)
% hObject    handle to btnConfig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
choice = get(handles.mnuConfig,'Value');  % Choice
Options = get(handles.mnuConfig,'UserData');% get data from menu

unit = Options{choice,3};
if iscell(unit)
    paramFlag = get(handles.mnuConfigParam,'Value');
    setValue = get(handles.mnuConfigParam,'String');
    setValue = setValue{paramFlag};
    if ischar(num2str(setValue))
        setValue = ['''',setValue,''''];
    end
    unit = '';
else
    setValue = get(handles.edtVoltSet,'String');
    unit = ['[',unit,']'];
end

% add item to sequence
commandLine = ['Set ',Options{choice,1},' to ',setValue,unit];
index = get(handles.CommandList,'Value');
add_item_to_list_box(handles.CommandList,commandLine,index);
functionStr = [strrep(Options{choice,2},'<>',setValue),'    % ', commandLine];
% functionStr = [Options{choice,2},'(nv_obj,',setValue,');    % ',commandLine];
add_command_str(functionStr,index);


function edtVoltSet_Callback(hObject, eventdata, handles)
% hObject    handle to edtVoltSet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
currChar = get(handles.figure1,'CurrentCharacter');
if isequal(currChar,char(13)) %char(13) == enter key
   %call the pushbutton callback
   btnConfig_Callback(hObject, eventdata, handles);
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
        functionStr = ['TEMP(PPMS_obj,',targetStr,',',rate,',10,1);'];
        unitStr = '[°K';
    case 2
        ParameterStr = 'Field';
        functionStr = ['FIELD(PPMS_obj,',targetStr,',',rate,',1,1);'];
        unitStr = '[Oe';
end

% update listbox
commandStr = ['Set ',ParameterStr,' to ', targetStr,unitStr,']',...
                ' in rate ',rate,unitStr,'/min]'];
index = get(handles.CommandList,'Value');
add_item_to_list_box(handles.CommandList,commandStr,index);

% update commands in script
add_command_str([functionStr,'    % ',commandStr],index);


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
choice = get(handles.mnuScan,'Value');
switch choice
    case {1,2}
        ScanPPMS(handles, choice);
    case {3,4}
        ScanSM(handles, choice);
    case 5
        ScanTime(handles, choice);
end

function ScanTime(handles, choice)
initValStr = get(handles.edtInitVal,'String');
targetValStr = get(handles.edtTargetVal,'String');
methodVal = get(handles.edtStep,'String');
methodFlag = get(handles.rdoSteps,'Value');
Options = get(handles.mnuScan,'UserData');
ParameterStr = Options{choice,1};   % Parameter name
unitStr = ['[',Options{choice,2},']'];  % unit

if methodFlag
    methodStr = 'steps';
    correct = floor(abs(str2double(methodVal)));	% steps must be natural number
    methodVal = num2str(correct);
    set(handles.edtStep,'String',methodVal);    % rewrite value
    defStr = [ParameterStr(1:4),' = ','linspace(0,',targetValStr,',',methodVal,');'];
    targetVal = str2double(targetValStr);
    pause = num2str(targetVal/(correct-1));
else
    methodStr = 'spacing';
    targetVal = str2double(targetValStr);
    space = str2double(methodVal);
    space = targetVal/floor(targetVal/space); % there must be natural number of steps
    methodVal = num2str(space);
    set(handles.edtStep,'String',methodVal);
    defStr = [ParameterStr(1:4),' = 0:',methodVal,':',targetValStr,';'];
    pause = methodVal;
end
commandStr = ['Scan ',ParameterStr,' from ',initValStr,unitStr,' to ',...
        targetValStr,unitStr,' by ',methodStr,' of ', methodVal,unitStr];
index = get(handles.CommandList,'Value');
add_item_to_list_box(handles.CommandList,commandStr,index);
add_item_to_list_box(handles.CommandList,'end',index+1);

% update commands in script
add_command_str(['for ',defStr],index);
pauseStr = ['pause(',pause,');'];
add_command_str({pauseStr;'end'},index+1);


function ScanSM(handles, choice)
index = get(handles.CommandList,'Value');
Options = get(handles.mnuScan,'UserData');
ParameterStr = Options{choice,1};   % Parameter name
unitStr = ['[',Options{choice,2},']'];  % unit
initValStr = get(handles.edtInitVal,'String');
targetValStr = get(handles.edtTargetVal,'String');
routine = get(handles.mnuApproach,'value');
switch routine
    case {1,2}  % Normal scan or IV
        methodVal = get(handles.edtStep,'String');
        methodFlag = get(handles.rdoSteps,'Value');
        indArr = 'jv'; % array of loop indices
        indStr = indArr(choice - 2);
        if methodFlag
            methodStr = 'steps';
            correct = floor(abs(str2double(methodVal)));	% steps must be natural number
            methodVal = num2str(correct);
            set(handles.edtStep,'String',methodVal);    % rewrite value
            if routine == 1 % Normal scan
                defStr = [ParameterStr(1:4),' = ','linspace(',initValStr,',',targetValStr,',',methodVal,');'];
                commandStr = ['Scan ',ParameterStr,' from ',initValStr,unitStr,' to ',...
                                targetValStr,unitStr,' by ',methodStr,' of ', methodVal];
                add_item_to_list_box(handles.CommandList,commandStr,index);
                add_item_to_list_box(handles.CommandList,'end',index+1);
                % update commands in script
                functionStr = [lower(ParameterStr),...
                    '(sm_obj,''on'',',ParameterStr(1:4),'(',indStr,'))'];
                sendCommand = {defStr;['for ',indStr,'=1:length(',ParameterStr(1:4),')'];functionStr};
                add_command_str(sendCommand,index);
                add_command_str('end',index+1);
            else    % IV
                commandStr = ['IV measurement (',ParameterStr,'): center ',initValStr,unitStr,...
                    ' , span  ',targetValStr,unitStr,' , ',methodVal,' steps'];
                add_item_to_list_box(handles.CommandList,commandStr,index);
                functionStr = ['[Idata,Vdata] = executeIVspan(nv_obj, sm_obj,','''',ParameterStr(1),'''',...
                    ',',initValStr,',',targetValStr,',',methodVal,');   % ', commandStr];
                add_command_str({functionStr;'I{end+1*(s==1),s} = Idata;     % IV current';...
                                    'V{end+1*(s==1),s} = Vdata;     % IV voltage';...
                                    '%  dR{end+1*(s==1),s} = diff(Vdata)./diff(Idata);    % differential Resistance'},index);
            end
        else
            methodStr = 'spacing';
            initVal = str2double(initValStr);
            targetVal = str2double(targetValStr);
            space = str2double(methodVal);
            interval = abs(initVal-targetVal);
            space = interval/floor(interval/space); % there must be natural number of steps
            methodVal = num2str(space);
            set(handles.edtStep,'String',methodVal);
            if routine == 1 % Normal scan
                defStr = [ParameterStr(1:4),' = ','linspace(',initValStr,',',targetValStr,',',methodVal,');'];
                commandStr = ['Scan ',ParameterStr,' from ',initValStr,unitStr,' to ',...
                                targetValStr,unitStr,' by ',methodStr,' of ', methodVal];
                add_item_to_list_box(handles.CommandList,commandStr,index);
                add_item_to_list_box(handles.CommandList,'end',index+1);
                % update commands in script
                functionStr = [lower(ParameterStr),...
                    '(sm_obj,''on'',',ParameterStr(1:4),'(',indStr,'));'];
                sendCommand = {defStr;['for ',indStr,'=1:length(',ParameterStr(1:4),')'];['% ',commandStr];functionStr};
                add_command_str(sendCommand,index);
                add_command_str('end',index+1);
            else    % IV
                commandStr = ['IV measurement (',ParameterStr,'): start ',initValStr,unitStr,...
                    ' , stop  ',targetValStr,unitStr,' , spacing ',methodVal,unitStr];
                add_item_to_list_box(handles.CommandList,commandStr,index);
                functionStr = ['executeIV(nv_obj, sm_obj,','''',ParameterStr(1),'''',...
                    ',',initValStr,',',targetValStr,',',methodVal,');    % ',commandStr];
                add_command_str(functionStr,index);
            end
        end

    case 3  % delta is on
        repeatStr = get(handles.edtRateScan,'string');
        if str2double(repeatStr) < 1
           repeatStr = '1';
           set(handles.edtRateScan,'string','1');
        end
        commandStr = ['Delta measurement (',ParameterStr,'): center ',initValStr,unitStr,...
            ' , span  ',targetValStr,unitStr,' , ',repeatStr,' repeats'];
        add_item_to_list_box(handles.CommandList,commandStr,index);
        functionStr = ['[Id,Vd] = deltaExecuteSpan(nv_obj, sm_obj,','''',ParameterStr(1),'''',...
                    ',',initValStr,',',targetValStr,',',repeatStr,');    % ',commandStr];
        add_command_str({functionStr;...
            'dI(end+1*(s==1),s) = Id(2);    % span/2 current, differential current  (dI/2)';...
            'dV(end+1*(s==1),s) = Vd(2);    % span/2 current, differential voltage  (dV/2)';...
            'dR(end+1*(s==1),s) = Vd(2)/Id(2);  % differential resistance'},index);
    case 4  % continous measurement
        Tread = initValStr; Tintegration = targetValStr;
        commandStr = ['Measure Voltage continously over ',Tread,'[sec] , integration time: ',Tintegration,'[sec]'];
        add_item_to_list_box(handles.CommandList,commandStr,index);
        add_command_str(['Vcont = VcontMeas(nv_obj,',Tread,',',Tintegration,');    % ',commandStr],index);
end


function ScanPPMS(handles, choice)
initValStr = get(handles.edtInitVal,'String');
targetValStr = get(handles.edtTargetVal,'String');
methodVal = get(handles.edtStep,'String');
Options = get(handles.mnuScan,'UserData');
methodFlag = get(handles.rdoSteps,'Value');
ParameterStr = Options{choice,1};   % Parameter name
unitStr = ['[',Options{choice,2},']'];  % unit
indArr = {'Tind','Find'}; % array of loop indices
indStr = indArr{choice};
appInd = get(handles.mnuApproach,'value');
appStr = num2str(appInd - 1);
rateStr = get(handles.edtRateScan,'string');
allStr = get(handles.mnuApproach,'string');
apmStr = allStr{appInd};

switch choice
    case 1
        functionStr = ['TEMP(PPMS_obj,Temp(Tind),',rateStr,',',appStr,');'];
        setCom = ['TEMP(PPMS_obj,',initValStr,',',rateStr,',',appStr,');'];
        if str2double(initValStr)<1.8 ||  str2double(initValStr)>370 || str2double(targetValStr)<1.8 ||  str2double(targetValStr)>370
            errordlg('Temperature can''t go below 1.8K or above 370K');
            return;
        end
        if str2double(rateStr)<=0 || str2double(rateStr)>12
            errordlg('Temperature rate can''t go below 0[K/min] or above 12[K/min]');
            return;
        end
    case 2
        modeStr = num2str(get(handles.mnuEndMode,'value')-1);
        functionStr = ['FIELD(PPMS_obj,Fiel(Find),',rateStr,',',appStr,',',modeStr,');'];
        setCom = ['FIELD(PPMS_obj,',initValStr,',',rateStr,',',appStr,',',modeStr,');'];
        AllMode = get(handles.mnuEndMode,'string');
        modeStr = AllMode{str2double(modeStr)+1};
        apmStr = [apmStr,', ',modeStr];
        if abs(str2double(initValStr)) > 9e4 || abs(str2double(targetValStr)) > 9e4
            errordlg('Magnetic field (absolute value) can''t go above 90,000 Oe (= 9T)');
            return;
        end
        if str2double(rateStr)<=0 || str2double(rateStr)>187
            errordlg('Temperature rate can''t go below 0[Oe/sec] or above 187[Oe/sec]');
            return;
        end
end

if methodFlag
    methodStr = 'steps';
    correct = floor(abs(str2double(methodVal)));	% steps must be natural number
    methodVal = num2str(correct);
    set(handles.edtStep,'String',methodVal);    % rewrite value
    defStr = [ParameterStr(1:4),' = ','linspace(',initValStr,',',targetValStr,',',methodVal,');'];
    methodValunit = methodVal;
else
    methodStr = 'spacing';
    initVal = str2double(initValStr);
    targetVal = str2double(targetValStr);
    space = str2double(methodVal);
    interval = targetVal-initVal;
    space = interval/floor(abs(interval/space)); % there must be natural number of steps
    set(handles.edtStep,'String',num2str(space));
    methodValunit = [num2str(space),unitStr];
    defStr = [ParameterStr(1:4),' = ',initValStr,':',methodVal,':',targetValStr,';'];
end

% update listbox
rateUnit = get(handles.txtRateScan,'string');
rateUnit = ['[',rateUnit(6:end-2),']',];
commandStr = ['Scan ',ParameterStr,' from ',initValStr,unitStr,' to ',...
        targetValStr,unitStr,' by ',methodStr,' of ', methodValunit,...
        '. Rate ',rateStr,rateUnit,', ',apmStr];
index = get(handles.CommandList,'Value');

setStr = ['Set ',ParameterStr,' to ', initValStr,unitStr,...
            ' in rate ',rateStr,rateUnit,', ',apmStr];
            
add_item_to_list_box(handles.CommandList,setStr,index);
add_item_to_list_box(handles.CommandList,commandStr,index+1);
add_item_to_list_box(handles.CommandList,'end',index+2);

% update commands in script
add_command_str(setCom,index);
sendCommand = {defStr;['for ',indStr,'=1:length(',ParameterStr(1:4),')'];['% ',commandStr];functionStr};
add_command_str(sendCommand,index+1);
add_command_str('end',index+2);


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
choice = get(hObject,'value');
if choice
    set(handles.txt_MethodUnit,'String','');
else
    set(handles.rdoSteps,'value',1);
end
mnuApproach_Callback(handles.mnuApproach, eventdata, handles);
% Hint: get(hObject,'Value') returns toggle state of rdoSpace

% --- Executes on button press in rdoSpace.
function rdoSpace_Callback(hObject, eventdata, handles)
% hObject    handle to rdoSpace (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
choice = get(hObject,'value');
if choice
    unit = get(handles.txt_initValUnit,'String');
    set(handles.txt_MethodUnit,'String',unit);
%     chkDelta_Callback(handles.chkDelta,eventdata,handles);
else
    set(handles.rdoSpace,'value',1);
end
% Hint: get(hObject,'Value') returns toggle state of rdoSpace
mnuApproach_Callback(handles.mnuApproach, eventdata, handles);


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
                'openAllCH(switcher_obj);';...
                'rows = close_ind{s}(:,1);';...
                'cols = close_ind{s}(:,2);';...
                'for ch = 1:size(rows,1)';...
                '% close all channels on this configuration';...
                'closeCH(switcher_obj,rows(ch),cols(ch),1);';...
                'end'};
add_command_str(sendCommand,index);
add_command_str('end',index+1);


% --- Executes on selection change in mnuSet.
function mnuSet_Callback(hObject, eventdata, handles)
% hObject    handle to mnuSet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
options = get(hObject,'UserData');
paramflag = get(hObject,'Value');
unitStr = options{paramflag,2};
set(handles.txtRateSet,'string','Rate:');
set(handles.txtUnitTargetSet,'string',unitStr);
hintStr = options{paramflag,5};
set(handles.txtHint,'string',hintStr);
defVals = options{paramflag,6};
set(handles.edtTargetSet,'String',num2str(defVals(1)));
set(handles.edtRateSet,'String',num2str(defVals(2)));

if paramflag==1 || paramflag==2
    set(handles.tglSM,'Enable','off');
    set(handles.tglSM,'Visible','off');
    set(handles.edtRateSet,'Enable','on');
    set(handles.txtUnitRateSet,'Enable','on');
    set(handles.txtRateSet,'Enable','on');    
    rateUnit = {'/min:','/sec:'};
    set(handles.txtUnitRateSet,'string',[unitStr,rateUnit{paramflag}]);
else
	set(handles.edtRateSet,'Enable','off');
    set(handles.txtUnitRateSet,'Enable','off');
    set(handles.txtUnitRateSet,'string','');
    set(handles.txtRateSet,'Enable','off');
    set(handles.tglSM,'Visible','on');
    set(handles.tglSM,'Enable','on');
end


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
data = cell(4,5);

data{1,1} = 'Temperature'; % name
data{1,2} = '°K';       % units
data{1,3} = 'TEMP';     % function callback
data{1,4} = 'PPMS_obj';	% object
data{1,5} = 'Send PPMS to specified temperature (Kelvin) by specified rate';	% hint
data{1,6} = [100, 4];    % default values

data{2,1} = 'Field'; % name
data{2,2} = 'Oe';       % units
data{2,3} = 'FIELD';     % function callback
data{2,4} = 'PPMS_obj';	% object
data{2,5} = 'Send PPMS to specified magnetic field (Oersted) by specified rate';	% hint
data{2,6} = [0, 10];    % default values

data{3,1} = 'Current'; % name
data{3,2} = 'uA';       % units
data{3,3} = 'current';	% function callback
data{3,4} = 'sm_obj';	% object
data{3,5} = 'Apply current (micro-Ampere) from the Source-Meter';	% hint
data{3,6} = [1, 0];    % default values

data{4,1} = 'Voltage'; % name
data{4,2} = 'V';       % units
data{4,3} = 'voltage';     % function callback
data{4,4} = 'sm_obj';	% object
data{4,5} = 'Apply voltage (Volt) from the Source-Meter';	% hint
data{4,6} = [1, 0];    % default values

set(hObject,'UserData',data);


% --- Executes on button press in btnSetSource.
function btnSetSource_Callback(hObject, eventdata, handles)
% hObject    handle to btnSetSource (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
paramflag = get(handles.mnuSet,'Value');
targetStr = get(handles.edtTargetSet,'String');

options = get(handles.mnuSet,'UserData');
ParameterStr = options{paramflag,1};
unitStr = options{paramflag,2};
funcName = options{paramflag,3};
% objStr = options{paramflag,4};

switch paramflag
    case {1,2}
        rate = get(handles.edtRateSet,'String');
        switch paramflag
            case 1  % temperature
                functionStr = ['TEMP(PPMS_obj,',targetStr,',',rate,',10,1);'];
                if str2double(targetStr)<1.8 ||  str2double(targetStr)>370
                    errordlg('Temperature can''t go below 1.8K or above 370K');
                    return;
                end
                if str2double(rate)<=0 || str2double(rate)>12
                    errordlg('Temperature rate can''t go below 0[K/min] or above 12[K/min]');
                    return;
                end
            case 2  % field
                functionStr = ['FIELD(PPMS_obj,',targetStr,',',rate,',1);'];
                if abs(str2double(targetStr)) > 9e4
                    errordlg('Magnetic field (absolute value) can''t go above 90,000 Oe (= 9T)');
                    return;
                end
                if str2double(rate)<=0 || str2double(rate)>187
                    errordlg('Temperature rate can''t go below 0[Oe/sec] or above 187[Oe/sec]');
                    return;
                end
        end
        % update listbox
        commandStr = ['Set ',ParameterStr,' to ', targetStr,'[',unitStr,']',...
                        ' in rate ',rate,'[',unitStr,'/min]',];
        index = get(handles.CommandList,'Value');
        add_item_to_list_box(handles.CommandList,commandStr,index);
        % update commands in script
        add_command_str([functionStr,'    % ',commandStr],index);
    case {3,4}
        % update listbox
        state = get(handles.tglSM,'string');
        commandStr = ['Set ',ParameterStr,' to ', targetStr,'[',unitStr,'] - ',state];
        index = get(handles.CommandList,'Value');
        add_item_to_list_box(handles.CommandList,commandStr,index);
        % update commands in script
        state = get(handles.tglSM,'string');
        functionStr = [funcName,'(sm_obj,','',state,'',',',targetStr,');'];
        add_command_str([functionStr,'    % ',commandStr],index);
end

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

 
% --- Executes on selection change in mnuScan.
function mnuScan_Callback(hObject, eventdata, handles)
% hObject    handle to mnuScan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
options = get(hObject,'UserData');
paramflag = get(hObject,'Value');
unitStr = options{paramflag,2};
set(handles.txt_initValUnit,'string',unitStr);
set(handles.txt_finalValUnit,'string',unitStr);
uflag = get(handles.rdoSpace,'value');
if uflag
    set(handles.txt_MethodUnit,'string',unitStr);
end
hintStr = options{paramflag,5};
defVals = options{paramflag,6};
set(handles.txtHint,'string',hintStr(1,:));
set(handles.edtInitVal,'String',num2str(defVals(1)));
set(handles.edtTargetVal,'String',num2str(defVals(2)));
set(handles.edtRateScan,'String',num2str(defVals(3)));
adata = get(handles.mnuApproach,'UserData');
set(handles.mnuApproach,'Value',1);
set(handles.btnSetup,'visible','off');

switch paramflag
    case 5  % Time
        set(handles.txtTarVal,'string','Time interval:');
        set(handles.edtInitVal,'Enable','off');
        set(handles.txtInitVal,'Enable','off');
        set(handles.txtApproach,'Enable','off');
        set(handles.mnuApproach,'Enable','off');
        set(handles.edtRateScan,'Enable','off');
        set(handles.txtRateScan,'Enable','off');
        set(handles.mnuEndMode,'Enable','off');
        set(handles.txtEndMode,'Enable','off');
    case {1,2}  % Temp or Field
        set(handles.mnuApproach,'string',adata{paramflag});
        set(handles.txtApproach,'string','Approach:');
        set(handles.txtInitVal,'string','Initial Value:');
        set(handles.txtTarVal,'string','Target Value:');
        set(handles.edtInitVal,'Enable','on');
        set(handles.txtInitVal,'Enable','on');
        set(handles.txtApproach,'Enable','on');
        set(handles.mnuApproach,'Enable','on');
        set(handles.edtRateScan,'Enable','on');
        set(handles.txtRateScan,'Enable','on');
        rateUnit = {'/min):','/sec):'};
        set(handles.txtRateScan,'string',['Rate(',unitStr,rateUnit{paramflag}]);
        set(handles.btnScan,'string','Scan');
        set(handles.rdoSteps,'enable','on');
        set(handles.rdoSpace,'enable','on');
        set(handles.edtStep,'enable','on');
        state = 'off';
        if paramflag == 2
            state = 'on';
        end
        set(handles.mnuEndMode,'Enable',state);
        set(handles.txtEndMode,'Enable',state);
    case {3,4}  % V or I
        set(handles.mnuApproach,'string',adata{paramflag});
        set(handles.txtApproach,'string','Routine:');
        set(handles.mnuEndMode,'Enable','off');
        set(handles.txtEndMode,'Enable','off');
        set(handles.txtInitVal,'string','Initial Value:');
        set(handles.txtTarVal,'string','Target Value:');
        set(handles.edtInitVal,'Enable','on');
        set(handles.txtInitVal,'Enable','on');
        set(handles.txtApproach,'Enable','on');
        set(handles.mnuApproach,'Enable','on');
        set(handles.txtRateScan,'string','Repeats:');
end

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

data = cell(5,6);
data{5,1} = 'Time'; % name
data{5,2} = 'sec';       % units
data{5,3} = '';     % function callback
data{5,4} = '';	% object
data{5,5} = {'Scan (loop) on time values (seconds).',...  % hint
             '    Time interval - Total time from initialization',...
             '    Spacing - diffrence of time in each iteration.',...
             '    Steps - number of points to be scanned.'};
data{5,6} = [0, 10, 0];   % default values - initVal, target, rate

data{1,1} = 'Temperature'; % name
data{1,2} = '°K';       % units
data{1,3} = 'TEMP';     % function callback
data{1,4} = 'PPMS_obj';	% object
data{1,5} = {'Scan (loop) on Temperature values (Kelvin) in PPMS.',...  % hint
             '    Spacing - diffrence of temperature in each iteration.',...
             '    Steps - number of temperatures to be scanned.',...
             '    Rate - approaching rate in each iteration.',...
             'Approaching options:',...
             '    Fast Settle - oscillating aroud target tepmerature, while decaying the oscillation magnitude (feedback loop).',...
             '    No Overshoot - slowly reaching target temperature, while not passing it.'};
data{1,6} = [300, 10, 4];   % default values - initVal, target, rate

data{2,1} = 'Field'; % name
data{2,2} = 'Oe';       % units
data{2,3} = 'FIELD';     % function callback
data{2,4} = 'PPMS_obj';	% object
data{2,5} = {'Scan (loop) on Field values (Oersted) in PPMS.',...  % hint
             '    Spacing - diffrence of field in each iteration.',...
             '    Steps - number of fields to be scanned.',...
             '    Rate - approaching rate in each iteration.',...
             'Approaching options:',...
             '    Linear - the magnetic field ramps linearly to the new field,.',...
             '    No Overshoot - ensures that the magnetic field does not overshoot past the target field.',...
             '    Oscillate - oscillates the magnetic field about the final value through a series of decreasing amplitude oscillations.',...
             };
data{2,6} = [0, 1000, 10];   % default values - initVal, target, rate

data{3,1} = 'Current'; % name
data{3,2} = 'uA';       % units
data{3,3} = 'current';	% function callback
data{3,4} = 'sm_obj';	% object
data{3,5} = {'Scan (loop) on current values (micro-Amps).',...  % hint
             '    Spacing - diffrence of current in each iteration.',...
             '    Steps   - number of currents to be scanned.','';...
             % IV hint
             'IV triggered measuremsnt, ruled by CURRENT (I, micro-Amps)',...
             '    Spacing - diffrence of current in each shot (initial & target values).',...
             '    Steps   - number of currents to be scanned (center & span).','';...
             % Delta hint
             'Delta mode triggered measurement, ruled by CURRENT (I, micro-Amps)',...
             '    Center  - center current.',...
             '    Span    - current span.',...
             '    Repeats - repeats on the measurement.'
             };         
data{3,6} = [-1, 1, 1];   % default values - initVal, target, rate

data{4,1} = 'Voltage'; % name
data{4,2} = 'V';       % units
data{4,3} = 'voltage';     % function callback
data{4,4} = 'sm_obj';	% object
data{4,5} = {'Scan (loop) on voltage values (Volts).',...  % hint
             '    Spacing - diffrence of voltage in each iteration.',...
             '    Steps - number of voltages to be scanned.','';... 
             % IV hint
             'IV triggered measuremsnt, ruled by VOLTAGE (V, volts)',...
             '    Spacing - diffrence of voltage in each shot (initial & target values).',...
             '    Steps   - number of voltages to be scanned (center & span).','';...
             % Delta hint
             'Delta mode triggered measurement, ruled by VOLTAGE (V, volts)',...
             '    Center  - center voltage.',...
             '    Span    - voltage span.',...
             '    Repeats - repeats on the measurement.';...
             % continous measurement
             'Continous measurement of Voltage.','','',''}; 
data{4,6} = [-1, 1, 1];   % default values - initVal, target, rate

set(hObject,'UserData',data);


function edtRateScan_Callback(hObject, eventdata, handles)
% hObject    handle to edtRateScan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in btnOpenPlot.
function btnOpenPlot_Callback(hObject, eventdata, handles)
% hObject    handle to btnOpenPlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in tglSM.
function tglSM_Callback(hObject, eventdata, handles)
% hObject    handle to tglSM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
state = get(hObject,'Value');
if state
    set(hObject,'string','ON');
else
    set(hObject,'string','OFF');
end
% Hint: get(hObject,'Value') returns toggle state of tglSM


% --- Executes on button press in tglPower.
function tglPower_Callback(hObject, eventdata, handles)
% hObject    handle to tglPower (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function tglPower_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tglPower (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
load('cdataShut2');
set(hObject,'cdata',cdata);

% --- Executes on selection change in mnuApproach.
function mnuApproach_Callback(hObject, eventdata, handles)
% hObject    handle to mnuApproach (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
options = get(handles.mnuScan,'userData');
paramflag = get(handles.mnuScan,'value');
unit = options{paramflag,2};
hints = options{paramflag,5};
if paramflag==3 || paramflag==4
    routine = get(hObject,'value');
    set(handles.txtHint,'string',hints(routine,:));
    if routine == 3        % delta is on
        set(handles.btnScan,'string','Delta');
        set(handles.txtRateScan,'Enable','on');
        set(handles.edtRateScan,'Enable','on');
        set(handles.txtInitVal,'string','Center:');
        set(handles.txtTarVal,'string','Span:');
        set(handles.rdoSteps,'enable','off');
        set(handles.rdoSpace,'enable','off');
        set(handles.edtStep,'enable','off');
        set(handles.btnSetup,'visible','on');
        set(handles.edtInitVal,'string','0');
        set(handles.txt_MethodUnit,'Enable','off');
    elseif routine == 4        % continous
        set(handles.btnScan,'string','Measure');
%         set(handles.txtRateScan,'string','Time interval:');
%         set(handles.mnuConfig,'value',3);
%         mnuConfig_Callback(handles.mnuConfig,eventdata,handles);
        unit = 'sec';
        set(handles.txtRateScan,'Enable','off');
        set(handles.edtRateScan,'Enable','off');
        set(handles.txtInitVal,'string','Time interval:');
        set(handles.txtTarVal,'string','Integration Time:');
        set(handles.rdoSteps,'enable','off');
        set(handles.rdoSpace,'enable','off');
        set(handles.edtStep,'enable','off');
        set(handles.btnSetup,'visible','on');
        set(handles.edtInitVal,'string','2');
        set(handles.edtTargetVal,'string','0.02');
        set(handles.btnSetup,'visible','off');
        set(handles.txtRateScan,'Enable','off');
        set(handles.edtRateScan,'Enable','off');
        set(handles.txt_MethodUnit,'Enable','off');
    else
        set(handles.txtRateScan,'Enable','off');
        set(handles.edtRateScan,'Enable','off');
        set(handles.rdoSteps,'enable','on');
        set(handles.rdoSpace,'enable','on');
        set(handles.edtStep,'enable','on');
        set(handles.txt_MethodUnit,'Enable','on');
        switch routine
            case 1  % Normal scan
                set(handles.btnScan,'string','scan');
                set(handles.txtInitVal,'string','Initial Value:');
                set(handles.txtTarVal,'string','Target Value:');
                set(handles.btnSetup,'visible','off');
                set(handles.edtInitVal,'string','-1');
            case 2  % IV is on
                set(handles.btnScan,'string','I-V');
                set(handles.btnSetup,'visible','on');
                space = get(handles.rdoSpace,'value');
                if space
                    set(handles.txtInitVal,'string','Initial Value:');
                    set(handles.txtTarVal,'string','Target Value:');
                    set(handles.edtInitVal,'string','-1');
                else
                    set(handles.txtInitVal,'string','Center:');
                    set(handles.txtTarVal,'string','Span:');
                    set(handles.edtInitVal,'string','0');
                end  
        end  
    end
    set(handles.txt_initValUnit,'string',unit);
    set(handles.txt_finalValUnit,'string',unit);
end
% Hints: contents = cellstr(get(hObject,'String')) returns mnuApproach contents as cell array
%        contents{get(hObject,'Value')} returns selected item from mnuApproach


% --- Executes during object creation, after setting all properties.
function mnuApproach_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mnuApproach (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

data = cell(1,4);
data{1} = {'Fast Settle';'No overshoot'};
data{2} = {'Linear';'No overshoot';'Oscillate'};
data{3} = {'Normal Scan';'I-V measurement';'Delta measurement'};
data{4} = {'Normal Scan';'I-V measurement';'Delta measurement';'Continous measurement'};

set(hObject,'UserData',data);


% --- Executes on selection change in mnuEndMode.
function mnuEndMode_Callback(hObject, eventdata, handles)
% hObject    handle to mnuEndMode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns mnuEndMode contents as cell array
%        contents{get(hObject,'Value')} returns selected item from mnuEndMode


% --- Executes during object creation, after setting all properties.
function mnuEndMode_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mnuEndMode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btnSetup.
function btnSetup_Callback(hObject, eventdata, handles)
% hObject    handle to btnSetup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
routine = get(handles.mnuApproach,'value') - 2;
index = get(handles.CommandList,'value');
if routine % Delta
    add_item_to_list_box(handles.CommandList,'Delta setup',index);
    add_command_str({'deltaSetup(nv_obj,sm_obj);    % Delta setup';...
                     'dI = []; dV = []; dR = [];    % preallocation - Keithley';...
                     'T = []; H = [];    % preallocation - PPMS'},index);
    
else    % IV
    add_item_to_list_box(handles.CommandList,'IV setup',index);
    add_command_str({'setupIV(nv_obj,sm_obj);    % IV setup';...
                     'I = []; V = [];    % preallocation - Keithley';...
                     'T = []; H = [];    % preallocation - PPMS'},index);
end


% --- Executes on button press in btnPPMSdata.
function btnPPMSdata_Callback(hObject, eventdata, handles)
% hObject    handle to btnPPMSdata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
index = get(handles.CommandList,'value');
add_item_to_list_box(handles.CommandList,'Read PPMS data',index);
add_command_str({'[data] = ReadPPMSdata(PPMS_obj,[1,2]);    % PPMS data';...
            'T(end+1)=data(1);';'H(end+1)=data(2);'},index);



% --- Executes on selection change in mnuConfigParam.
function mnuConfigParam_Callback(hObject, eventdata, handles)
% hObject    handle to mnuConfigParam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns mnuConfigParam contents as cell array
%        contents{get(hObject,'Value')} returns selected item from mnuConfigParam


% --- Executes during object creation, after setting all properties.
function mnuConfigParam_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mnuConfigParam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btnSaveMeas.
function btnSaveMeas_Callback(hObject, eventdata, handles)
% hObject    handle to btnSaveMeas (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
FileName = get(handles.edtSaveMeas,'String');  % get the desired filename
strrep(FileName,'.mat','');
% [FileName,dir] = uiputfile('*.mat','Save Measurements',FileName);
dir = uigetdir('','Select Directory to Save Measurements');
if ~dir
%     errordlg('No directory was chosen');
    return;
end
index = get(handles.CommandList,'value');
comStr = ['Save file named ''',FileName,'.mat',''' at directory ''',dir,''''];
add_item_to_list_box(handles.CommandList,comStr,index);
FileName = [dir,FileName];
saveStr = 'eval([''save('','''''''',FileName,''.mat'','''''''','');''])';
% saveStr = 'save(['''''''',FileName,''.mat'','''''''']);';
FileNameStr = 'FileName = filenameReplace(FileName1,''T'',Temp(Tind),''H'',Fiel(Find));';
add_command_str({['FileName1 = ''',FileName,''';    % original File Name'];...
            [FileNameStr,'    % Replace file name <>'];saveStr},index);
set(handles.CommandList,'value',1);
btnAllo_Callback(handles.btnAllo,eventdata,handles);
set(handles.CommandList,'value',index);


function edtSaveMeas_Callback(hObject, eventdata, handles)
% hObject    handle to edtSaveMeas (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edtSaveMeas as text
%        str2double(get(hObject,'String')) returns contents of edtSaveMeas as a double


% --- Executes during object creation, after setting all properties.
function edtSaveMeas_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edtSaveMeas (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edtPause_Callback(hObject, eventdata, handles)
% hObject    handle to edtPause (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
currChar = get(handles.figure1,'CurrentCharacter');
if isequal(currChar,char(13)) %char(13) == enter key
   %call the pushbutton callback
   btnWait_Callback(hObject, eventdata, handles);
end
% Hints: get(hObject,'String') returns contents of edtPause as text
%        str2double(get(hObject,'String')) returns contents of edtPause as a double


% --- Executes during object creation, after setting all properties.
function edtPause_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edtPause (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in mnuWait4param.
function mnuWait4param_Callback(hObject, eventdata, handles)
% hObject    handle to mnuWait4param (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
choice = get(hObject,'value');
waitind = get(handles.mnuWait,'value');
if waitind==4 || waitind ==5
    set(handles.mnuConfig,'value',choice+3);
    mnuConfig_Callback(handles.mnuConfig,eventdata,handles);
end
% Hints: contents = cellstr(get(hObject,'String')) returns mnuWait4param contents as cell array
%        contents{get(hObject,'Value')} returns selected item from mnuWait4param


% --- Executes during object creation, after setting all properties.
function mnuWait4param_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mnuWait4param (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btnWait.
function btnWait_Callback(hObject, eventdata, handles)
% hObject    handle to btnWait (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
choice = get(handles.mnuWait,'value');
switch choice
    case 1
        Waiting_time = get(handles.edtPause, 'String');
        index_selected = get(handles.CommandList, 'Value');
        add_item_to_list_box(handles.CommandList, ['Pause ',Waiting_time, ' [sec]' ], index_selected);
        add_command_str(['pause(',Waiting_time,');'],index_selected);
    case 2
        paramflag = get(handles.mnuWait4param,'Value');
        Options = get(handles.mnuWait4param,'String');
        switch paramflag
            case 1
                functionStr = 'wait4temp(PPMS_obj);';
            case 2
                functionStr = 'wait4field(PPMS_obj);';
        end
        commandStr = ['Wait for ',Options{paramflag}];
        index = get(handles.CommandList,'Value');
        add_item_to_list_box(handles.CommandList,commandStr,index);
        % update commands in script
        add_command_str([functionStr,'  % ',commandStr],index);
    case 3
        paramflag = get(handles.mnuWait4param,'Value');
        Options = get(handles.mnuWait4param,'String');

        commandStr = ['While ',Options{paramflag},' is reaching to its stable value, do:'];
        index = get(handles.CommandList,'Value');
        add_item_to_list_box(handles.CommandList,commandStr,index);
        add_item_to_list_box(handles.CommandList,'end',index+1);
        % update commands in script
        ind = num2str(get(handles.mnuWait4param,'value'));
        whileStr = {'[Status, StatusTXT] = ReadPPMSstatus(PPMS_obj);    % Read status';...
                    ['while Status(',ind,')~=1 && Status(',ind,')~=4    % while ',Options{paramflag},' not stable']};
        add_command_str(whileStr,index);
        endStr = {'[Status, StatusTXT] = ReadPPMSstatus(PPMS_obj);    % Read status';'end'};
        add_command_str(endStr,index+1);
end


% --- Executes on selection change in mnuWait.
function mnuWait_Callback(hObject, eventdata, handles)
% hObject    handle to mnuWait (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
choice = get(handles.mnuWait,'value');
data = get(handles.mnuWait,'userData');
set(handles.txtHint,'string',data{choice,2});    % set hint
switch choice
    case 1
        set(handles.mnuWait4param,'visible','off');
    case {2,3}
        set(handles.mnuWait4param,'visible','on');
    case{4,5}
        set(handles.mnuWait4param,'visible','on');
        mnuWait4param_Callback(handles.mnuWait4param,eventdata,handles);
end

% --- Executes during object creation, after setting all properties.
function mnuWait_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mnuWait (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

data = cell(5,2);

data{1,1} = 'Pause'; % name
data{1,2} = {'Pauses the measurement for specified time interval (seconds).'};

data{2,1} = 'Wait for'; % name
data{2,2} = {'Wait for PPMS parameter (Temperature/Field) to be stabilized.'};

data{3,1} = 'While - do'; % name
data{3,2} = ['Executes while loop - while PPMS parameter (Temperature/Field) is being stabilized. ',...
    'Set parameter interval (dT,dH) in the settings panel.'];         

data{4,1} = 'Fast Wait for'; % name
data{4,2} = {'Fast, Wait for PPMS parameter (Temperature/Field) to be stabilized.'};

data{5,1} = 'Fast While - do'; % name
data{5,2} = ['Fast, Executes while loop - while PPMS parameter (Temperature/Field) is being stabilized. ',...
            'Set parameter interval (dT,dH) in the settings panel.']; 

set(hObject,'UserData',data);


% --- Executes on button press in btnSendMail.
function btnSendMail_Callback(hObject, eventdata, handles)
% hObject    handle to btnSendMail (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiwait(mailGUI);  % open and wait for channel  selection
try
    mailAd = getappdata(0,'mailAd');
    mailSub = strtrim(getappdata(0,'mailSub'));
    mailContent = getappdata(0,'mailContent');
catch
    errordlg('Mail Window interrupted');
    return;
end
cellContent = cellstr(mailContent);
mailContent = strjoin(cellContent','/\');
index = get(handles.CommandList,'value');
add_item_to_list_box(handles.CommandList,['Send mail to ',mailAd,' ; Subject: ',mailSub],index);
% sendStr = ['SendGmailPPMS(''',mailAd,''',''',mailSub,''',''',mailContent,''');'];
sendStr = {['mailContent = strrep(''',mailContent,''',''/\'',char(13));'] ;['SendGmailPPMS(''',mailAd,''',''',mailSub,''',mailContent);']};
add_command_str(sendStr,index);



% --- Executes on selection change in CommandList.
function CommandList_Callback(hObject, eventdata, handles)
% hObject    handle to CommandList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hintStr = {'Keyboard Shortcuts:';'  Del - delete';'  ''w'' - move up';'  ''s'' - move down';...
    '  ''c'' - copy';'  ''v'' - paste'};
set(handles.txtHint,'string',hintStr);
% Hints: contents = cellstr(get(hObject,'String')) returns CommandList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from CommandList


% --- Executes on button press in btnAllo.
function btnAllo_Callback(hObject, eventdata, handles)
index = get(handles.CommandList,'value');
add_item_to_list_box(handles.CommandList,'Data Allocation',index);
add_command_str({'T = []; H = [];    % PPMS data preallocation';...
                 'I = []; V = [];    % IV measurement data preallocation';...
                 'dV = []; dI = []; dR = []; % Delta measurement data preallocation';...
                 'Vcont = [];        % V continous';},index);
% hObject    handle to btnAllo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
