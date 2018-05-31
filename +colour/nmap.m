function M = nmap(N,I,P)
%% COLOUR.NMAP: LookUp N maximally different colour codes. 
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
%  EMAIL:  r.daws@imperial.ac.uk
%  AFFILIATION:  Imperial College London
%  VERSION:  0.0 CREATED: 31-May-2018 13:48:53
%
%% INPUTS:
%    N - Number of colour codes required (Max=64)
%    I - idx of desired colour(s) (Max=64)
% 
%  OPTIONAL
%    P - Pallete type desired, defualt='rgb' {'rgb','hsv'}
%
%% OUTPUT:
%    M - Nx3 colour map
%
%% EXAMPLES:
%    M = nmap(10);
%

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
C=load('+colour/C.mat');C=C.C/255;
if ~exist('P','var');P='rgb'; end
if ~exist('I','var');I=1:N;end

switch P 
    case 'rgb';M=C(I,:);
    case 'hsv';M=rgb2hsv(C(I,:));
end

%Reference:http://godsnotwheregodsnot.blogspot.com/2012/09/color-distribution-methodology.html
%------------- END OF CODE --------------
end