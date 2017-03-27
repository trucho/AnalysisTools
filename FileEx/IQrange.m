function b=IQrange(a)
% b = IQrange(a) returns the interquartile range of the values in a.  For
%  vector input, b is the difference between the 75th and 25th percentiles
%  of a.  For matrix input, b is a row vector containing the interquartile
%  range of each column of a.
% Example:
%  a=randn(10000,5);
%  IQrange(a)
mina=min(a);
sizea=size(a);
NumCols=sizea(2);
b=zeros(size(a));
for n=1:NumCols,
    b(:,n)=a(:,n)-mina(n);
end
Sorteda=sort(b);
lx=length(Sorteda);
SecondQuartile=round(lx/4);
FourthQuartile=3*round(lx/4);
b=abs(Sorteda(FourthQuartile,:)-Sorteda(SecondQuartile,:));