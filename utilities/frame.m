function [t,n,b]=frame(x,y,z,vec)

% FRAME Calculate a Frenet-like frame for a polygonal space curve
% [t,n,b]=frame(x,y,z,v) returns the tangent unit vector, a normal
% and a binormal of the space curve x,y,z. The curve may be a row or
% column vector, the frame vectors are each row vectors. 
%
% This function calculates the normal by taking the cross product
% of the tangent with the vector v; if v is chosen so that it is
% always far from t the frame will not twist unduly.
% 
% If two points coincide, the previous tangent and normal will be used.
%
% Written by Anders Sandberg, asa@nada.kth.se, 2005


N=size(x,1);
if (N==1)
  x=x';
  y=y';
  z=z';
  N=size(x,1);
end

t=zeros(N,3);
b=zeros(N,3);
n=zeros(N,3);

p=[x y z];

for i=2:(N-1)
  t(i,:)=(p(i+1,:)-p(i-1,:));
  tl=norm(t(i,:));
  if (tl>0)
    t(i,:)=t(i,:)/tl;
  else
    t(i,:)=t(i-1,:);
  end
end

try
t(1,:)=p(2,:)-p(1,:);
t(1,:)=t(1,:)/norm(t(1,:));

t(N,:)=p(N,:)-p(N-1,:);
t(N,:)=t(N,:)/norm(t(N,:));

for i=2:(N-1)
  n(i,:)=cross(t(i,:),vec);
  nl=norm(n(i,:));
  if (nl>0)
    n(i,:)=n(i,:)/nl;
  else
    n(i,:)=n(i-1,:);
  end
end

n(1,:)=cross(t(1,:),vec);
n(1,:)=n(1,:)/norm(n(1,:));

n(N,:)=cross(t(N,:),vec);
n(N,:)=n(N,:)/norm(n(N,:));

for i=1:N
  b(i,:)=cross(t(i,:),n(i,:));
  b(i,:)=b(i,:)/norm(b(i,:));
end
catch
end




