function handles = generate_experiment(handles);
%% User defined parameters (user set in userVariables.m)
serv_dir                        = handles.serv_dir;
sample_rate_hz                  = handles.sample_rate_hz;
trigger_dur_ms                  = handles.trigger_dur_ms;
initial_delay_ms                = handles.initial_delay_ms;
trigger_amp                     = handles.trigger_amp;

SpiralSizeUM                    = handles.SpiralSizeUM;
InterPointDelay                 = handles.InterPointDelay;
LaserFactor                     = handles.LaserFactor;
IterationDelay                  = handles.IterationDelay;
UncagingLaser                   = handles.UncagingLaser;
TriggerCount                    = handles.TriggerCount;
VoltageRecCategoryName          = handles.VoltageRecCategoryName;
paramset                        = handles.paramset;
Rotations                       = handles.Rotations;
InTriggerName                   = handles.InTriggerName; 
OutTriggerCategory              = handles.OutTriggerCategory; 
OutTriggerName                  = handles.OutTriggerName;

trigger_dur_samp                = round(sample_rate_hz*(trigger_dur_ms/1000));
initial_delay_samp              = round(sample_rate_hz*(initial_delay_ms/1000));


%% Get day info and make relevant directories
handles.date = datestr(now,'yyyymmdd');
handles.time = datestr(now,'hhMMss');
animal_id = handles.animal_id;
if isempty(animal_id)
    nm = strsplit(handles.directory_path,filesep);
    animal_id = nm{end};
end
new_name = ['TPBSExpt_' handles.date '_' handles.time];
new_dir = [handles.directory_path filesep new_name];

%% Pull out protocol parameters
empty_cells = cellfun('isempty',handles.protocol_table.Data);
handles.protocol_table.Data(empty_cells) = {nan};
num_trials = handles.protocol.num_trials;
max_repeats = handles.protocol.max_repeats;
stim_col = cell2mat(handles.protocol_table.Data(:,cellfun(@(x) strcmp(x,'Stim'),handles.protocol_table.ColumnName)));
stim_channels = unique(stim_col);
num_stims = numel(stim_channels);
var_col = cell2mat(handles.protocol_table.Data(:,cellfun(@(x) strcmp(x,'Var'),handles.protocol_table.ColumnName)));
stimvar_mat = [stim_col var_col];
pmask_ids = handles.protocol_table.Data(:,cellfun(@(x) strcmp(x,'IDs'),handles.protocol_table.ColumnName));
num_masks = cell2mat(handles.protocol_table.Data(:,cellfun(@(x) strcmp(x,'No. Masks'),handles.protocol_table.ColumnName)));
laser_logic = cell2mat(handles.protocol_table.Data(:,cellfun(@(x) strcmp(x,'Laser'),handles.protocol_table.ColumnName)));
pmask_rates = cell2mat(handles.protocol_table.Data(:,cellfun(@(x) strcmp(x,'Rate'),handles.protocol_table.ColumnName)));
spiral_durations = cell2mat(handles.protocol_table.Data(:,cellfun(@(x) strcmp(x,'Dur ms'),handles.protocol_table.ColumnName)));
pmask_reps = cell2mat(handles.protocol_table.Data(:,cellfun(@(x) strcmp(x,'Mask reps'),handles.protocol_table.ColumnName)));
train_reps = cell2mat(handles.protocol_table.Data(:,cellfun(@(x) strcmp(x,'Train reps'),handles.protocol_table.ColumnName)));
stim_ratios = cell2mat(handles.protocol_table.Data(:,cellfun(@(x) strcmp(x,'Ratio'),handles.protocol_table.ColumnName)));

total_num_masks = size(handles.phasemasks.phasemasks_details,1);
all_coords = [];
names = {};
pmasks = zeros(512,512,total_num_masks,'uint16');
for i = 1:total_num_masks
    names{i,1} = handles.phasemasks.phasemasks_details{i,1};
    xy = pmask_offset(handles.phasemasks.phasemasks_details{i,1});
    if ~isempty(xy)
        all_coords(i,:) = xy;
    else
        all_coords(i,:) = [255 255];
    end
%     if isempty(handles.phasemasks.targets_xy{i})
    pmasks(:,:,i) = imread([handles.phasemasks.phasemasks_path filesep names{i}]);
