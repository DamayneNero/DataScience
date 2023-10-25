%   Matlab Spectral Analysis Exercise
%   By Kyle Nero
%   Date created: 25th October 2023

clear; % deletes alll variables from the workspace
clc; % deletes all inputs and ouputs from the command window

%   load the input data
table = readtable("Spectrum1.xls");

%   Convert data table array
data = table2array(table);

%   Separate Columns so that that data can be plotted
x = data(:,1);
y = data(:,2);

%   Plot the data, give it a title and label the axises
figure
specplot = plot(x,y);

title('Spectral Analysis 1');
xlabel('Frequency (Hz)');
ylabel('Varience Density (m^2/Hz)');
% saveas(specplot, 'Spec1.png');


%   Create a loop to calculate differences in frequency (x) 
l = length(x);
n = 0;

for i =1:l-1
    df(i) = x(i+1) - x(i);
end
df(l) = df(l-1);

%    Create a loop to calculate the moments
i = 1;
for i = 1:1:l
    m0(i) = x(i)^0 * y(i) * df(i);
    m1(i) = x(i)^(-1) * y(i) * df(i);
    m2(i) = x(i)^2 * y(i) * df(i);
end

%   Sum the moments so they can be used in other fourmulas
totalm0 = sum(m0);
totalm1 = sum(m1);
totalm2 = sum(m2);

%   Calculate wave height and time
hm0 = round(4 * sqrt(totalm0),2);
tm02 = round(sqrt(totalm0/totalm2),2);
tE = totalm1 / totalm0;

power = ((1025 * 9.81^2) / (64 * pi)) * hm0^2 * tE;

fprintf('The significant wave height is %f m\n', hm0);
fprintf('The zero crossing is %f m\n', tm02);
