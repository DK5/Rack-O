function varargout = ChannelMatrixV2(varargin)
% CHANNELMATRIXV2 MATLAB code for ChannelMatrixV2.fig
%      CHANNELMATRIXV2, by itself, creates a new CHANNELMATRIXV2 or raises the existing
%      singleton*.
%
%      H = CHANNELMATRIXV2 returns the handle to a new CHANNELMATRIXV2 or the handle to
%      the existing singleton*.
%
%      CHANNELMATRIXV2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CHANNELMATRIXV2.M with the given input arguments.
%
%      CHANNELMATRIXV2('Property','Value',...) creates a new CHANNELMATRIXV2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ChannelMatrixV2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ChannelMatrixV2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ChannelMatrixV2

% Last Modified by GUIDE v2.5 25-Oct-2015 13:05:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ChannelMatrixV2_OpeningFcn, ...
                   'gui_OutputFcn',  @ChannelMatrixV2_OutputFcn, ...
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


% --- Executes just before ChannelMatrixV2 is made visible.
function ChannelMatrixV2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ChannelMatrixV2 (see VARARGIN)
clc
% Choose default command line output for ChannelMatrixV2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ChannelMatrixV2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ChannelMatrixV2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1
YAxis = 3:15;
XAxis = 1:6;
% ax = get(gca);
CH_label = num2str((YAxis-1)','%02d');
X_label = {'I+','I-','V1+','V1-','V2+','V2-'};
fontSize = 10;

set(hObject,'XAxisLocation','top');
set(hObject,'YDir','reverse');
set(hObject,'YTick',(XAxis)');
set(hObject,'YTick',(YAxis)');
set(hObject,'XTickLabel',X_label);
set(hObject,'YTickLabel',CH_label);
set(hObject,'FontSize',fontSize);
axis([min(XAxis) max(XAxis) min(YAxis) max(YAxis)] + 0.5);

for i = XAxis
    for j = YAxis

        xp = [i i+1 i+1 i] + 0.5;
        yp = [j j j+1 j+1] + 0.5;
           
        patch(xp,yp,'white');

    end
end

% --- Executes on mouse press over axes background.
function axes1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[x,y] = ginput
x = floor(x);
y = floor(y);
xp = [x x+1 x+1 x] + 0.5;
yp = [y y y+1 y+1] + 0.5;
           
patch(xp,yp,'blue');