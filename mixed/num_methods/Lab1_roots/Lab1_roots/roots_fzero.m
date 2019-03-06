format long;
a=0.1254;
b=-0.0027;
c=-4.7285;
d=-25.0263;
e=-33.0434;
p = poly([a b c d e]);
r = roots([a b c d e])

fun2 = @(x)(1.8.*x.^2-sin(10.*x));
lims2=[-1.25,1];
start_points = [-1,-0.5,-0.25,0.25,0.5];
roots_values = zeros(size(start_points));
j=1;
for i = start_points
    roots_values(1,j)=fzero(fun2,i);
    j=j+1;
end
display(roots_values)