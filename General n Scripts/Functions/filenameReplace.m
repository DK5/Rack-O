function [ newName ] = filenameReplace( filename, varargin )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

if isempty(varargin)
    newName = filename;
    return;
end

newName = filenameReplace(strrep(filename,['<' varargin{1} '>'], num2str(varargin{2})), varargin{3:end});
end