clc
clear all
close all

sample_time = 1;
threshold = 1;

sim('main_system.slx')

data = ans.sensors.Data;
data = data(100:800,:);

mu = mean(data);
st = std(data);

for i=1:size(data,1)
    norm_data(i,:) = (data(i,:) - mu) ./ st;
end

[comps,score,latent,tsquared,explained] = pca(norm_data);



