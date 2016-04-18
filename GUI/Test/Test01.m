function varargout = Test01(varargin)
% TEST01 MATLAB code for Test01.fig
%      TEST01, by itself, creates a new TEST01 or raises the existing
%      singleton*.
%
%      H = TEST01 returns the handle to a new TEST01 or the handle to
%      the existing singleton*.
%
%      TEST01('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TEST01.M with the given input arguments.
%
%      TEST01('Property','Value',...) creates a new TEST01 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Test01_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Test01_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Test01

% Last Modified by GUIDE v2.5 27-Mar-2016 15:46:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Test01_OpeningFcn, ...
                   'gui_OutputFcn',  @Test01_OutputFcn, ...
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


% --- Executes just before Test01 is made visible.
function Test01_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Test01 (see VARARGIN)

% Choose default command line output for Test01
handles.output = hObject;
handles.PPMSObj = GPcon(15,2); % connect to ppms
% set(handles.text1,'String', num2str(ReadPPMSdata(handles.PPMSObj,1)))
setappdata(0,'handles',handles)
% declare timer
mainTimer = timer;
mainTimer.Name = 'Main GUI Timer';
mainTimer.ExecutionMode = 'fixedRate';
mainTimer.Period = 0.5;
mainTimer.TimerFcn = 'timerfunction01';
mainTimer.StartDelay = 1.5;
start(mainTimer);
fclose(handles.PPMSObj);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Test01 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Test01_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

