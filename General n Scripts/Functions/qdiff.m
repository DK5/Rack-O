function [dX]=qdiff(X,n)
dX=X(n:end,:)-X(1:end-n+1,:);