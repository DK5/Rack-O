function varargout = ChannelMatrix(varargin)
% CHANNELMATRIX MATLAB code for ChannelMatrix.fig
%      CHANNELMATRIX, by itself, creates a new CHANNELMATRIX or raises the existing
%      singleton*.
%
%      H = CHANNELMATRIX returns the handle to a new CHANNELMATRIX or the handle to
%      the existing singleton*.
%
%      CHANNELMATRIX('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CHANNELMATRIX.M with the given input arguments.
%
%      CHANNELMATRIX('Property','Value',...) creates a new CHANNELMATRIX or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ChannelMatrix_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ChannelMatrix_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ChannelMatrix

% Last Modified by GUIDE v2.5 14-Oct-2015 14:42:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ChannelMatrix_OpeningFcn, ...
                   'gui_OutputFcn',  @ChannelMatrix_OutputFcn, ...
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


% --- Executes just before ChannelMatrix is made visible.
function ChannelMatrix_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ChannelMatrix (see VARARGIN)
clc
% Choose default command line output for ChannelMatrix
handles.output = hObject;
%CONNECT TO SWITCHER
%matrixes=zeros(12,6,26);

%setappdata(0,'Matrixes',matrixes);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ChannelMatrix wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ChannelMatrix_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes when selected cell(s) is changed in uitable1.
function uitable1_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to uitable1 (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
% --- Executes when selected cell(s) is changed in uitable1.

currow = eventdata.Indices(1);
curcol = eventdata.Indices(2);
adata=get(handles.uitable1,'Data');
if adata{currow,curcol} == 'V'
    adata{currow,curcol} = '';
else 
    adata{currow,curcol} = 'V';
end
    
set(hObject,'Data',adata);


% --- Executes on button press in cls_ch.
function cls_ch_Callback(hObject, eventdata, handles)
% hObject    handle to cls_ch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
index_selected = getappdata(0,'index_selected');  %get the number of selected item in listbox
matrixes = getappdata(0,'matrixes'); %get current selection of measurments
table = get(handles.uitable1,'data'); %get the selected channels for this measure
for i=3:14
    for j=1:6
        if table(i,j)=='V'
            matrixes(i,j,index_selected)='V'; %preform scan and check - add to matrixes selcted values
        end
    end
end
%save changes
set(handles.uitable3,'Data',matrixes(:,:,index_selected)); 
setappdata(0,'matrixes',matrixes);
guidata(hObject, handles);


% --- Executes on button press in opn_ch.
function opn_ch_Callback(hObject, eventdata, handles)
% hObject    handle to opn_ch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in opn_all.
function opn_all_Callback(hObject, eventdata, handles)
% hObject    handle to opn_all (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in clr_selection_btn.
function clr_selection_btn_Callback(hObject, eventdata, handles)
% hObject    handle to clr_selection_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1

index_selected=get(hObject,'Value');
setappdata(0,'index_selected',index_selected);


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

