
clc
clear all
close all
sample_time = 1;
N = 100;
y_a = zeros(N,2);
y = zeros(N, 2);
for i = 3:N
y_a(1,:) = [0.0588 0.0588]';
y_a(2,:) = [0.1286 -0.9706]';
y_a(i,:) = y_a(i - 2,:) - y_a(1,:);
end

sim('original_system.slx')
plot(ans.residual_2.Data,'.k')
hold on 

sim('Coding_Matrix_Test1')
% plot(y_a)
% figure
plot(ans.residual_2.Data,'.-r')
sim('Encoding_Unstable_system')
hold on 
plot(ans.residual_1.Data,'.-b')
xlim([0 100])
ylim([-5 50])
xlabel('Time[k]')
ylabel('${||\Delta z_k||}_2, {||\Delta {z}\prime_k||}_2$','interpreter','latex')
legend(['the original system'],['the coded system based on the proposed encoding scheme'],['the coded system based on [19]'])