%     else
%         zi = ([0 0].*handles.phasemasks.targets_xy{i}(:,1)) + [0 1];
%         temp = SLMPhaseMaskMakerCUDA3D('Points',[handles.phasemasks.targets_xy{i} zi],'Save',false,'Do3DTransform',false);
%         pmasks(:,:,i) = temp{1};
%     end
end

%% Generate stimvar data
stim = [];
for s = 1:numel(stim_channels)
    idcs = find(stim_col == stim_channels(s));
    stim(s).channel = stim_channels(s);
    stim(s).vars = var_col(idcs)';
    stim(s).laser_logic = laser_logic(idcs)';
    stim(s).stim_ratios = stim_ratios(idcs)';
    stim(s).total_ratio = sum(stim(s).stim_ratios);
    if stim(s).laser_logic == 1
        stim(s).num_masks = num_masks(idcs)';
        stim(s).pmask_rates = pmask_rates(idcs)';
        stim(s).spiral_durations = spiral_durations(idcs)';
        stim(s).pmask_reps = pmask_reps(idcs)';
        stim(s).train_reps = train_reps(idcs)';
        for v = 1:numel(stim(s).vars)
            if handles.protocol.randomise_phasemasks == 0
                if isnumeric(pmask_ids{idcs(v)})
                    ids = pmask_ids{idcs(v)};
                else
                    ids = str2num(pmask_ids{idcs(v)});
                end
            else
                ids = zeros(1,stim(s).num_masks(v));
            end
            block_logic = 0*ids;
            block_logic(end) = 1;
            stim(s).pmask_ids{v} = repmat(ids,[1,stim(s).train_reps(v)]);
%             stim(s).pmask_names{v} = handles.phasemasks.phasemasks_details(stim(s).pmask_ids{v},1);
%             for pm = 1:numel(stim(s).pmask_names{v})
%                 stim(s).xy{v}(pm,:) = pmask_offset(stim(s).pmask_names{v}{pm});
%                 stim(s).pmasks{v}(:,:,pm) = imread([handles.phasemasks.phasemasks_path filesep stim(s).pmask_names{v}{pm}]);
%             end
            
            stim(s).block_ends{v} = repmat(block_logic,[1,stim(s).train_reps(v)]);
            stim(s).powers{v} = round(mw2pv([handles.phasemasks.phasemasks_details{stim(s).pmask_ids{v},3}]));

            stim(s).numrows(v) = stim(s).num_masks(v) * stim(s).pmask_reps(v) * stim(s).train_reps(v);
            stim(s).rateblock_dur_samp(v) = round(sample_rate_hz * (1/stim(s).pmask_rates(v)));
            stim(s).elem_dur_samp(v) = round(sample_rate_hz * (initial_delay_ms + (stim(s).spiral_durations(v) * stim(s).pmask_reps(v)))/1000);
            stim(s).block_dur_samp(v) = round(stim(s).elem_dur_samp(v) * stim(s).num_masks(v));
            
            filler_dur_samp = stim(s).rateblock_dur_samp(v) - stim(s).block_dur_samp(v);
            stim(s).filler_dur_ms{v}(stim(s).block_ends{v}==1) = (filler_dur_samp/sample_rate_hz)*1000;
            
            if stim(s).block_dur_samp(v) > stim(s).rateblock_dur_samp
                error('Error - spiral parameters do not allow stimulation and desired rate')
            end
            % NB waveforms(:,1) = SLM, waveforms(:,2) = microscope
            stim(s).waveforms{v} = zeros(stim(s).rateblock_dur_samp(v) * stim(s).train_reps(v),2);
            stim(s).waveforms{v}(1:1+trigger_dur_samp-1,2) = trigger_amp;
            elem = zeros(stim(s).elem_dur_samp(v),1);
            elem(1:trigger_dur_samp,1) = trigger_amp;
            block = repmat(elem,[stim(s).num_masks(v),1]);
            rep_idcs = 1:stim(s).rateblock_dur_samp(v):size(stim(s).waveforms{v},1);
            for i = 1:numel(rep_idcs)
                stim(s).waveforms{v}(rep_idcs(i):rep_idcs(i)+numel(block)-1,1) = block;
            end
        end
    end
end

%% Build stim and var orders for pybehaviour
if handles.protocol.var_order_flag == 1 && handles.protocol.var_file_loaded == 1
    stim_order = handles.protocol.var_file(1,:);
    var_order = handles.protocol.var_file(2,:);
