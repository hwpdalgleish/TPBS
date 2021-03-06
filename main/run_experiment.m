function [handles] = run_experiment(handles,hObject)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% daq card variables (user set)
niDevice                = handles.niDevice;                 % device name of the daq card you want to use
inputTrigChan           = handles.inputTrigChan;            % receives triggers from master clock software (PaqIO in our case)
SLMOutputChan           = handles.SLMOutputChan;            % sends output triggers to SLM (triggers phasemask changes)
MicroscopeOutputChan    = handles.MicroscopeOutputChan;     % sends output triggers to microscope (controls power and galvos)

% Set up variables/output files
stim_trials = find(handles.laser_trials==1);
stim_pyb = handles.pyb(:,stim_trials);
fn = cell(numel(handles.dirs2save),1);
for i = 1:numel(handles.dirs2save)
    fn{i} = [handles.dirs2save{i} filesep handles.out_name '_MatlabTrials' '_' handles.time '.txt'];
    fmt = '%u %u %u\n';
    fid = fopen(fn{i},'w');
    fprintf(fid,fmt);
    fclose(fid);
end

% Run session
daq_session = daq.createSession('ni');
daq_session2 = daq.createSession('ni');
daq_session2.Rate = handles.sample_rate_hz;
% Input triggers (go/nogo trials)
addDigitalChannel(daq_session, niDevice, inputTrigChan, 'InputOnly');
% Output to SLM and PV
addAnalogOutputChannel(daq_session2, niDevice,SLMOutputChan, 'Voltage'); % SLM channel
addAnalogOutputChannel(daq_session2, niDevice,MicroscopeOutputChan, 'Voltage'); % Microscope channel

% Queue first stim
num_trials = size(stim_pyb,2);
handles.stim_count = 1;
stim = stim_pyb(1,handles.stim_count);
variation = stim_pyb(2,handles.stim_count);
queueOutputData(daq_session2, handles.stim(handles.protocol.stim_channels == stim).waveforms{handles.stim(handles.protocol.stim_channels == stim).vars == variation});
handles.paused = false;
handles.experiment_running = true;
guidata(hObject,handles);
disp('********* Ready to receive triggers *********')

% Wait for triggers
while ~(handles.stop_now) && handles.stim_count <= num_trials
    triggers = daq_session.inputSingleScan;
    if any(triggers) && ~handles.paused     
        % Deliver queued stim
        startForeground(daq_session2);
        disp([....
            'Trial: ' num2str(stim_trials(handles.stim_count))...
            ', Stim: ' num2str(stim)...
            ', Var: ' num2str(variation)])    
        % Save out MATLAB trial data
        handles.trial_list = [handles.trial_list ; stim_trials(handles.stim_count) stim variation];
        for i = 1:numel(fn)
            try
                fid = fopen(fn{i},'a');
                fprintf(fid,fmt,handles.trial_list(end,:));
                fclose(fid);
            catch
                fprintf(['--- Error saving file to ' fn{i}])
            end
        end
        % Queue next stim
        if handles.stim_count < num_trials
            handles.stim_count = handles.stim_count+1;
            guidata(hObject,handles);
            stim = stim_pyb(1,handles.stim_count);
            variation = stim_pyb(2,handles.stim_count);
            queueOutputData(daq_session2, handles.stim(handles.protocol.stim_channels == stim).waveforms{handles.stim(handles.protocol.stim_channels == stim).vars == variation});
        end
    end
    % Update GUI
    drawnow;
    handles = guidata(hObject);
end
handles.experiment_running = false;
handles.paused = false;
handles = guidata(hObject);
clear daq_session daq_session2
end

