% This script is written and read by pdetool and should NOT be edited.
% There are two recommended alternatives:
 % 1) Export the required variables from pdetool and create a MATLAB script
 %    to perform operations on these.
 % 2) Define the problem completely using a MATLAB script. See
 %    http://www.mathworks.com/help/pde/examples/index.html for examples
 %    of this approach.
function pdemodel
[pde_fig,ax]=pdeinit;
pdetool('appl_cb',4);
set(ax,'DataAspectRatio',[1 1 1]);
set(ax,'PlotBoxAspectRatio',[1.5 1 1]);
set(ax,'XLim',[-1.5 1.5]);
set(ax,'YLim',[-1 1]);
set(ax,'XTickMode','auto');
set(ax,'YTickMode','auto');

% Geometry description:
pderect([-0.9685828877005348 0.9886363636363642 0.71991978609625673 -0.41911764705882304],'R1');
pdeellip(0.52540106951871679,0.36497326203208558,0.24665775401069534,0.23462566844919786,...
0,'E1');
set(findobj(get(pde_fig,'Children'),'Tag','PDEEval'),'String','R1-E1')

% Boundary conditions:
pdetool('changemode',0)
pdesetbd(8,...
'dir',...
2,...
char('1','0','5','1'),...
char('0','0'))
pdesetbd(7,...
'dir',...
2,...
char('1','0','5','1'),...
char('0','0'))
pdesetbd(6,...
'dir',...
2,...
char('1','0','5','1'),...
char('0','0'))
pdesetbd(5,...
'dir',...
2,...
char('1','0','5','1'),...
char('0','0'))
pdesetbd(4,...
'dir',...
2,...
char('1','0','0','1'),...
char('0','0'))
pdesetbd(3,...
'dir',...
2,...
char('1','0','0','1'),...
char('0','0'))
pdesetbd(2,...
'dir',...
2,...
char('1','0','0','1'),...
char('0','0'))
pdesetbd(1,...
'dir',...
2,...
char('1','0','0','1'),...
char('0','0'))

% Mesh generation:
setappdata(pde_fig,'Hgrad',1.3);
setappdata(pde_fig,'refinemethod','regular');
setappdata(pde_fig,'jiggle',char('on','mean',''));
setappdata(pde_fig,'MesherVersion','preR2013a');
pdetool('initmesh')

% PDE coefficients:
pdeseteq(1,...
char('2*((2E4)./(2*(1+(0.001))))+(2*((2E4)./(2*(1+(0.001)))).*(0.001)./(1-2*(0.001)))','0','(2E4)./(2*(1+(0.001)))','0','(2E4)./(2*(1+(0.001)))','2*((2E4)./(2*(1+(0.001)))).*(0.001)./(1-2*(0.001))','0','(2E4)./(2*(1+(0.001)))','0','2*((2E4)./(2*(1+(0.001))))+(2*((2E4)./(2*(1+(0.001)))).*(0.001)./(1-2*(0.001)))'),...
char('0.0','0.0','0.0','0.0'),...
char('0.0','0.0'),...
char('1000.0','0','0','1000.0'),...
'0:10',...
'0.0',...
'0.0',...
'[0 100]')
setappdata(pde_fig,'currparam',...
['2E4   ';...
'0.001 ';...
'0.0   ';...
'0.0   ';...
'1000.0'])

% Solve parameters:
setappdata(pde_fig,'solveparam',...
char('0','1000','10','pdeadworst',...
'0.5','longest','0','1E-4','','fixed','Inf'))

% Plotflags and user data strings:
setappdata(pde_fig,'plotflags',[1 1 1 1 1 1 1 1 0 0 0 1 1 0 1 0 0 1]);
setappdata(pde_fig,'colstring','');
setappdata(pde_fig,'arrowstring','');
setappdata(pde_fig,'deformstring','');
setappdata(pde_fig,'heightstring','');

% Solve PDE:
pdetool('solve')

