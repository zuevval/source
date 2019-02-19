v = VideoWriter('heat_transfer.avi','Uncompressed AVI');
open(v)
writeVideo(v,heat_c_0_005);
close(v)

v = VideoWriter('hyperbolic.avi','Uncompressed AVI');
open(v)
writeVideo(v,hyperb);
close(v)