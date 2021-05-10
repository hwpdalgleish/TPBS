% PV pockels setting to mw calculator
% LR 2017

%% paste measurements (pv mw columns)
% satsuma
data = [0	0.7
25	4
50	19.7
75	37
100	63.4
125	97
150	135.7
175	173
200	218.4
225	264
250	311.9
275	354
300	397.5
325	439
350	474
375	504
400	526
425	545
450	557
475	563
500	563
];


%% Plot and calculate fit
PockelsSetting = data(:,1);
RecordedPower = data(:,2);

% fit
p = polyfit(RecordedPower, PockelsSetting, 7);  %choose order that works well
fit_x = linspace(min(RecordedPower),max(RecordedPower), 1000);
fit_y = polyval(p, fit_x); 

% plot
figure('name','Pockels-Power calculator');
hold on
scatter(RecordedPower, PockelsSetting)
plot(fit_x, fit_y)
xlabel('mW')
ylabel('Pockels Setting')
title('Pockels-Power calculator')
xlim([0 max(RecordedPower)])
ylim([0 max(PockelsSetting)])

%% Calculator
PowerRanges_mW = [30 50 60 75 100 150 200 250 300 350 400 450 500 550 600];
% PowerRanges_mW = [10 20 30 40 50 60];
ValuesRequired_PV = [];

for i = 1:numel(PowerRanges_mW)
    Desired_mW = PowerRanges_mW(i);
    if Desired_mW <= max(RecordedPower)
        Required_PV = polyval(p,Desired_mW);
        ValuesRequired_PV(i) = Required_PV;
        disp([num2str(Desired_mW) ' mW  =  PV' num2str(round(Required_PV))])
        plot([Desired_mW Desired_mW], [0 Required_PV], 'k:')
        plot([0 Desired_mW], [Required_PV Required_PV], 'k:')
        % plot(0, Required_PV, 'r.')
        text(0, Required_PV, num2str(round(Required_PV)), 'Color','r')
    else
        warning('Requested power out of range')
    end
    
end