format compact
%symbolic matrices: creating
A=sym([1, 2, 3, 4;
    5, 6, 7, -8;
    9, 10, -11, 12;
    13, -14, 15, 16])
B=A'
%inversion
IA=inv(A)
IB=inv(B)
Det_A=det(A)
Det_B=det(B)
%characteristic polynomial
Poly_A=charpoly(A)
Roots_A=roots(Poly_A);
display(vpa(Roots_A, 3),"roots (Poly_A)")
Poly_B=charpoly(B)
Roots_B=roots(Poly_B);
display(vpa(Roots_B, 3),"roots (Poly_B)")
%eigenvalues and eigenvectors
[Vectors_A, Values_A] = eig(A);
display(vpa(Vectors_A, 3),"Eigenvectors_A")
display(vpa(Values_A,3),"Eigenvalues_A")
[Vectors_B, Values_B] = eig(A);
display(vpa(Values_B,3),"Values_B")
display(vpa(Vectors_B, 3),"Vectors_B")