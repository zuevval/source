%04-feb-18
%statistics and machine learning toolbox
pd=makedist('Normal', 'mu', 1)
u = [1 2 3 4 5];
umean=mean(u);
ugeom=geomean(u);
uharm=harmmean(u);
bar([umean, ugeom, uharm]);
%statistics and machine learning -> functions - everything