else
    rng('shuffle');
    if handles.protocol.initial_buffer_flag == 1
        buffer_length = str2double(handles.protocol.initial_buffer_trials);
        buffer_stim = str2double(handles.protocol.initial_buffer_stim);
        buffer_var = str2double(handles.protocol.initial_buffer_var);
    else
        buffer_stim = nan;
        buffer_var = nan;
        buffer_length = 0;
    end
    
    % Sort stim ratios
    stims = stim_col;
    vars = var_col;
    ratios = stim_ratios;
    max_remain = max(mod(ratios * 10,1));
    if ~isinf(max_remain) && max_remain > 0
        num_in_block = 1/max_remain * ratios * 10;
    else
        num_in_block = ratios * 10;
    end
    
    % Make stimvar block, repeat and randperm
    block = [];
    for i = 1:numel(ratios)
        block = [block ; [stims(i) vars(i)] .* ones(num_in_block(i),2)];
    end
    block_len = size(block,1);
    num_blocks = ceil(num_trials / block_len);
    all_trials = [];
    for i = 1:num_blocks
        all_trials = [all_trials ; block(randperm(block_len),:)];
    end
    
    % Add buffer (if necessary) and truncate excess trials
    all_trials = [[buffer_stim buffer_var].*ones(buffer_length,2) ; all_trials];
    all_trials = all_trials(1:num_trials,:);
    stim_order = all_trials(:,1);
    var_order = all_trials(:,2);
end
figure('Position',[21 836 2541 502]);
subplot(1,5,[1 2 3])
plot((stim_order - min(stim_order)) ./ max((stim_order - min(stim_order))))
hold on
plot((var_order - min(var_order)) ./ max((var_order - min(var_order))) + 1)
set(gca,'YTick',[0 1 1.5 2],'YTickLabels',[unique(stims,'stable') ; unique(vars,'stable')])
set(gca,'TickDir','out')
xlabel('Trial No.')
box off

subplot(1,5,4)
for i = 1:numel(stims)
    hold on
    plot(cumsum(stim_order==stims(i) & var_order==vars(i))/numel(var_order));
end
axis square
xlabel('Trial No.')
ylabel('Cumulative proportion of trials')
box off
set(gca,'TickDir','out')

subplot(1,5,5)
props = zeros(size(stims));
labs = {};
for i = 1:numel(props)
    props(i) = mean(stim_order==stims(i) & var_order==vars(i));
    labs{i} = [num2str(stims(i)) '-' num2str(vars(i))];
end
bar(1:numel(props),props,'FaceColor',[0 0 0])
ylim([0 1])
xlim([0 numel(props)+1])
set(gca,'TickDir','out','XTick',1:numel(props),'XTickLabels',labs)
ylabel('Prob.')
xlabel('Stimulus variations')
axis square
box off
drawnow()

NumTrials = numel(stim_order);
protocol_numrows = 0;
for s = 1:numel(stim_channels)
    this_stim = stim_channels(s);
    for v = 1:numel(stim(s).vars)
        if stim(s).laser_logic(v) == 1
            this_var = stim(s).vars(v);
            protocol_numrows = protocol_numrows + (numel(find(stim_order == this_stim & var_order == this_var))); %* stim(s).numrows(v));
        end
    end
end
laser_trials = 0 * stim_order;
for t = 1:numel(stim_order) % changed from size
    s = stim_channels == stim_order(t);
    if stim(s).laser_logic(stim(s).vars == var_order(t)) == 1
        laser_trials(t) = 1;
    end
end
    
fprintf(sprintf(['--- Generated ' num2str(NumTrials) ' trials: \n']))
for s = 1:num_stims
    ch = stim_channels(s);
    ch_trials = find(stim_order == ch);
    ch_vars = unique(var_order(ch_trials));
    num_trials_of_stim = numel(ch_trials);
    fprintf(sprintf(['    ' num2str(num_trials_of_stim) ' * ch:' num2str(ch) ' with ' num2str(numel(ch_vars)) ' variations \n']))
end

%% Generate xml and save out corresponding phasemasks

mkdir([new_dir filesep 'PhaseMasks']);

fprintf(sprintf('--- Building .xml\n'))
handles.out_name                            = [handles.date '_' ...
                                  animal_id '_' ...
                                  'BhvTraining_' ...
                                  num2str(NumTrials) 'NumTrials'];

