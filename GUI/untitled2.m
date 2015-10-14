function varargout = untitled2(varargin) 
% untitled2 M-file for untitled2.fig
%      untitled2, by itself, creates a new untitled2 or raises the existing
%      singleton*.
%
%      H = untitled2 returns the handle to a new untitled2 or the handle to
%      the existing singleton*.
%
%      untitled2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in untitled2.M with the given input arguments.
%
%      untitled2('Property','Value',...) creates a new untitled2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before untitled2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to untitled2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help untitled2

% Last Modified by GUIDE v2.5 12-Oct-2015 16:51:43

% Begin initialization code - DO NOT EDIT
%clear all
%close all   %CLEANUP
%clc
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @untitled2_OpeningFcn, ...
                   'gui_OutputFcn',  @untitled2_OutputFcn, ...
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


% --- Executes just before untitled2 is made visible.
function untitled2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to untitled2 (see VARARGIN)

% Choose default command line output for untitled2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes untitled2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = untitled2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Set_Field.
function Set_Field_Callback(hObject, eventdata, handles)
% hObject    handle to Set_Field (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
          

Destination_field = get(handles.txt_Stop_field, 'String');
index_selected = get(handles.listbox1, 'Value');
rate=get(handles.mf_rate_edit, 'String');

%index_selected = get(handles.listbox1, 'Value');

%list = get(handles.listbox1,'String'); %Get the cell array
%item_selected = list{index_selected}; 

method=cellstr(get(handles.set_mf_popup,'string'));
method=method{get(handles.set_mf_popup,'Value')};
%scan field step size check
current_field = str2num(get(handles.H_text_status, 'String'));
Stop_Field = str2num(get(handles.txt_Stop_field, 'String'));
rate = str2num(get(handles.mf_rate_edit, 'String'));
if(rate<=10.0)
    errordlg('Rate must be bigger than 10!','Error 0x001')
    set(handles.mf_rate_edit,'String',10);
    return
elseif(rate>187)
    errordlg('Rate must be smaller that 187!','Error 0x005')
    set(handles.mf_rate_edit,'String',187);
    return
end
add_item_to_list_box(handles.listbox1, ['Set field ',Destination_field, ' [Oe]' ,', while using:', method, ', at rate of ',rate,' [Oe/sec]'], index_selected);


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

index_selected = get(handles.listbox1, 'Value');
add_item_to_list_box(handles.listbox1, 'End' , index_selected);
add_item_to_list_box(handles.listbox1, ['Scan field from ',Start_Field, ' [Oe] to ', Stop_Field, ' [Oe] in ', Num_of_steps, ' steps'], index_selected);
%add_item_to_list_box(handles.listbox1, 'End' , index_selected+1);


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

%index_selected = get(handles.listbox1, 'Value')
%add_item_to_list_box(handles.listbox1, 'moty',index_selected);

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
         newstring = {oldstring newitem};
    else
        newstring = {oldstring{:} newitem};
    end
    set(h, 'string', newstring);

function h = add_item_to_list_box(h, newitem, index)
% ADDITEMTOLISTBOX - add a new items to the listbox
% H = ADDITEMTOLISTBOX(H, STRING)
% H listbox handle
% STRING a new item to display

    oldstring = get(h, 'string'); %Get the cell array from the listbox. 
    
    space = 0;
    for i=1:(index-1) %%Move right the text according to the loops
        item_selected = oldstring{i};
        L=length(item_selected);
        if L>(4+space)
           if strcmp(item_selected((1+space):(4+space)), 'Scan')
             space = space +3;
           end
        elseif L==(3+space)
           if strcmp(item_selected((1+space):(3+space)), 'End')
             space = space -3;
           end
        end
   end
    
    for j=1:space
        newitem = [' ', newitem];
    end
     
    if isempty(oldstring)
        newstring = {newitem};
%     elseif ~iscell(oldstring)
%          newstring = {oldstring newitem};
    else
        newstring = {oldstring{1:(index-1)}   newitem     oldstring{index:end}}; %Create the new cell array for the list box
    end
    set(h, 'string', newstring); %Set the new cell array to the list box

function h = del_item_from_list_box(h, index)
% del_item_from_list_box - removes items to the listbox
% H = del_item_from_list_box(H, index)
% H listbox handle
% index - index to remove 
% STRING a new item to display

    oldstring = get(h, 'string');
    if strcmp(oldstring{index},'End')
        errordlg('Cannot delete End statement!','Error 0x004');
        return
    elseif strcmp(oldstring{index},'End Sequence')
        errordlg('Cannot delete End Sequence statement!','Error 0x005');
        return
    end
    L=length(oldstring);
    if isempty(oldstring)
    elseif index==L 
    else
        newstring = {oldstring{1:(index-1)} oldstring{index+1:end}};
        set(h, 'string', newstring);
    end
        
% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

set(hObject, 'String', {'End sequence'});



% --- Executes on button press in Set_wait.
function Set_wait_Callback(hObject, eventdata, handles)
% hObject    handle to Set_wait (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Waiting_time = get(handles.txt_waiting_time, 'String');
index_selected = get(handles.listbox1, 'Value');
add_item_to_list_box(handles.listbox1, ['Wait ',Waiting_time, ' [sec]' ], index_selected);




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


% --- Executes on button press in btn_Set_del_line.
function btn_Set_del_line_Callback(hObject, eventdata, handles)
% hObject    handle to btn_Set_del_line (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

index_selected = get(handles.listbox1, 'Value');

del_item_from_list_box(handles.listbox1,index_selected);



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


% --- Executes on button press in btn_set_remark.
function btn_set_remark_Callback(hObject, eventdata, handles)
% hObject    handle to btn_set_remark (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Remark = get(handles.txt_remark, 'String');
index_selected = get(handles.listbox1, 'Value');

list = get(handles.listbox1,'String');
item_selected = list{index_selected} 


add_item_to_list_box(handles.listbox1, ['%%%  ', Remark, '  %%%' ], index_selected);


function txt_remark_Callback(hObject, eventdata, handles)
% hObject    handle to txt_remark (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_remark as text
%        str2double(get(hObject,'String')) returns contents of txt_remark as a double


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
initialize_gui(gcbf, handles, true);

function initialize_gui(hObject, handles, isreset)
% function used to reset all properies of gui

set(handles.txt_Stop_field,'String','100');  %Reset all H fields
set(handles.mf_rate_edit,'String','10');

set(handles.target_temp_edit,'String', '290');
set(handles.temp_rate_edit, 'String','12');      %Reset TEMP fields

set(handles.txt_remark,'String','');   %Reset REMARK Field

set(handles.txt_waiting_time,'String','1');    %Reset WAIT TIME field

set(handles.listbox1, 'String', {'End sequence'});  %Reset LISTBOX

set(handles.file_name_edit,'String', 'Enter File name'); %Reset filename field

set(handles.graph_popup,'Value',1);
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

contents = get(handles.listbox1,'String'); %extract all contents of listbox as cell array

FileName=get(handles.file_name_edit,'String');  %get the desired filename

if strcmp(FileName,'Enter File name')    %make sure the user has entered a filename
     errordlg('Please Enter a File Name!','Error 0x003');  %user didnt
    return
end
FID = fopen([FileName,'.m'],'w');   
formatSpec = '%s\r\n';
[nrows,ncols] = size(contents);
for row = 1:nrows
    fprintf(FID,formatSpec,contents{row,:});   %write list in file - REWRITES EXISTING
end                                            %to change, change w in fopen to a

fclose(FID);
% type commands.m   %show the file
msgbox('File Saved.','Attention','Help');


% --- Executes on button press in execute_code_button.
function execute_code_button_Callback(hObject, eventdata, handles)
% Executes CURRENT code without file selection
% hObject    handle to execute_code_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


contents = get(handles.listbox1,'String');
setappdata(0,'listbox_contents',contents);
setappdata(0,'Button','Execute'); %let dialog know what button is calling it
varargout = my_dialog(figure(my_dialog)); %calls verification dialog
%excecution function goes here



% --- Executes during object creation, after setting all properties.
function execute_code_button_CreateFcn(hObject, eventdata, handles)
% hObject    handle to execute_code_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on selection change in graph_popup.
function graph_popup_Callback(hObject, eventdata, handles)
% hObject    handle to graph_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns graph_popup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from graph_popup
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
function graph_popup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to graph_popup (see GCBO)
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
varargout = my_dialog(figure(my_dialog));   %open verification my_dialog


% --- Executes on selection change in chamber_mode_popup.
function chamber_mode_popup_Callback(hObject, eventdata, handles)
% hObject    handle to chamber_mode_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns chamber_mode_popup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from chamber_mode_popup


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



function temp_rate_edit_Callback(hObject, eventdata, handles)
% hObject    handle to temp_rate_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of temp_rate_edit as text
%        str2double(get(hObject,'String')) returns contents of temp_rate_edit as a double

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
index_selected = get(handles.listbox1, 'Value');
rate=str2num(get(handles.temp_rate_edit, 'String'));

%index_selected = get(handles.listbox1, 'Value');

%list = get(handles.listbox1,'String'); %Get the cell array
%item_selected = list{index_selected}; 

method=cellstr(get(handles.temprature_approach_popup,'string'));
method=method{get(handles.temprature_approach_popup,'Value')};
%rate size check 
 if(rate<=0.0)
    errordlg('Rate must be bigger than 0! Are you dumb?','Error 0x006')
    set(handles.mf_rate_edit,'String',0);
    return
elseif(rate>12)
    errordlg('Rate must be smaller that 12!','Error 0x007')
    set(handles.mf_rate_edit,'String',12);
    return
 end
rate=num2str(rate);
add_item_to_list_box(handles.listbox1, ['Set Temprature ',Destination_temp, ' [°K]' ,', while using:', method, ', at rate of ',rate,' [°K/sec]'], index_selected);


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


