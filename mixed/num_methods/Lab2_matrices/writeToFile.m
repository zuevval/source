strB = strcat('matrices4/B',string(n),'no',string(No),'.txt');
fid=fopen(strB,'w'); %uncomment to execute
for k=1:n
    fprintf(fid, [repmat('%f\t',1,n-1) '%f\n'], B(k,:));
end
fclose(fid);
strBdev = strcat('matrices4/Bdev',string(n),'no',string(No),'.txt');
fid=fopen(strBdev,'w');
for k=1:n
    fprintf(fid, [repmat('%f\t',1,n-1) '%f\n'], Bdev(k,:));
end
fclose(fid);