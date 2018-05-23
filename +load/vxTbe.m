function M = vxTbe(N)
%% LOAD.VXTBE: load a 4D NifTi into a 2D (voxel x time) matrix
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
%  VERSION:  0.0 CREATED: 19-May-2018 22:07:51
%
%% INPUTS:
%    N - Path to nii (char)
%
%
%% OUTPUT:
%    M - 2D matrix    
%
%% EXAMPLES:
%
%  M=vxTbe(N)
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

N=nifti(N);
sz=N.dat.dim;
M=reshape(N.dat(:),prod(sz(1:3)),sz(4));




%------------- END OF CODE --------------
