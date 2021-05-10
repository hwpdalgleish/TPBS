function [handles] = userVariables(handles)
% Add all your variables here

% read general all-optical settings file
yaml                                    = ReadYaml('settings.yml');

% general
handles.serv_dir                        = 'Z:\hdalgleish\TrainingFilesServer\'; % server directory to save to (NB leave empty if not using server communication between microscope and SLM computers
handles.sample_rate_hz                  = 10000;            % daq card output rate
handles.trigger_dur_ms                  = 5;                % duration of trigger signals
handles.initial_delay_ms                = 5;                % delay between trigger received and drawing spiral (NB this is the SLM settle time)
handles.trigger_amp                     = 5;                % amplitude of trigger signals (V)

% XML (microscope control)
handles.SpiralSizeUM                    = 17;               % spiral size (diameter)
handles.InterPointDelay                 = 0.01;             % delay between each spiral location
handles.LaserFactor                     = 1 / (1000/yaml.LaserPowerScaleFactor); % factor to multiply user-input mW to get voltage to drive pockels cell to generate that power
handles.IterationDelay                  = 10;               % delay between each sequence repetition
handles.UncagingLaser                   = 'Fidelity';       % photostim laser name
handles.TriggerCount                    = 1;                % how many triggers the microscope software should listen for to output
handles.VoltageRecCategoryName          = 'None';
handles.paramset                        = 'CurrentSettings';
handles.Rotations                       = 3;                % number of rotations comprising a single spiral shape
handles.InTriggerName                   = 'PFI1';           % Name of laser trigger line in microscope software
handles.OutTriggerCategory              = 'adam';           % Folder of laser output signal trigger
handles.OutTriggerName                  = '1ms pulse out';  % Name of laser output signal trigger

% NIDAQ (triggering)
handles.niDevice                        = 'Dev2';           % device name of the daq card you want to use
handles.inputTrigChan                   = 'port0/line0';    % receives triggers from master clock software (PaqIO in our case)
handles.SLMOutputChan                   = 'ao0';            % sends output triggers to SLM (triggers phasemask changes)
handles.MicroscopeOutputChan            = 'ao1';            % sends output triggers to microscope (controls power and galvos)

end

