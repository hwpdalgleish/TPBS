function varargout = TPBS(varargin)
% TPBS MATLAB code for TPBS.fig
%      TPBS, by itself, creates a new TPBS or raises the existing
%      singleton*.
%
%      H = TPBS returns the handle to a new TPBS or the handle to
%      the existing singleton*.
%
%      TPBS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TPBS.M with the given input arguments.
%
%      TPBS('Property','Value',...) creates a new TPBS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TPBS_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TPBS_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TPBS

% Last Modified by GUIDE v2.5 12-Jun-2017 16:27:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TPBS_OpeningFcn, ...
                   'gui_OutputFcn',  @TPBS_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before TPBS is made visible.
function TPBS_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TPBS (see VARARGIN)

% Choose default command line output for TPBS
handles.output = hObject;

handles.protocol_cell_selected = nan;
handles.protocol_table.Data = handles.protocol_table.Data(1,:);

handles.experiment = [];
handles.experiment_generated = false;
handles.trial_list = [];

handles.date = [];
handles.time = [];

handles.experiment_path = '';
handles.experiment_loaded = false;
handles.directory_path = '';
handles.directory_set = false;
handles.animal_id = '';

handles.phasemasks.phasemasks_path = '';
handles.phasemasks.phasemasks_loaded = false;
handles.phasemasks.phasemasks_details = {};
handles.phasemasks.num_phasemasks = [];
handles.phasemasks.mwpercell = [];
handles.phasemasks.mwpermask = [];
handles.phasemasks.cell_vs_mask = 1;

handles.protocol.protocol_path = '';
handles.protocol.protocol_name = '';
handles.protocol.protocol_loaded = false;
handles.protocol.num_trials = [];
handles.protocol.max_repeats_flag = false;
handles.protocol.max_repeats = [];
handles.protocol.randomise_phasemasks = false;
handles.protocol.protocol_table = {};
handles.protocol.stim_var_mat = [];
handles.protocol.num_rows = 1;
handles.protocol.trial_structure = 'Random';
handles.protocol.block_size = [];
handles.protocol.initial_buffer_flag = false;
handles.protocol.initial_buffer_trials = [];
handles.protocol.initial_buffer_stim = [];
handles.protocol.initial_buffer_var = [];
handles.protocol.var_file_path = [];
handles.protocol.var_file_loaded = false;
handles.protocol.var_order_flag = false;
handles.protocol.var_file = [];
handles.protocol.stim_channels = [];
handles.protocol.num_stims = [];
handles.protocol.stim_vars = {};
handles.protocol.num_stim_vars = [];
handles.protocol.valid_rows = false;

handles = protocol_table_num_masks_fcn(handles);
handles = protocol_table_stimvars(handles);

handles.experiment_running = false;
handles.stop_now = 0;
handles.paused = false;

