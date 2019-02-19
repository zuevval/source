A= [0  1  0  0;-(c1+c2)/m1  -(b1+b2)/m1  c2/m1  b2/m1;0  0  0  1;c2/m2  b2/m2  -c2/m2  -b2/m2],
B = [0 0;1/m1 0;0 0;0 1/m2],
C=eye(4),
D=zeros(4,2)
Sb=ss(A,B,C,D); 

figure
step (Sb)
figure
impulse(Sb)
figure
bode(Sb)
figure
bode (Sb, [0.01 1000])

damp(Sb)