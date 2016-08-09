function varargout = mailGUI(varargin)
% MAILGUI MATLAB code for mailGUI.fig
%      MAILGUI, by itself, creates a new MAILGUI or raises the existing
%      singleton*.
%
%      H = MAILGUI returns the handle to a new MAILGUI or the handle to
%      the existing singleton*.
%
%      MAILGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAILGUI.M with the given input arguments.
%
%      MAILGUI('Property','Value',...) creates a new MAILGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before mailGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to mailGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help mailGUI

% Last Modified by GUIDE v2.5 09-Aug-2016 13:52:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mailGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @mailGUI_OutputFcn, ...
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


% --- Executes just before mailGUI is made visible.
function mailGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to mailGUI (see VARARGIN)

% Choose default command line output for mailGUI
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes mailGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = mailGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edtContent_Callback(hObject, eventdata, handles)
% hObject    handle to edtContent (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edtContent as text
%        str2double(get(hObject,'String')) returns contents of edtContent as a double


% --- Executes during object creation, after setting all properties.
function edtContent_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edtContent (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edtMailAd_Callback(hObject, eventdata, handles)
% hObject    handle to edtMailAd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edtMailAd as text
%        str2double(get(hObject,'String')) returns contents of edtMailAd as a double


% --- Executes during object creation, after setting all properties.
function edtMailAd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edtMailAd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edtSub_Callback(hObject, eventdata, handles)
% hObject    handle to edtSub (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edtSub as text
%        str2double(get(hObject,'String')) returns contents of edtSub as a double


% --- Executes during object creation, after setting all properties.
function edtSub_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edtSub (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btnSend.
function btnSend_Callback(hObject, eventdata, handles)
% hObject    handle to btnSend (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mailAd = get(handles.edtMailAd,'string');
setappdata(0,'mailAd',mailAd);
mailSub = get(handles.edtSub,'string');
setappdata(0,'mailSub',mailSub);
mailContent = get(handles.edtContent,'string');
setappdata(0,'mailContent',mailContent);
close(mailGUI);
