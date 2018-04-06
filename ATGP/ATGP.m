function [xyEndmembers lstEndmembers duration] = ATGP(num_targets,HIM,xx,yy,bnd)

%Start to count the CPU time
start = cputime();



%bnd = size(HIM,3);
%xx = size(HIM,1);
%yy = size(HIM,2);

r=reshape(HIM,xx*yy,bnd);
r=r';

%===============Find the first point

lstEndmembers = zeros(1,num_targets);
temp = sum(r.*r);
[a b] = max(temp);

if( rem(b,xx)==0 )
    Loc(1,1) = b/xx;
    Loc(1,2) = xx;
elseif( floor(b/xx)==0 )
    Loc(1,1) = 1;
    Loc(1,2) = b;
else
    Loc(1,1) = floor(b/xx)+1;%y
    Loc(1,2) = b-xx*floor(b/xx);%x
end
lstEndmembers(1) = b;
Sig(:,1)=r(:,b);

%================
for m=2:num_targets
    U=Sig;
    P_U_Perp=eye(bnd)-U*inv(U'*U)*U';
    y=P_U_Perp*r;
    temp=sum(y.*y);
    [a,b] = max(temp);
    if( rem(b,xx)==0 )
        Loc(m,1) = b/xx;
        Loc(m,2) = xx;
    elseif( floor(b/xx)==0 )
        Loc(m,1) = 1;
        Loc(m,2) = b;
    else
        Loc(m,1) = floor(b/xx)+1;%y
        Loc(m,2) = b-xx*floor(b/xx);%x
    end
    Sig(:,m) = r(:,b);
    lstEndmembers(m) = b;
    %disp(m);
end

xyEndmembers(:,1) = Loc(:,2);%x
xyEndmembers(:,2) = Loc(:,1);%y











%Stop to count the CPU time
stop = cputime();
duration = stop-start;





