%   Matlab Tutorial
%   By Kyle Nero
%   Date created: 10th November 2023

%% Wind speed aveaging

clc
clear
pwd % Displays the path that the data is located

%WS1 = 6;
%WS2 = 8;
%WS3 = 9;
Ninputs = input("How many windspeed do you wish to enter? ");
fprintf("Please enter your windspeed one by one followed by enter. \n");

for n = 1:Ninputs
    fprintf("Enter wind speed %0.0f \n", n);
    Windspeed(n) = input("= ");
end

AveWindspeed = mean(Windspeed);

fprintf('Aveage wind speed is %2.1f m/s\n',AveWindspeed)

[maxWindspeed, Location] = max (Windspeed);
fprintf('Greatest wind speed is %0.1f m/s and it was the %0.0f entered \n',maxWindspeed,Location)

%% Sin and cos curves tutorial

clc
clear

x = 0:pi/100:2*pi;
y = sin(x);
y2 = cos(x);
figure
hold on
plot (x,y,'--r')
plot (x,y2,'--b')
xlabel('x')
ylabel('sin(x)')
title('Plot display sin & cos curves')
grid on
grid minor
legend('sin','cos')

%% Shear Profile Exercise

clc
clear
close


Windspeed10m = [4.9 5.7 6.3 5.5 6.4 6.3 6.6 6.1 5.2];
Windspeed25m = [5.8 61.4 6.9 6.3 7.0 6.9 7.2 6.7 6.0];
Windspeed45m = [6.5 7.1 7.5 7.0 7.5 7.4 7.7 7.3 6.8];

Heights = 1:100;

SRcs = 0.0002;
Y = log(Heights/SRcs);
h = 10;
u = log(4.9/SRcs);
windshear = Y/u*h;

figure
hold on
plot(windshear,Heights);