header = ['<PVSavedMarkPointSeriesElements '...
    'Category="User" ' ...  
    'IterationDelay="' num2str(IterationDelay) '" '...
    'Iterations="1" '...
    'handles.out_name="BhvStimuli"'...  
    ' >'];

dummy = [...
    '<PVMarkPointElement ' ...
    'Repetitions="' num2str(1) '" '...
    'UncagingLaser="' UncagingLaser '" '...
    'UncagingLaserPower="' num2str(0) '" '...
    'TriggerFrequency="' 'None' '" '...
    'TriggerSelection="' 'None' '" '...
    'TriggerCount="' num2str(1) '" '...
    'AsyncSyncFrequency="' 'None' '" '...
    'VoltageOutputCategoryName="' OutTriggerCategory '" '...
    'VoltageRecCategoryName="None" '...
    'parameterSet="' paramset '" '...
    '>'...
    '<PVGalvoPointElement '...
    'InitialDelay="' num2str(0.01) '" '...
    'InterPointDelay="' num2str(0.01) '" '...
    'Duration="' num2str(max(spiral_durations)) '" '...
    'SpiralRevolutions="' num2str(Rotations) '" '...
    'Points="Point 1" '...
    'Indices="' num2str(1) '" '...
    '/>'...
    '</PVMarkPointElement>'...
    ];

elements = cell(protocol_numrows,1);
counter = 0;
for t = 1:NumTrials
    this_stim                       = stim_channels == stim_order(t);
    this_var                        = find(stim(this_stim).vars == var_order(t));
    if stim(this_stim).laser_logic(this_var) == 1
        NumRows                         = stim(this_stim).numrows(this_var);
        if handles.protocol.randomise_phasemasks == 0
            this_ids                    = stim(this_stim).pmask_ids{this_var};
        else
            this_ids                    = repmat(randperm(total_num_masks,stim(this_stim).num_masks(this_var)),[1,stim(this_stim).train_reps(this_var)]);
        end
        this_filler                     = stim(this_stim).filler_dur_ms{this_var};
        TriggerSelection                = [{InTriggerName} ; repmat({'None'},NumRows-1,1)]; %[{'PFI1'} ; repmat({'None'},NumRows-1,1)];
        TriggerFrequency                = [{'First Repetition'} ; repmat({'None'},NumRows-1,1)];
        AsyncSyncFrequency              = [{'FirstRepetition'} ; repmat({'None'},NumRows-1,1)];
        VoltageOutputCategoryName       = [{OutTriggerCategory} ; repmat({'None'},NumRows-1,1)]; %[{'adam'} ; repmat({'None'},NumRows-1,1)];
        VoltageOutputExperimentName     = [{OutTriggerName} ; repmat({'None'},NumRows-1,1)]; %[{'1ms pulse out'} ; repmat({'None'},NumRows-1,1)];
        Points                          = cell(NumRows,1);
        Repetitions                     = stim(this_stim).pmask_reps(this_var);
        UncagingLaserPower              = stim(this_stim).powers{this_var};
        Indices                         = this_ids;
        PointNums                       = Indices;
        SpiralDur                       = stim(this_stim).spiral_durations(this_var);
        if this_filler < 0
            this_filler = 0 * this_filler;
        end
        for r = 1:NumRows
            counter                     = counter + 1;
            Points{r}                   = ['Point ' num2str(PointNums(r))];
            
            %%% Save out phasemasks %%%
            imwrite(pmasks(:,:,this_ids(r)),[new_dir filesep 'PhaseMasks' filesep num2str(counter,'%04d') '_' names{this_ids(r)}])
            %%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            if ~strcmp(VoltageOutputExperimentName{r},'None')
                elements{counter} = [...
                    '<PVMarkPointElement ' ...
                    'Repetitions="' num2str(Repetitions) '" '...
                    'UncagingLaser="' UncagingLaser '" '...
                    'UncagingLaserPower="' num2str(UncagingLaserPower(r) * LaserFactor) '" '...
                    'TriggerFrequency="' TriggerFrequency{r} '" '...
                    'TriggerSelection="' TriggerSelection{r} '" '...
                    'TriggerCount="' num2str(TriggerCount) '" '...
                    'AsyncSyncFrequency="' AsyncSyncFrequency{r} '" '...
                    'VoltageOutputCategoryName="' VoltageOutputCategoryName{r} '" '...
                    'VoltageOutputExperimentName="' VoltageOutputExperimentName{r} '" '...
                    'VoltageRecCategoryName="' VoltageRecCategoryName '" '...
                    'parameterSet="' paramset '" '...
                    '>'...
                    '<PVGalvoPointElement '...
                    'InitialDelay="' num2str(initial_delay_ms + this_filler(r)) '" '...
                    'InterPointDelay="' num2str(InterPointDelay) '" '...
                    'Duration="' num2str(SpiralDur) '" '...
                    'SpiralRevolutions="' num2str(Rotations) '" '...
                    'Points="' Points{r} '" '...
                    'Indices="' num2str(Indices(r)) '" '...
                    '/>'...
                    '</PVMarkPointElement>'...
                    ];
            else
                elements{counter} = [...
                    '<PVMarkPointElement ' ...
                    'Repetitions="' num2str(Repetitions) '" '...
                    'UncagingLaser="' UncagingLaser '" '...
                    'UncagingLaserPower="' num2str(UncagingLaserPower(r) * LaserFactor) '" '...
                    'TriggerFrequency="' TriggerFrequency{r} '" '...
                    'TriggerSelection="' TriggerSelection{r} '" '...
                    'TriggerCount="' num2str(TriggerCount) '" '...
                    'AsyncSyncFrequency="' AsyncSyncFrequency{r} '" '...
                    'VoltageOutputCategoryName="' VoltageOutputCategoryName{r} '" '...
                    'VoltageRecCategoryName="' VoltageRecCategoryName '" '...
                    'parameterSet="' paramset '" '...
                    '>'...
                    '<PVGalvoPointElement '...
                    'InitialDelay="' num2str(initial_delay_ms + this_filler(r)) '" '...
                    'InterPointDelay="' num2str(InterPointDelay) '" '...
                    'Duration="' num2str(SpiralDur) '" '...
                    'SpiralRevolutions="' num2str(Rotations) '" '...
                    'Points="' Points{r} '" '...
                    'Indices="' num2str(Indices(r)) '" '...
                    '/>'...
                    '</PVMarkPointElement>'...
                    ];
            end
        end
    end
