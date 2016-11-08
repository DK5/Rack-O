% This function interpolates a sorted block that was measured by the PPMS
% and the Keithleys. 
% *** Assuming the PPMS is measuring when the Keithleys aren't and vice versa.
% The funciton will interpolate the PPMS data to match the Keithleys data
% and then DELETE the PPMS data that is assumed to have no Keithleys data
% in that time signiture.

function [Block]=InterpBlock(sortData)
TimeSig=sortData(:,1);
PPMSdata=sortData(:,2:3);
% kData=sortData(:,4:6);
indx=isnan(PPMSdata(:,1))~=1;
PPMStime=TimeSig(indx);
PPMSdata=PPMSdata(indx,:);
PPMSdata_interp=interp1(PPMStime,PPMSdata,TimeSig,'pchip');
sortData(:,2:3)=PPMSdata_interp;
Block=sortData(isnan(sortData(:,4))~=1,:);
% plot(PPMStime,PPMSdata,'o',TimeSig,PPMSdata_interp)