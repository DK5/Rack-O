function timer_function
%Function that contains all Live Data functions for pulling information
%about the ppms.
% Function will return a structure with 6 fields:
% output.Pressure - will contain the current pressure in the chamber
% output.TempQ - will contain QUERY INFORMATION (set, rate and approach) regarding the temprature
% output.Temp - will contain current temprature via ReadPPMSData
% output.FieldQ - will contain QUERY INFORMATION (set, rate, approach and MagnetMode) regarding the magnetic field
% output.Field - will contain current magnetic field via ReadPPMSData
% output.ChamberQ - will contain QUERY information about current chamber valving status
handles = getappdata(0,'handles');
fclose(handles.PPMSObj);
fopen(handles.PPMSObj);
%Queries
output.ChamberQ=ChamberQ(handles.PPMSObj);
output.FieldQ=FieldQ(handles.PPMSObj);
output.TempQ=TempQ(handles.PPMSObj);
%Data
output.Pressure=ReadPPMSdata(handles.PPMSObj,5);
output.Temp=ReadPPMSdata(handles.PPMSObj,1);
output.Field=ReadPPMSdata(handles.PPMSObj,2);
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
% guidata(hObject, handles);  %update data
%se tu

setappdata(0,'handles',handles)
end
