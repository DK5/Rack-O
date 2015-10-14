function varargout = my_dialog(varargin)
% my_dialog MATLAB code for my_dialog.fig
%
%      my_dialog, by itself, creates a new my_dialog or raises the existing
%      singleton*.
%      Code for Code Verification my_dialog before sending it to the ppMS.
%      H = my_dialog returns the handle to a new my_dialog or the handle to
%      the existing singleton*.
%
%      my_dialog('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in my_dialog.M with the given input arguments.
%
%      my_dialog('Property','Value',...) creates a new my_dialog or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before my_dialog_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to my_dialog_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help my_dialog

% Last Modified by GUIDE v2.5 06-Sep-2015 12:06:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @my_dialog_OpeningFcn, ...
                   'gui_OutputFcn',  @my_dialog_OutputFcn, ...
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


% --- Executes just before my_dialog is made visible.
function my_dialog_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to my_dialog (see VARARGIN)

% Choose default command line output for my_dialog
handles.output = hObject;

FileName=getappdata(0,'FileName');   %get the filename of wanted file containing commands

btn=getappdata(0,'Button');
setappdata(0,'Source',btn);
switch btn
    case 'Choose'
        FileName=getappdata(0,'FileName');
        txt_to_print=fileread(FileName);
    case 'Execute'
        txt_to_print=getappdata(0,'listbox_contents');
end
set(handles.text2,'String', txt_to_print); %display contents
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes my_dialog wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = my_dialog_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%send contents to ppms%
source=getappdata(0,'Source')
switch source
    case 'Choose' %User wants to run a pre-written file
        FileName=getappdata(0,'FileName');
        type FileName;  %when time's come, remove the 'type' and just run the file
    case 'Execute'  %user wants to execute the current sequence
        txt_to_print=getappdata(0,'listbox_contents');
end
msgbox('Commands sent!','Attention','Warn');
uiwait;  %wait for user to click ok in msgbox
close; %close the window


% --- Executes during object creation, after setting all properties.
function text1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over text1.
function text1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to text1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
