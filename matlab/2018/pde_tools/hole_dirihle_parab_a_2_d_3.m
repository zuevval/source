% This script is written and read by pdetool and should NOT be edited.
% There are two recommended alternatives:
 % 1) Export the required variables from pdetool and create a MATLAB script
 %    to perform operations on these.
 % 2) Define the problem completely using a MATLAB script. See
 %    http://www.mathworks.com/help/pde/examples/index.html for examples
 %    of this approach.
function pdemodel
[pde_fig,ax]=pdeinit;
pdetool('appl_cb',1);
set(ax,'DataAspectRatio',[1 1 1]);
set(ax,'PlotBoxAspectRatio',[1.5 1 1]);
set(ax,'XLim',[-1.5 1.5]);
set(ax,'YLim',[-1 1]);
set(ax,'XTickMode','auto');
set(ax,'YTickMode','auto');

% Geometry description:
pderect([-1.0848930481283423 0.87232620320855681 0.69986631016042788 -0.43917112299465189],'R1');
pdeellip(0.57245989304812839,0.38177998472116115,0.24665775401069534,0.23462566844919786,...
0,'E1');
set(findobj(get(pde_fig,'Children'),'Tag','PDEEval'),'String','R1-E1')

% Boundary conditions:
pdetool('changemode',0)
pdesetbd(8,...
'neu',...
1,...
'10',...
'1')
pdesetbd(7,...
'neu',...
1,...
'10',...
'1')
pdesetbd(6,...
'neu',...
1,...
'10',...
'1')
pdesetbd(5,...
'neu',...
1,...
'10',...
'1')
pdesetbd(4,...
'neu',...
1,...
'10',...
'1')
pdesetbd(3,...
'neu',...
1,...
'10',...
'1')
pdesetbd(2,...
'neu',...
1,...
'10',...
'1')
pdesetbd(1,...
'neu',...
1,...
'10',...
'1')

% Mesh generation:
setappdata(pde_fig,'Hgrad',1.3);
setappdata(pde_fig,'refinemethod','regular');
setappdata(pde_fig,'jiggle',char('on','mean',''));
setappdata(pde_fig,'MesherVersion','preR2013a');
pdetool('initmesh')
pdetool('refine')

% PDE coefficients:
pdeseteq(4,...
'1.0',...
'1.0',...
'0.5',...
'1.0',...
'0:10',...
'0.0',...
'0.0',...
'[0 100]')
setappdata(pde_fig,'currparam',...
['1.0';...
'1.0';...
'0.5';...
'1.0'])

% Solve parameters:
setappdata(pde_fig,'solveparam',...
char('0','1320','10','pdeadworst',...
'0.5','longest','0','1E-4','','fixed','Inf'))

% Plotflags and user data strings:
setappdata(pde_fig,'plotflags',[1 1 1 1 1 1 1 1 0 0 0 1 1 0 0 0 0 1]);
setappdata(pde_fig,'colstring','');
setappdata(pde_fig,'arrowstring','');
setappdata(pde_fig,'deformstring','');
setappdata(pde_fig,'heightstring','');