end
footer = '</PVSavedMarkPointSeriesElements>';
xml = [header dummy [elements{:}] footer];

%% Save out all relevant info
pyb = [stim_order' ; var_order'];

handles.stim = stim;
handles.pyb = pyb;
handles.laser_trials = laser_trials;
handles.sample_rate_hz = sample_rate_hz;
handles.experiment_generated = true;
fnames = fieldnames(handles);
first_field = find(cellfun(@(x) strcmp(x,'time'),fnames)==1,1,'First')+1;
vf = [];
for f = first_field:numel(fnames)
    vf.(fnames{f}) = handles.(fnames{f});
end

if ~isempty(serv_dir)
    serv_animal_dir = [serv_dir filesep animal_id filesep new_name];
    mkdir([serv_animal_dir]);
    handles.dirs2save = {new_dir serv_animal_dir};
else
    handles.dirs2save = {new_dir};
end
for d = 1:numel(handles.dirs2save)
    % Save XML
    fid = fopen([handles.dirs2save{d} filesep handles.out_name '_' handles.time '.xml'], 'w', 'l');
    fwrite(fid, xml, 'char');
    fclose(fid);
    % Save trial structure
    dlmwrite([handles.dirs2save{d} filesep handles.out_name '_TrialStruct_' handles.time '.txt'],pyb)
    % Save gpl
    MarkPoints_GPLMaker(all_coords(:,1)', all_coords(:,2)', 'True', SpiralSizeUM, Rotations, [handles.dirs2save{d} filesep handles.out_name '_' handles.time]);
    % Save varfile
    save([handles.dirs2save{d} filesep handles.out_name '_VarFile_' handles.time '.mat'],'vf');
end

fprintf(sprintf(['--- The first 6 trials should be: '...
                 '\n\nStim: ' num2str(pyb(1,1:6)) ...
                 '\nVari: ' num2str(pyb(2,1:6)) '\n\n']));
             
fprintf('--> Ready to run experiment!\n\n')

end

%% Subfunctions
function [xy] = pmask_offset(name)
chunks = strsplit(name,'_');
x_idx = cellfun(@(x) strcmp(x(1),'X'),chunks);
y_idx = cellfun(@(x) strcmp(x(1),'Y'),chunks);
xy(1) = str2num(chunks{x_idx}(2:end));
xy(2) = str2num(chunks{y_idx}(2:end));
end

