function setTrace( obj1 , tnum , n , m , l , s)
%setTrace sets the definition of trace tnum(1-4)
%   Set (Query) the Definition of Trace tnum (1-4) to n•m/l
%   n, m, l select  1, X, Y, R, q, Xn, Yn, Rn, Aux 1, Aux 2, Aux 3, Aux4, or F (n,m,l = 0...12).
%   l=13-24 selects X2 through F2.
%   Store (s=1) or Not Store (0).
%   obj1 is the Lock-in object.

fprintf(obj1, ['trcd ',num2str(tnum),',',num2str(n),',',num2str(m),',',num2str(l)',',',num2str(s)]);

end

