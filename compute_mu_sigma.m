clc
clear all
close all

sample_time = 1;
simulation_time = 800;
window_length = 1;
threshold = 0.5*10e11;
% attack magnitudes
a = 500;
b = 1500;

sim('main_system_with_encoding.slx')

V_hat = ans.v_hat.Data;

% true v_hat

v_hat_normal = V_hat(50:800,:)
plot(v_hat_normal)
% pause(1)
% close 

mean_v_hat = mean(v_hat_normal)
cov_v_hat = cov(v_hat_normal)

a = 1/sqrt(det(cov_v_hat))
b = 1/((2*pi)^2)

likelihood = a * b 

plot(ans.likelihood.Data,'.-b')
