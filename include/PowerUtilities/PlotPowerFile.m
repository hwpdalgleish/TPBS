% plot power file
yaml = ReadYaml('settings.yml');
load(yaml.LaserPowerFile);

num_old_fits = numel(power_file.old);
cmap = hsv(num_old_fits+1);

% prepare figure
figure
subplot(2,2,[1 3])
plot(power_file.x_fit, power_file.y_fit, 'color',cmap(1,:), 'linewidth',2)
ylabel('PV setting (au)')
xlabel('Measured power (mW)')
axis square; box off
hold on

% prepare data arrays
all_dates = cell(num_old_fits+1,1);
mins = nan(num_old_fits+1,1);
maxes = nan(num_old_fits+1,1);
all_dates{end} = power_file.date;
mins(end) = min(power_file.x_fit);
maxes(end) = max(power_file.x_fit);

if num_old_fits > 0
    for i = 1:num_old_fits
        % plot this fit
        plot(power_file.old{i}.x_fit, power_file.old{i}.y_fit, 'color',cmap(i+1,:), 'linewidth',2)
        
        % get info from old fits
        if isfield(power_file.old{i}, 'date')
            all_dates{i} = power_file.old{i}.date;
        else
            all_dates{i} = '';
        end
        mins(i) = min(power_file.old{i}.x_fit);
        maxes(i) = max(power_file.old{i}.x_fit);
    end
end

legend(all_dates, 'location','southoutside')

subplot(2,2,2)
plot(1:numel(maxes), maxes, 'k:', 'linewidth',2)
hold on
scatter(1:numel(maxes), maxes,100,cmap,'filled')
xticks(1:numel(maxes))
xticklabels(all_dates)
xtickangle(45)
axis square; box off
title('Maximum (mW)')

subplot(2,2,4)
plot(1:numel(mins), mins, 'k:', 'linewidth',2)
hold on
scatter(1:numel(mins), mins,100,cmap,'filled')
xticks(1:numel(mins))
xticklabels(all_dates)
xtickangle(45)
axis square; box off
title('Minimum (mW)')