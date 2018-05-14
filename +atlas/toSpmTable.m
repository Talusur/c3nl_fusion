function T = toSpmTable(S,L,G,A,H)
%% ATLAS.TOSPMTABLE: Create a table of ROI coordinates, labels & statistics (typically from an SPM)
%
%   __           _             
%  / _|         (_)            
% | |_ _   _ ___ _  ___  _ __    
% |  _| | | / __| |/ _ \| `_ \    :- Functional and Structural 
% | | | |_| \__ \ | (_) | | | |      Integration of Neuroimages
% |_|  \__,_|___/_|\___/|_| |_|
%
%
%% AUTHOR:  Richard Daws
%  EMAIL:  rdaws@ic.ac.uk
%  AFFILIATION:  Imperial College London
%  VERSION:  0.0 CREATED: 12-May-2018 17:34:36
%
%% INPUTS:
%    S - 3d matrix to mine
%    L - a 3d label map matrix 
%    G - grid object of that map
%    A - Cell array of atlases (One of, or any combination of):
%        'AAL2','WFU','Yeo7','Yeo17','HO_CS','Shiver2012','Cerb'
%  OPTIONAL  
%    H - Cell array of table hdrs, see atlas.toTable.
% 
%  ABOUT 
%    This function is for producing a 'report style' table that contains
%    typically reported information around ROI in functional contrasts. 
%      
%    This function heavily relies on atlas.toTable.  
% 
%% OUTPUT:
%    T - A table containing anatomical, XYZ & statistical information for 
%        each ROI. 
%
%% EXAMPLES:
%
%    T = toSpmTable(L,G,A,S,H);

%% DEPENDENCIES:
%
% This file is part of Fusion Pipeline
% Fusion Pipeline is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% Fusion Pipeline is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with Fusion Pipeline.If not, see <http://www.gnu.org/licenses/>.
%------------- BEGIN CODE --------------
%
%
tS=[]; % Preall stat var
T=table(); % Preall output
t=atlas.toTable(L,G,A); % Pull table with prespecified anatomical atlases
A=strcat('name_',A); % Append atlases with 'name_'
if ~exist('H','var'); H={A{:},'X','Y','Z','Volume'};else; H={A{:} H{:}};end % Append atlas names to hdr
% Extract each table column in the predefind order
for ii=1:numel(H);T=[T t(:,ismember(t.Properties.VariableNames,H{ii}))];end
% Pull stats from underlying statistical image
for ii=1:numel(unique(L(L>0)));tS=[tS;[max(S(L==ii)) mean(S(L==ii)) std(S(L==ii))]];end
% Concatenate stats to output table
T=[T array2table(tS,'VariableNames',{'Peak','Mean','SD'})];
%------------- END OF CODE --------------