% import user defined variables
handles = userVariables(handles); % HWPD

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes TPBS wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = TPBS_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in load_experiment_button.
function load_experiment_button_Callback(hObject, eventdata, handles)
% hObject    handle to load_experiment_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function experiment_path_display_Callback(hObject, eventdata, handles)
% hObject    handle to experiment_path_display (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of experiment_path_display as text
%        str2double(get(hObject,'String')) returns contents of experiment_path_display as a double


% --- Executes during object creation, after setting all properties.
function experiment_path_display_CreateFcn(hObject, eventdata, handles)
% hObject    handle to experiment_path_display (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in save_experiment_button.
function save_experiment_button_Callback(hObject, eventdata, handles)
% hObject    handle to save_experiment_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function directory_path_display_Callback(hObject, eventdata, handles)
% hObject    handle to directory_path_display (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of directory_path_display as text
%        str2double(get(hObject,'String')) returns contents of directory_path_display as a double


% --- Executes during object creation, after setting all properties.
function directory_path_display_CreateFcn(hObject, eventdata, handles)
% hObject    handle to directory_path_display (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in set_directory_button.
function set_directory_button_Callback(hObject, eventdata, handles)
% hObject    handle to set_directory_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
d = uigetdir('Select experiment directory');
if d ~= 0
    handles.directory_path = d;
    handles.directory_path_display.String = handles.directory_path;
    guidata(hObject,handles);
end

% --- Executes on button press in save_protocol_button.
function save_protocol_button_Callback(hObject, eventdata, handles)
% hObject    handle to save_protocol_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
protocol = handles.protocol;
protocol.var_file_path = [];
protocol.var_file_loaded = false;
protocol.var_order_flag = false;
protocol.var_file = [];
base_dir = which(mfilename());
[base_dir,~] = fileparts(base_dir);
%[base_dir,~,~] = fileparts(matlab.desktop.editor.getActiveFilename);
protocol_dir = [base_dir filesep 'Protocols'];
if exist(protocol_dir,'dir') ~= 7
    mkdir(protocol_dir)
end
[f,d] = uiputfile([protocol_dir filesep '*.mat']);
if f ~= 0
    save([d filesep f],'protocol')
    [~,name,~] = fileparts([d filesep f]);
    handles.protocol_path_display.String = name;
end
guidata(hObject,handles);



function protocol_path_display_Callback(hObject, eventdata, handles)
% hObject    handle to protocol_path_display (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of protocol_path_display as text
%        str2double(get(hObject,'String')) returns contents of protocol_path_display as a double


% --- Executes during object creation, after setting all properties.
function protocol_path_display_CreateFcn(hObject, eventdata, handles)
% hObject    handle to protocol_path_display (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in load_protocol_button.
function load_protocol_button_Callback(hObject, eventdata, handles)
% hObject    handle to load_protocol_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%[base_dir,~,~] = fileparts(matlab.desktop.editor.getActiveFilename);
%base_dir
%base_dir = 'C:\Users\zoo\Dropbox\Bruker1\MATLAB\TPBS\';
base_dir = which(mfilename());
[base_dir,~] = fileparts(base_dir);
protocol_dir = [base_dir filesep 'Protocols'];
if exist(protocol_dir,'dir') == 7
    load_dir = protocol_dir;
else
    load_dir = pwd;
end
[f,d] = uigetfile([load_dir filesep '*.mat']);
if f ~= 0
    load([d filesep f]);
    handles.protocol = protocol;
    handles.protocol.protocol_path = [d filesep f];
    handles = set_protocol(handles);
    guidata(hObject,handles);
end


% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2


% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function phasemasks_path_display_Callback(hObject, eventdata, handles)
% hObject    handle to phasemasks_path_display (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of phasemasks_path_display as text
%        str2double(get(hObject,'String')) returns contents of phasemasks_path_display as a double


% --- Executes during object creation, after setting all properties.
function phasemasks_path_display_CreateFcn(hObject, eventdata, handles)
% hObject    handle to phasemasks_path_display (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in load_phasemasks_button.
function load_phasemasks_button_Callback(hObject, eventdata, handles)
% hObject    handle to load_phasemasks_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.phasemasks.phasemasks_path = uigetdir(handles.directory_path);
if handles.phasemasks.phasemasks_path ~= 0
    p_d = [dir([handles.phasemasks.phasemasks_path filesep '*.tif']) ; dir([handles.phasemasks.phasemasks_path filesep '*.tiff'])];
    handles.phasemasks.num_phasemasks = numel(p_d);
    handles.phasemasks.phasemasks_details = cell(handles.phasemasks.num_phasemasks,3);
    handles.phasemasks.targets_xy = cell(handles.phasemasks.num_phasemasks,1);
%     if exist([handles.phasemasks.phasemasks_path filesep 'InputTargets']) == 7
%         handles.inputtargets_path = [handles.phasemasks.phasemasks_path filesep 'InputTargets'];
%         it_d = [dir([handles.inputtargets_path filesep '*.tif']) ; dir([handles.inputtargets_path filesep '*.tiff'])];
%         it_d_names = {it_d(:).name}';
%         for i = 1:handles.phasemasks.num_phasemasks
%             nm = strsplit(p_d(i).name,'.');
%             nm = nm{1};
%             nm = strrep(nm,'_CUDAphase','');
%             target_name = cellfun(@(x) contains(x,nm),it_d_names);
%             handles.phasemasks.phasemasks_details{i,1} = p_d(i).name;
%             if max(target_name) == 1
%                 x = imread([it_d(i).folder filesep it_d(target_name).name]);
%                 [targs_y,targs_x] = find(x);
%                 handles.phasemasks.phasemasks_details{i,2} = numel(targs_x);
%                 handles.phasemasks.targets_xy{i} = [targs_x(:) targs_y(:)];                
%             else
%                 handles.phasemasks.phasemasks_details{i,2} = nan;
%             end
%         end
%     else
        for i = 1:handles.phasemasks.num_phasemasks
            handles.phasemasks.phasemasks_details{i,1} = p_d(i).name;
            chunks = strsplit(p_d(i).name,'_');
            num_targets_idx = cellfun(@(x) contains(x,'Targets') | contains(x,'targets'),chunks);
            num_targets = strsplit(lower(chunks{num_targets_idx}),'t');
            handles.phasemasks.phasemasks_details{i,2} = str2num(num_targets{1});
        end
%     end
    if handles.apply_mwpercell_button.Value == 1
        for i = 1:handles.phasemasks.num_phasemasks
            handles.phasemasks.phasemasks_details{i,3} = handles.phasemasks.phasemasks_details{i,2} * handles.phasemasks.mwpercell;
        end
    elseif handles.apply_mwpermask_button.Value == 1
        for i = 1:handles.phasemasks.num_phasemasks
            handles.phasemasks.phasemasks_details{i,3} = handles.phasemasks.mwpermask;
        end
    end
    handles.phasemasks_path_display.String = handles.phasemasks.phasemasks_path;
    handles.phasemasks_details_table.Data = handles.phasemasks.phasemasks_details;
else
    handles.phasemasks.phasemasks_path = [];
end
guidata(hObject,handles);





% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function animalid_edit_Callback(hObject, eventdata, handles)
% hObject    handle to animalid_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of animalid_edit as text
%        str2double(get(hObject,'String')) returns contents of animalid_edit as a double
handles.animal_id = hObject.String;
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function animalid_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to animalid_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double


% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double


% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton14.
function pushbutton14_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of pushbutton14



function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double


% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit13_Callback(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit13 as text
%        str2double(get(hObject,'String')) returns contents of edit13 as a double


% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit14_Callback(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit14 as text
%        str2double(get(hObject,'String')) returns contents of edit14 as a double


% --- Executes during object creation, after setting all properties.
function edit14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit15_Callback(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit15 as text
%        str2double(get(hObject,'String')) returns contents of edit15 as a double


% --- Executes during object creation, after setting all properties.
function edit15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit16_Callback(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit16 as text
%        str2double(get(hObject,'String')) returns contents of edit16 as a double


% --- Executes during object creation, after setting all properties.
function edit16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit17_Callback(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit17 as text
%        str2double(get(hObject,'String')) returns contents of edit17 as a double


% --- Executes during object creation, after setting all properties.
function edit17_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function numtrials_edit_Callback(hObject, eventdata, handles)
% hObject    handle to numtrials_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of numtrials_edit as text
%        str2double(get(hObject,'String')) returns contents of numtrials_edit as a double
handles.protocol.num_trials = str2num(handles.numtrials_edit.String);
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function numtrials_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numtrials_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function stimratios_edit_Callback(hObject, eventdata, handles)
% hObject    handle to stimratios_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of stimratios_edit as text
%        str2double(get(hObject,'String')) returns contents of stimratios_edit as a double


% --- Executes during object creation, after setting all properties.
function stimratios_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stimratios_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in apply_mwpercell_button.
function apply_mwpercell_button_Callback(hObject, eventdata, handles)
% hObject    handle to apply_mwpercell_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of apply_mwpercell_button

if handles.phasemasks.cell_vs_mask == 1
    set(handles.apply_mwpercell_button,'Value',1);
end
handles.phasemasks.cell_vs_mask = 1;
set(handles.apply_mwpermask_button,'Value',0);
for i = 1:size(handles.phasemasks.phasemasks_details,1)
    handles.phasemasks.phasemasks_details{i,3} = round(handles.phasemasks.mwpercell * handles.phasemasks.phasemasks_details{i,2});
end
handles.phasemasks_details_table.Data = handles.phasemasks.phasemasks_details;
guidata(hObject,handles);



function mwpercell_edit_Callback(hObject, eventdata, handles)
% hObject    handle to mwpercell_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mwpercell_edit as text
%        str2double(get(hObject,'String')) returns contents of mwpercell_edit as a double
handles.phasemasks.mwpercell = str2num(handles.mwpercell_edit.String);
if handles.apply_mwpercell_button.Value == 1
    for i = 1:size(handles.phasemasks.phasemasks_details,1)
        handles.phasemasks.phasemasks_details{i,3} = round(handles.phasemasks.mwpercell * handles.phasemasks.phasemasks_details{i,2});
    end
end
handles.phasemasks_details_table.Data = handles.phasemasks.phasemasks_details;
guidata(hObject,handles);


function mwpermask_edit_Callback(hObject, eventdata, handles)
% hObject    handle to mwpermask_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mwpermask_edit as text
%        str2double(get(hObject,'String')) returns contents of mwpermask_edit as a double
handles.phasemasks.mwpermask = str2num(handles.mwpermask_edit.String);
if handles.apply_mwpermask_button.Value == 1
    for i = 1:size(handles.phasemasks.phasemasks_details,1)
        handles.phasemasks.phasemasks_details{i,3} = handles.phasemasks.mwpermask;
    end
end
handles.phasemasks_details_table.Data = handles.phasemasks.phasemasks_details;
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function mwpermask_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mwpermask_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function mwpercell_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mwpermask_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in apply_mwpermask_button.
function apply_mwpermask_button_Callback(hObject, eventdata, handles)
% hObject    handle to apply_mwpermask_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of apply_mwpermask_button

handles.phasemasks.cell_vs_mask = 2;
if handles.phasemasks.cell_vs_mask == 2
    set(handles.apply_mwpermask_button,'Value',1);
end
set(handles.apply_mwpercell_button,'Value',0);
for i = 1:size(handles.phasemasks.phasemasks_details,1)
    handles.phasemasks.phasemasks_details{i,3} = handles.phasemasks.mwpermask;
end
handles.phasemasks_details_table.Data = handles.phasemasks.phasemasks_details;
guidata(hObject,handles);


% --- Executes on button press in randomise_phasemasks_button.
function randomise_phasemasks_button_Callback(hObject, eventdata, handles)
% hObject    handle to randomise_phasemasks_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.protocol.randomise_phasemasks = logical(eventdata.Source.Value);
handles.protocol_table.ColumnEditable(3) = ~handles.protocol.randomise_phasemasks;
handles.protocol_table.Data(:,3) = {'NaN'};
handles.protocol_table.ColumnEditable(4) = handles.protocol.randomise_phasemasks;
handles = protocol_table_num_masks_fcn(handles);
guidata(hObject,handles);

function handles = protocol_table_num_masks_fcn(handles)
if ~handles.protocol.randomise_phasemasks
    for i = 1:handles.protocol.num_rows
        contents = handles.protocol_table.Data{i,3};
        contents(~isstrprop(contents,'Digit')) = ' ';
        if ~isempty(contents)
            handles.protocol_table.Data{i,4} = numel(str2num(contents));
        else
            handles.protocol_table.Data{i,4} = 0;
        end
    end
end

% function handles = protocol_table_ratio_limit_fcn(handles)
% handles.protocol_table.Data(~handles.protocol.valid_rows,10) = {''};
% stim_col = handles.protocol_table.Data(:,1);
% var_col = handles.protocol_table.Data(:,2);
% ratio_col = handles.protocol_table.Data(:,10);
% for s = 1:handles.protocol.num_stims
%     stim = handles.protocol.stim_channels(s);
%     relevant_rows = cellfun(@(x) strcmp(x,num2str(stim)),stim_col) ...
%         & handles.protocol.valid_rows;
%     empty_ratios = relevant_rows & cellfun(@(x) isempty(x),ratio_col);
%     full_ratios = relevant_rows & cellfun(@(x) ~isempty(x),ratio_col);
%     sum_ratios = sum([cellfun(@(x) str2num(x),ratio_col(full_ratios))]);
%     remainder = (1-sum_ratios) / numel(find(empty_ratios));
%     remainder = round(remainder * 10) / 10;
%     ratio_col(empty_ratios) = {num2str(remainder,'%g')};
%     handles.protocol_table.Data(empty_ratios,10) = ratio_col(empty_ratios);
% end

function handles = protocol_table_stimvars(handles)
full_cells = cellfun(@(x) ~isempty(x),handles.protocol_table.Data(:,1:2));
handles.protocol.valid_rows = min(full_cells,[],2)==1;
z = handles.protocol_table.Data(handles.protocol.valid_rows,1:2);
z = z(min(cellfun(@(x) ~isempty(x),z),[],2)==1,:);
handles.protocol.stim_vars = {};
handles.protocol.stim_channels = [];
handles.protocol.num_stims = [];
handles.protocol.stim_var_mat = [];
if ~isempty(z)
    handles.protocol.stim_var_mat = cell2mat(z);
    handles.protocol.stim_channels = sort(unique(handles.protocol.stim_var_mat(:,1)),'Ascend');
    handles.protocol.num_stims = numel(handles.protocol.stim_channels);
    for s = 1:handles.protocol.num_stims
        stim_flag = handles.protocol.stim_var_mat(:,1) == handles.protocol.stim_channels(s);
        handles.protocol.stim_vars{s} = sort(unique(handles.protocol.stim_var_mat(stim_flag,2)),'Ascend');
        handles.protocol.stim_vars{s}(isnan(handles.protocol.stim_vars{s})) = [];
    end
end

function handles = set_protocol(handles)
handles.var_path_display = handles.protocol.var_file_path;
handles.use_var_order_check.Value = handles.protocol.var_order_flag;
handles.numtrials_edit.String = handles.protocol.num_trials;
handles.max_repeats_check.Value = handles.protocol.max_repeats_flag;
handles.max_repeats_edit.String = num2str(handles.protocol.max_repeats);
handles.randomise_phasemasks_button.Value = handles.protocol.randomise_phasemasks;
handles.protocol_table.Data = handles.protocol.protocol_table;
handles.trial_structure_popup.Value = ...
    find(cellfun(@(x) strcmp(x,handles.protocol.trial_structure),handles.trial_structure_popup.String));
handles.blocksize_edit.String = handles.protocol.block_size;
handles.buffer_check.Value = handles.protocol.initial_buffer_flag;
handles.buffertrials_edit.String = handles.protocol.initial_buffer_trials;
handles.bufferstim_edit.String = handles.protocol.initial_buffer_stim;
handles.buffervar_edit.String = handles.protocol.initial_buffer_var;
[~,f,~] = fileparts(handles.protocol.protocol_path);
handles.protocol.protocol_name = f;
handles.protocol_path_display.String = handles.protocol.protocol_name;
handles = trial_structure_logic(handles);
handles = buffer_logic(handles);
handles = max_repeats_logic(handles);
    
% --- Executes on button press in set_defaults_button.
function set_defaults_button_Callback(hObject, eventdata, handles)
% hObject    handle to set_defaults_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%[base_dir,~,~] = fileparts(matlab.desktop.editor.getActiveFilename);
base_dir = which(mfilename());
[base_dir,~] = fileparts(base_dir);
fnames = fieldnames(handles);
first_field = find(cellfun(@(x) strcmp(x,'time'),fnames)==1,1,'First')+1;
defaults = [];
for f = first_field:numel(fnames)
    defaults.(fnames{f}) = handles.(fnames{f});
end
save([base_dir filesep 'TPBS_defaults.mat'],'defaults');



% --- Executes on button press in load_defaults_button.
function load_defaults_button_Callback(hObject, eventdata, handles)
% hObject    handle to load_defaults_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%[base_dir,~,~] = fileparts(matlab.desktop.editor.getActiveFilename);
base_dir = which(mfilename());
[base_dir,~] = fileparts(base_dir);
load([base_dir filesep 'TPBS_defaults.mat']);
fnames = fieldnames(defaults);
for f = 1:numel(fnames)
    handles.(fnames{f}) = defaults.(fnames{f});
end
handles.experiment_path_display.String = handles.experiment_path;
handles.directory_path_display.String = handles.directory_path;
handles.animalid_edit.String = handles.animal_id;
handles.phasemasks_path_display.String = handles.phasemasks.phasemasks_path;
handles.phasemasks_details_table.Data = handles.phasemasks.phasemasks_details;
handles.mwpercell_edit.String = handles.phasemasks.mwpercell;
handles.mwpermask_edit.String = handles.phasemasks.mwpermask;
handles.apply_mwpercell_button.Value = ~logical(handles.phasemasks.cell_vs_mask-1);
handles.apply_mwpermask_button.Value = logical(handles.phasemasks.cell_vs_mask-1);
handles = set_protocol(handles);
guidata(hObject,handles);

% --- Executes on button press in run_experiment_button.
function run_experiment_button_Callback(hObject, eventdata, handles)
% hObject    handle to run_experiment_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when entered data in editable cell(s) in phasemasks_details_table.
function phasemasks_details_table_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to phasemasks_details_table (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)

% vals = cell2mat(handles.phasemasks_details_table.Data(:,end));
% if min(vals == cell2mat(handles.phasemasks.phasemasks_details(:,end))) == 0
%     set(handles.apply_mwpercell_button,'Value',0)
%     set(handles.apply_mwpermask_button,'Value',0)
% end
for i = 1:handles.phasemasks.num_phasemasks
    handles.phasemasks.phasemasks_details{i,3} = handles.phasemasks_details_table.Data{i,3};
end

guidata(hObject,handles);


% --- Executes on button press in load_var_button.
function load_var_button_Callback(hObject, eventdata, handles)
% hObject    handle to load_var_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(handles.directory_path) || strcmp(handles.directory_path,'...')
    start_path = [handles.directory_path filesep];
else
    start_path = [];
end
[f,d] = uigetfile([start_path '*.txt']);
if f ~= 0
    handles.protocol.var_file_loaded = true;
    handles.protocol.var_file_path = [d filesep f];
    handles.protocol.var_file = dlmread(handles.protocol.var_file_path);
    handles.protocol.stim_channels = sort(unique(handles.protocol.var_file(1,:)),'Ascend');
    handles.protocol.num_stims = numel(handles.protocol.stim_channels);
    idx = 0;
    imported_table = {};
    for i = 1:handles.protocol.num_stims
        handles.protocol.stim_vars{i} = ...
            sort(unique(handles.protocol.var_file(2,handles.protocol.var_file(1,:) == handles.protocol.stim_channels(i))),'Ascend');
        handles.protocol.num_stim_vars(i) = numel(handles.protocol.stim_vars{i});
        for j = 1:handles.protocol.num_stim_vars(i)
            idx = idx+1;
            imported_table{idx,1} = handles.protocol.stim_channels(i);
            imported_table{idx,2} = handles.protocol.stim_vars{i}(j);
        end
    end
    if size(imported_table,1) ~= size(handles.protocol_table.Data,1)
        handles.protocol_table.Data = cell(size(imported_table,1),size(handles.protocol_table.Data,2));
    end
    handles.protocol_table.Data(:,1:2) = imported_table;
end
handles.var_path_display.String = handles.protocol.var_file_path;
handles.protocol.num_rows = size(handles.protocol_table.Data,1);
handles = protocol_table_num_masks_fcn(handles);
guidata(hObject,handles);


function var_path_display_Callback(hObject, eventdata, handles)
% hObject    handle to var_path_display (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of var_path_display as text
%        str2double(get(hObject,'String')) returns contents of var_path_display as a double


% --- Executes during object creation, after setting all properties.
function var_path_display_CreateFcn(hObject, eventdata, handles)
% hObject    handle to var_path_display (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in trial_structure_popup.
function trial_structure_popup_Callback(hObject, eventdata, handles)
% hObject    handle to trial_structure_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns trial_structure_popup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from trial_structure_popup

handles.protocol.trial_structure = eventdata.Source.String{eventdata.Source.Value};
handles = trial_structure_logic(handles);
guidata(hObject,handles)

function handles = trial_structure_logic(handles)
switch handles.protocol.trial_structure
    case 'Random'
        handles.blocksize_edit.Enable ='off';
        %handles.blocksize_edit.String = '';
        %handles.protocol.block_size = [];
    case 'Blocked'
        handles.blocksize_edit.Enable ='on';
end

% --- Executes during object creation, after setting all properties.
function trial_structure_popup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to trial_structure_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in buffer_check.
function buffer_check_Callback(hObject, eventdata, handles)
% hObject    handle to buffer_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of buffer_check
handles.protocol.initial_buffer_flag = eventdata.Source.Value;
handles = buffer_logic(handles);
guidata(hObject,handles);

function handles = buffer_logic(handles)
if handles.protocol.initial_buffer_flag == 1
    state = 'On';
else
    state = 'Off';
    %handles.buffertrials_edit.String = '';
    %handles.bufferstim_edit.String = '';
    %handles.buffervar_edit.String = '';
end
handles.buffertrials_edit.Enable = state;
handles.bufferstim_edit.Enable = state;
handles.buffervar_edit.Enable = state;



function buffertrials_edit_Callback(hObject, eventdata, handles)
% hObject    handle to buffertrials_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of buffertrials_edit as text
%        str2double(get(hObject,'String')) returns contents of buffertrials_edit as a double
handles.protocol.initial_buffer_trials = hObject.String;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function buffertrials_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to buffertrials_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function bufferstim_edit_Callback(hObject, eventdata, handles)
% hObject    handle to bufferstim_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bufferstim_edit as text
%        str2double(get(hObject,'String')) returns contents of bufferstim_edit as a double
handles.protocol.initial_buffer_stim = hObject.String;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function bufferstim_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bufferstim_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function buffervar_edit_Callback(hObject, eventdata, handles)
% hObject    handle to buffervar_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of buffervar_edit as text
%        str2double(get(hObject,'String')) returns contents of buffervar_edit as a double
handles.protocol.initial_buffer_var = hObject.String;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function buffervar_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to buffervar_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function blocksize_edit_Callback(hObject, eventdata, handles)
% hObject    handle to blocksize_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of blocksize_edit as text
%        str2double(get(hObject,'String')) returns contents of blocksize_edit as a double
handles.protocol.block_size = str2num(handles.blocksize_edit.String);
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function blocksize_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to blocksize_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in varfile_undo_button.
function varfile_undo_button_Callback(hObject, eventdata, handles)
% hObject    handle to varfile_undo_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = varfile_undo_fcn(handles);
guidata(hObject,handles);

function handles = varfile_undo_fcn(handles);
handles.var_path_display.String = '...';
handles.protocol.var_file_loaded = false;
handles.protocol.var_file_path = [];
handles.protocol.var_file_loaded = false;
handles.protocol.var_file = [];
handles.protocol.stim_channels = [];
handles.protocol.num_stims = [];
handles.protocol.stim_vars = {};
handles.protocol.num_stim_vars = [];
handles.protocol.num_rows = 1;

% --- Executes when entered data in editable cell(s) in protocol_table.
function protocol_table_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to protocol_table (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
if isnan(eventdata.NewData)
    handles.protocol_table.Data{eventdata.Indices(1),eventdata.Indices(2)} = [];
end
handles = protocol_table_num_masks_fcn(handles);
handles = protocol_table_stimvars(handles);
handles.protocol.protocol_table = handles.protocol_table.Data;
guidata(hObject,handles);


% --------------------------------------------------------------------
function protocol_table_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to protocol_table (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on key press with focus on protocol_table and none of its controls.
function protocol_table_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to protocol_table (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
switch eventdata.Key
    case 'backspace'
        if ~isempty(handles.protocol_cell_selected)
            handles.protocol_table.Data{handles.protocol_cell_selected(1),handles.protocol_cell_selected(2)} = [];
            handles = protocol_table_num_masks_fcn(handles);
            handles = protocol_table_stimvars(handles);
        end
end
handles.protocol.protocol_table = handles.protocol_table.Data;
guidata(hObject,handles)


% --- Executes when selected cell(s) is changed in protocol_table.
function protocol_table_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to protocol_table (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
handles.protocol_cell_selected = eventdata.Indices;
handles.protocol.protocol_table = handles.protocol_table.Data;
guidata(hObject,handles);


% --- Executes on button press in add_row_button.
function add_row_button_Callback(hObject, eventdata, handles)
% hObject    handle to add_row_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.protocol_table.Data = [handles.protocol_table.Data ; cell(size(handles.protocol_table.Data(1,:)))];
handles.protocol_table.Data{end,cellfun(@(x) strcmp(x,'Laser'),handles.protocol_table.ColumnName)} = false;
handles.protocol_table.Data{end,cellfun(@(x) strcmp(x,'IDs'),handles.protocol_table.ColumnName)} = '';
handles.protocol.num_rows = handles.protocol.num_rows + 1;
handles = protocol_table_num_masks_fcn(handles);
handles = protocol_table_stimvars(handles);
handles.protocol.protocol_table = handles.protocol_table.Data;
guidata(hObject,handles);

% --- Executes on button press in remove_row_button.
function remove_row_button_Callback(hObject, eventdata, handles)
% hObject    handle to remove_row_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if size(handles.protocol_table.Data,1) > 1
    handles.protocol_table.Data = handles.protocol_table.Data(1:end-1,:);
    handles.protocol.num_rows = handles.protocol.num_rows - 1;
    handles = protocol_table_num_masks_fcn(handles);
    handles = protocol_table_stimvars(handles);
end
handles.protocol.protocol_table = handles.protocol_table.Data;
guidata(hObject,handles);

% --- Executes on button press in clear_rows_button.
function clear_rows_button_Callback(hObject, eventdata, handles)
% hObject    handle to clear_rows_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.protocol_table.Data = cell(size(handles.protocol_table.Data(1,:)));
handles.protocol_table.Data{cellfun(@(x) strcmp(x,'Laser'),handles.protocol_table.ColumnName)} = false;
handles.protocol_table.Data{cellfun(@(x) strcmp(x,'IDs'),handles.protocol_table.ColumnName)} = '';
handles.protocol.num_rows = 1;
if handles.protocol.var_file_loaded
    handles = varfile_undo_fcn(handles);
end
handles = protocol_table_num_masks_fcn(handles);
handles = protocol_table_stimvars(handles);
handles.protocol.protocol_table = handles.protocol_table.Data;
guidata(hObject,handles);


% --- Executes on button press in stop_button.
function stop_button_Callback(hObject, eventdata, handles)
% hObject    handle to stop_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.stop_now = 1;
guidata(hObject, handles);
disp(['********** Experiment stopped **********'])


% --- Executes on button press in reset_button.
function reset_button_Callback(hObject, eventdata, handles)
% hObject    handle to reset_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% handles.stop_now = 0;
% handles.stim_count = 0;
% guidata(hObject, handles);
% disp(['********** Stim counter reset to ' num2str(handles.stim_count)  ' **********'])
% run_experiment(handles,hObject);
if handles.experiment_running
    handles.paused = ~handles.paused;
    if handles.paused
        disp('<<<<<PAUSED>>>>>')
    else
        disp('>>>>>RUNNING<<<<')
    end
end
guidata(hObject,handles);


% --- Executes on button press in start_button.
function start_button_Callback(hObject, eventdata, handles)
% hObject    handle to start_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isempty(handles.animal_id)
    warndlg('Warning - please enter an animal ID to save a protocol. Note a new protocol will be generated next time you hit "Start" to ensure data is saved in the correct place.')
    handles.experiment_generated = false;
else
    if ~handles.experiment_generated
        if protocol_checker(handles.protocol_table.Data) == 1
            if isempty(handles.directory_path) || strcmp(handles.directory_path,'...')
                [d] = uigetdir('','Please select directory to save experiment...');
                if d ~=0
                    handles.directory_path = d;
                    handles.directory_path_display.String = handles.directory_path;
                end
            else
                handles = generate_experiment(handles);
                run_experiment(handles,hObject);
            end
        else
            warndlg('Error - not all protocol fields provided. Ensure laser stimuli have all fields filled and non-laser stimuli have Stim, Var and Ratio fields filled.')
        end
    else
        run_experiment(handles,hObject);
    end
end
guidata(hObject,handles);


function generate_button_Callback(hObject, eventdata, handles)
% hObject    handle to generate_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.experiment_generated = false;
if isempty(handles.animal_id)
    warndlg('Warning - please enter an animal ID to save a protocol.')
else
    if protocol_checker(handles.protocol_table.Data) == 1
        if isempty(handles.directory_path) || strcmp(handles.directory_path,'...')
            [d] = uigetdir('','Please select directory to save experiment...');
            if d ~= 0
                handles.directory_path = d;
                handles.directory_path_display.String = handles.directory_path;
            end
        end
        if ~isempty(handles.directory_path) || ~strcmp(handles.directory_path,'...')
            handles = generate_experiment(handles);
        end
    else
        warndlg('Error - not all protocol fields provided. Ensure laser stimuli have all fields filled and non-laser stimuli have Stim, Var and Ratio fields filled.')
    end
end
guidata(hObject,handles);

function flag = protocol_checker(protocol_table)
laser_idcs = [protocol_table{:,5}]==1;
laser_rows = protocol_table(laser_idcs,:);
empty_laser_flag = cellfun('isempty',laser_rows);
if isempty(empty_laser_flag)
    empty_laser_flag = 0;
end
nonlaser_idcs = ~laser_idcs;
nonlaser_rows = protocol_table(nonlaser_idcs,[1 2 10]);
empty_nonlaser_flag = cellfun('isempty',nonlaser_rows);
if isempty(empty_nonlaser_flag)
    empty_nonlaser_flag = 0;
end
flag = max([empty_laser_flag(:) ; empty_nonlaser_flag(:)])==0;


% --- Executes on button press in use_var_order_check.
function use_var_order_check_Callback(hObject, eventdata, handles)
% hObject    handle to use_var_order_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

states = {'On' 'Off'};
vals = [1 0];
% Hint: get(hObject,'Value') returns toggle state of use_var_order_check
if handles.protocol.var_file_loaded
    handles.protocol.var_order_flag = hObject.Value;
    handles.protocol.num_trials = size(handles.protocol.var_file,2);
    handles.numtrials_edit.String = num2str(handles.protocol.num_trials);
    handles.protocol.max_repeats_flag = vals(hObject.Value+1);
    handles.protocol.intial_buffer_flag = vals(hObject.Value+1);
    handles.numtrials_edit.Enable = states{hObject.Value+1};
    handles.max_repeats_edit.Enable = states{hObject.Value+1};
    handles.max_repeats_check.Enable = states{hObject.Value+1};
    handles.trial_structure_popup.Enable = states{hObject.Value+1};
    handles.buffer_check.Enable = states{hObject.Value+1};
    handles.buffertrials_edit.Enable = states{hObject.Value+1};
    handles.bufferstim_edit.Enable = states{hObject.Value+1};
    handles.buffervar_edit.Enable = states{hObject.Value+1};
else
    hObject.Value = false;
    handles.protocol.num_trials = str2num(handles.numtrials_edit.String);
    handles.numtrials_edit.String = num2str(handles.protocol.num_trials);
    handles.protocol.max_repeats_flag = handles.max_repeats_check.Value;
    handles.protocol.intial_buffer_flag = handles.buffer_check.Value;
    handles.numtrials_edit.Enable = 'On';
    handles.max_repeats_edit.Enable = 'On';
    handles.max_repeats_check.Enable = 'On';
    handles.trial_structure_popup.Enable = 'On';
    handles.buffer_check.Enable = 'On';
    handles.buffertrial_edit.Enable = 'On';
    handles.butterstim_edit.Enable = 'On';
    handles.buffervar_edit.Enable = 'On';
end
guidata(hObject,handles);


% --- Executes on button press in max_repeats_check.
function max_repeats_check_Callback(hObject, eventdata, handles)
% hObject    handle to max_repeats_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of max_repeats_check
handles.protocol.max_repeats_flag = eventdata.Source.Value;
handles = max_repeats_logic(handles);
handles.protocol.max_repeats = str2num(handles.max_repeats_edit.String);
guidata(hObject,handles);


function handles = max_repeats_logic(handles)
if handles.protocol.max_repeats_flag == 1
    handles.max_repeats_edit.Enable = 'On';
else
    handles.max_repeats_edit.Enable = 'Off';
end


function max_repeats_edit_Callback(hObject, eventdata, handles)
% hObject    handle to max_repeats_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of max_repeats_edit as text
%        str2double(get(hObject,'String')) returns contents of max_repeats_edit as a double
handles.protocol.max_repeats = str2num(hObject.String);
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function max_repeats_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to max_repeats_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function set_defaults_button_CreateFcn(hObject, eventdata, handles)
% hObject    handle to set_defaults_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

function load_defaults_button_CreateFcn(hObject, eventdata, handles)
% hObject    handle to set_defaults_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
