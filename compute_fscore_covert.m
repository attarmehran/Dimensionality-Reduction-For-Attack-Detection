clc
clear all
close all

sample_time = 1;
simulation_time = 800;
window_length = 1;
threshold = 0.14;
a = 50;
b = 150;

N = 5;       % setting the number of trials
k1 = 1;    % starting time
k2 = (simulation_time*(1/sample_time))+1;   % ending time
T=(k2-k1)+1;
alpha = 0.9;   % setting alpha based on false alarm rate

recording_time = 100;  % recording in sec

% initializing the required evaluators (false alarm rate-detection
% rate-f1 score)
num = 0;
den = 0;
sum_false_alarm=0;
sum_d_rate=0;
sum_f1=0;
false_alarm=zeros(1,N);
d_rate=zeros(1,N);
f1=zeros(1,N);
t=zeros(T,N);
r=zeros(T,N);
U=zeros(T,N);

for i_N=1:N
    sim('covert_attack.slx');
    i_N
    k1 = 100;
    k2 = 350;
    t(:,i_N) = threshold; % threshold
    f(:,i_N) = ans.likelihood.Data(:,1);  % residual signal
    U(:,i_N) = ans.u_a.Data(:,1);       % flag for existence of an attack

    % define FP FN TP TN
    % TP
    for j = k1:k2
        if (U(j,i_N) == 1) && (t(j,i_N) > f(j,i_N))
            tp(j) = 1;
        else
            tp(j) = 0;
        end
    end
    
    % FN
    for j = k1:k2
        if (U(j,i_N) == 1) && (t(j,i_N) < f(j,i_N))
            fn(j) = 1;
        else
            fn(j) = 0;
        end
    end
    
    % FP
    for j = k1:k2
        if (U(j,i_N) == 0) && (t(j,i_N) > f(j,i_N))
            fp(j) = 1;
        else
            fp(j) = 0;
        end
    end
    
    % TN
    for j = k1:k2
        if (U(j,i_N) == 0) && (t(j,i_N) < f(j,i_N))
            tn(j) = 1;
        else
            tn(j) = 0;
        end
    end
    TP = 0;
    TN = 0;
    FP = 0;
    FN = 0;
    
    for j= k1:k2
        TP = tp(j) + TP;
        TN = tn(j) + TN;
        FP = fp(j) + FP;
        FN = fn(j) + FN;
    end
    %  False Alarm Function
    false_alarm(1,i_N) = 100*(FP/(FP + TN));
    
    sum_false_alarm = false_alarm(1,i_N) + sum_false_alarm;
    
    Av_false_alarm=(sum_false_alarm/N);
    
    % d_rate Function
    d_rate(1,i_N) = 100*(TP/(TP + FN));
    
    sum_d_rate=d_rate(1,i_N)+ sum_d_rate;
    
    Av_d_rate=(sum_d_rate/N);
    
    % F1 score Function
    f1(1,i_N) = 100*(TP/(TP + 0.5*(FP + FN)));
    
    sum_f1=f1(1,i_N)+ sum_f1;
    
    Av_f1=(sum_f1/N);
    
end


plot(ans.likelihood.Data,'.-b','LineWidth',0.01)
hold on 
yline(t(1),'--r','LineWidth',1)
xlim([k1 simulation_time])
title('covert attack')
hold on
x = [250 350 350 250];
y = [-1 -1 1.1 1.1];
patch(x,y,'red','FaceAlpha',.25,'EdgeColor','none')
xlabel('Time[sec]')
ylabel('Likelihood')
ylim([-0.2 1.1])
xlim([100 simulation_time])
legend(['$f(\hat{v}_k,\mu,\Sigma)$'],['$\zeta$'],['covert attack'],'interpreter','latex')