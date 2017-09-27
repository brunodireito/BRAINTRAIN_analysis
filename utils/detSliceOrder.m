function [ type , pathString ] = detSliceOrder( timeVector )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
% Scan order 0 -> Ascending, 1 -> Asc-Interleaved, 2 -> Asc-Int2,
% 10 -> Descending, 11 -> Desc-Int, 12 -> Desc-Int2

[~,order] = sort(timeVector);

if all(diff(order)>0) %Ascending
    type = 0;
    pathString = 'SCCA';
elseif all(diff(order)<0) %Descending
    type = 10;
    pathString = 'SCCD';
elseif (order(1)==1) %Ascending Interleaved
    type = 1;
    pathString = 'SCCAI';
elseif (order(end)==1) %Descending Interleaved
    type = 11;    
    pathString = 'SCCDI';
elseif (order(1)==2) %Ascending Interleaved 2
    type = 2;
    pathString = 'SCCAI2';
elseif (order(end)==2) %Descending Interleaved 2
    type = 12;    
    pathString = 'SCCDI2';
else
    type = -1;
end

end

