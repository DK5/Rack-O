function timerfunction01
handles=getappdata(0,'handles');

fclose(handles.PPMSObj);
fopen(handles.PPMSObj);
set(handles.text1,'String', num2str(ReadPPMSdata(handles.PPMSObj,1)))
setappdata(0,'handles',handles)
