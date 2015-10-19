function [ isShort ] = cutShort( cs_obj )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

res = oneShot(cs_obj,'r');    
if res < 1e6
        isShort = 1;
    else
        isShort = 0;
end