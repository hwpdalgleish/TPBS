% Measure power in a grid
% numbers should go from top left to top right, then down rows

%% paste measurments
% SLM
powers =[
26
63
67
68
68
69
58
61
72
80
86
79
71
63
68
79
93
101
95
81
66
69
84
99
103 %%
98
84
68
68
82
95
101
92
78
71
63
74
83
87
80
70
62
53
72
74
74
69
66
53
];


%% PROCESS DATA
gridCols = sqrt(numel(powers));
powers = powers / max(powers(:)) *100;
minPowerNorm = min(powers);
powers = reshape(powers, gridCols,gridCols)';

powersFilt = imresize(powers, [512, 512], 'nearest');
powersFilt = imgaussfilt(powersFilt,512/gridCols/2);

%% PLOT
figure('position', [100 100 1000 500]);
subplot(1,2,1)
imagesc(powers)
for i = 1:numel(powers)
    [y,x] = ind2sub([gridCols,gridCols], i);
    text(x,y,num2str(powers(i), '%.0f'));
end
axis square
xlabel('X position')
ylabel('Y position')
cb = colorbar;
xlabel(cb, 'Normalised power (%)')
caxis([0 100])
title('Measurement locations')

subplot(1,2,2)
imagesc(powersFilt)
axis square
hold on
% mag = 1/1.14;
% width = 512 * mag;
% spacing = (512 - width)/2;
% rectangle('position',[spacing spacing width width])
% text(spacing+5, spacing+20, '1.14x FOV')
xlabel('X position')
ylabel('Y position')
cb = colorbar;
xlabel(cb, 'Normalised power (%)')
caxis([0 100])
title('Interpolated')

suptitle('Bruker1 SLM vignetting (New dichroic) - 1.14X FOV')
