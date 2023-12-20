clc
clear all
close all

A=[0.975 0 0.042 0;0 0.977 0 0.044;0 0 0.958 0;0 0 0 0.956];
B=[0.0515 0.0016;0.0019 0.0447;0 0.0737;0.0850 0];
C=[0.2 0 0 0;0 1.5 0 0;0 0 10.5 0;0 0 0 1.7];
E = [1;1;1;1];
D = [0.5;0.5;0.5;0.5];
alpha = 0.95;

n = size(A,1);
r = 1;

a = rank([C*E D])
b = rank(E) + rank(D)

if a == b
   flag = 1
   M = [E zeros(n,r)] * pinv([C*E D])
else
    flag = 0
end

% K = eye(n)- M*C;

%%
% define LMI 
A = (eye(n)-M*C)*A

setlmis([])
% define decision variables
[Z,nZ,sZ] = lmivar(2,[4 4]);
[P,nP,sP] = lmivar(1,[4 1]);
% [Y,nY,sY] = lmivar(2,[4 4]);
% define LMI terms

lmiterm([-2 1 1 P],1,1);
lmiterm([1 1 1 P],-1,1);
lmiterm([1 2 1 P],A',1);
lmiterm([1 2 1 -Z],-C',1);
lmiterm([1 3 1 -Z],-D',1);
lmiterm([1 2 2 P],-(1-alpha),1);
lmiterm([1 3 3 0],-alpha);
% pos = newlmi;
% lmiterm([-pos 1 1 P],1,1)
% end of defining LMI's
stab = getlmis;
% solve LMI's
[t_min,x_feas] = feasp(stab)

Pval = dec2mat(stab,x_feas,P)
Zval = dec2mat(stab,x_feas,Z)
% Yval = dec2mat(stab,x_feas,Y)

L1 = inv(Pval)*Zval
% L2 = inv(Zval')*Yval
set = eig(Pval)
gamma = 1 / sqrt(min(set))
