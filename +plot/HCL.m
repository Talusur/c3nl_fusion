function out=HCL(X,I)
%% PLOT.SIMPLEHCL: One line description of what the function or script performs
%
%   __           _             
%  / _|         (_)            
% | |_ _   _ ___ _  ___  _ __    
% |  _| | | / __| |/ _ \| `_ \    :- Functional and Structural 
% | | | |_| \__ \ | (_) | | | |      Integration of Neuroimages
% |_|  \__,_|___/_|\___/|_| |_|
%
%
%% AUTHOR:  Eyal Soreq & Richard Daws
%  EMAIL:  e.soreq14@imperial.ac.uk
%  AFFILIATION:  Imperial College London
%  VERSION:  0.0 CREATED: 23-May-2018 15:52:18
%
%% INPUTS:
%   X - nxm matrix to be clustered
%   I - Event Index (mxk)
%
%% OUTPUT:
%
%% EXAMPLES:
%{
simpleHCL(input01,input02,input03,input04)
%}
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

%if ~exist('obj','var');obj=getParams([]);obj=getParams(obj);end
%TODO:- Colour clusters (L) 

out = []; 
obj = struct('dmtd','euc','lmtd','ward',...
             'cmap',get.cmap(flipud([255 205 155;255 180 104;255 155 54;255 130 4;191 98 3;51 51 51;14 83 164;49 92 143;62 117 182;110 152 200;207 221 237]./255),101),...
             'depth',3,'type','simple','xdepth',2,'ydepth',3,...
             'clim',round(max(abs(X(:)))).*[-1,1]);
    

% Here we do thew anaylsis of HCL defined as the parallel distance search
% for both x (columns) and y (rows) defined over X  
Z_x = linkage(pdist(X,obj.dmtd),obj.lmtd);%weighted,average,complete ,'centroid','median','single','ward'
I_x = inconsistent(Z_x,obj.depth); % add obj.depth to getParams
[~,L_x]=sort(I_x(:,4),'descend');
out.xOrder = optimalleaforder(Z_x,pdist(X));

Z_y = linkage(pdist(X',obj.dmtd),obj.lmtd);
I_y = inconsistent(Z_y,obj.depth);
[~,L_y]=sort(I_y(:,4),'descend');
out.yOrder = optimalleaforder(Z_y,pdist(X'));

%% Armed with this knowlege we plot this into ax 
clf;
b1 = .08;l1=.1 ;w1 = .8;h1 =.8;
ax.main = axes('Position', [l1+0.03 b1 w1 h1]);%main heat map[left bottom width height]
ax.den_x = axes('Position',  [l1+0.03 b1+h1 w1 l1+0.01]);%top dendogram
ax.den_y = axes('Position',  [0.04 b1 l1-.01 h1]);%left dendogram        
ax.cb = axes('Position',  [w1+l1+.05 b1 0.02 h1]);%color bar  
% Build complexity if requested
switch obj.type 
    case 'labels'
        [x,y,w,h]=get.fancyGrid(ones(size(I,2),1),0.05,0.001,'same');
        for ii=1:numel(x)
            ax.(['b' num2str(ii)]) = axes('Position',  [l1+0.03 0.04+y(ii)*(b1-.05) w1 h*(b1-0.05)]);
            %ax.(['l' num2str(ii)]) = axes('Position',  [l1+w1 0.01+y(ii)*(b1-.05) w*.2 h*(b1-0.05)]);
        end
        lmap=get.cmap([120 34 102;230 210 230]);
    case 'clusters'                
    case 'lacl' % Labels % Clusters        
    otherwise; error('Obj.type should equal simple, labels, clusters or lacl')   
end

% plot top dendorgam
axes(ax.den_x);
[xh,~,~,xcg] = plot.dendrogram(Z_x,0,'orient', 'top', 'colorthreshold',Z_x(L_x(obj.xdepth),3),'Reorder',out.xOrder);
conn_x = (Z_x(:,3) < Z_x(L_x(obj.xdepth),3));
[out.xClusters,~] = get.labeltree(Z_x, conn_x,xcg);

% plot left dendorgam
axes(ax.den_y);
[yh,~,~,ycg] = plot.dendrogram(Z_y,0,'orient', 'left', 'colorthreshold',Z_y(L_y(obj.ydepth),3),'Reorder',out.yOrder);
conn_y = (Z_y(:,3) < Z_y(L_y(obj.ydepth),3));
[out.yClusters,~] = get.labeltree(Z_y, conn_y,ycg);

% Cluster cmap
out.cmap_x = colour.nmap(max(out.xClusters),10:9+max(out.xClusters));
colorBranch(xh,xcg,out.cmap_x);
out.cmap_y = colour.nmap(max(out.yClusters),35:34+max(out.yClusters));
colorBranch(yh,ycg,out.cmap_y);

% plot heat map 
axes(ax.main);
imagesc(X(out.xOrder,out.yOrder)')
ax.main.CLim = obj.clim;
colormap(ax.main,obj.cmap);

% plot color bar
axes(ax.cb);
cb = linspace(obj.clim(1),obj.clim(2),100);
imagesc((cb)','parent',ax.cb)
colormap( ax.cb,obj.cmap);

set(ax.cb,'CLim',obj.clim,'YAxisLocation','right','YDir','normal')
ax.cb.YTick = linspace(1,100,10);
ax.cb.YTickLabel = num2cell((round(cb(ax.cb.YTick),2)));
ax.cb.XTick ='';
set(ax.main, 'Xticklabel', [], 'yticklabel',[],'Visible','off');

set(ax.den_x, 'xlim', [0.5,numel(out.xOrder)+0.5], 'Visible', 'Off');
set(ax.den_y, 'ylim', [0.5,numel(out.yOrder)+0.5], 'Visible', 'Off');

if ~strcmp(obj.type,'simple')
   for ii = 1:size(I,2)
        axes(ax.(['b' num2str(ii)]));        
        imagesc(I(out.xOrder,ii)');
        colormap(ax.(['b' num2str(ii)]),lmap)
        set(ax.(['b' num2str(ii)]),'Visible','off')
   end  
end


out.ax=ax;
end


%% NESTED 
function colorBranch(h,cg,cmap)
for ii=1:numel(cg)
    if cg(ii)
        h(ii).Color =  cmap(cg(ii),:);
        h(ii).LineWidth = 2;
    end
end

end


%------------- END OF CODE --------------
