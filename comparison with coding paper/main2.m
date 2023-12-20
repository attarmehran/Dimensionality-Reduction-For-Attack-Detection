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

sim('unstable_system_attack.slx')
plot(ans.likelihood.Data,'.-k')


sim('unstable_system_with_encoding.slx')
hold on 
plot(ans.likelihood.Data,'.-b')

hold on 
yline(0.2, '--r','LineWidth',1)

xlim([0 100])
ylim([-0.1 1.1])
xlabel('Time[sec]')
ylabel('Likelihood')
legend('system without encoding mechanism','system with the proposed encoding scheme','\zeta')

