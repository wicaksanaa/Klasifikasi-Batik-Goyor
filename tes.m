function varargout = tes(varargin)
% TES MATLAB code for tes.fig
%      TES, by itself, creates a new TES or raises the existing
%      singleton*.
%
%      H = TES returns the handle to a new TES or the handle to
%      the existing singleton*.
%
%      TES('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TES.M with the given input arguments.
%
%      TES('Property','Value',...) creates a new TES or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before tes_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to tes_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help tes

% Last Modified by GUIDE v2.5 01-Mar-2024 21:38:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @tes_OpeningFcn, ...
                   'gui_OutputFcn',  @tes_OutputFcn, ...
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


% --- Executes just before tes is made visible.
function tes_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to tes (see VARARGIN)

% Choose default command line output for tes
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes tes wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = tes_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Memilih file gambar dari folder
[filename, pathname] = uigetfile({'*.jpg;*.png;*.bmp;*.gif','All Image Files';'*.*','All Files'}, 'Select Image File');
if isequal(filename,0) || isequal(pathname,0)
    % Jika pembatalan pemilihan file, tidak melakukan apa-apa
    return;
else
    % Membaca file gambar yang dipilih
    fullpath = fullfile(pathname, filename);
    img = imread(fullpath);
    
    % Menampilkan gambar di axes1
    axes(handles.axes1);
    imshow(img);
    title('Original Image');
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Mengambil gambar dari axes1
img = getimage(handles.axes1);

% Jika tidak ada gambar di axes1, tidak melakukan apa-apa
if isempty(img)
    return;
end

% Melakukan konversi ke grayscale
gray_img = rgb2gray(img);

% Menampilkan gambar hasil grayscale di axes2
axes(handles.axes2);
imshow(gray_img);


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Memuat model KNN dari file
loadedModel = load('knnModel_6.mat');
knnModel = loadedModel.knnModel;

% Mendefinisikan offset dan jumlah level keabuan untuk GLCM
offsets = [0 1; -1 1; -1 0; -1 -1];
numGrayLevels = 256;

% Mendapatkan gambar dari axes1
img = getimage(handles.axes1);

% Jika tidak ada gambar di axes1, tidak melakukan apa-apa
if isempty(img)
    return;
end

% Mengonversi gambar ke grayscale
grayImg = rgb2gray(img);

% Menghitung fitur GLCM untuk gambar yang dipilih
glcm = graycomatrix(grayImg, 'Offset', offsets, 'NumLevels', numGrayLevels, 'Symmetric', true);
stats = graycoprops(glcm, {'Contrast', 'Correlation', 'Energy', 'Homogeneity'});
testFeatures = [stats.Contrast, stats.Correlation, stats.Energy, stats.Homogeneity];
testFeatures = testFeatures(1:4)';

set(handles.uitable3, 'Data', testFeatures);


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Memuat model KNN dari file
loadedModel = load('knnModel_6.mat');
knnModel = loadedModel.knnModel;

% Mendefinisikan offset dan jumlah level keabuan untuk GLCM
offsets = [0 1; -1 1; -1 0; -1 -1];
numGrayLevels = 256;

% Mengambil gambar dari axes1
img = getimage(handles.axes1);

% Jika tidak ada gambar di axes1, tidak melakukan apa-apa
if isempty(img)
    return;
end

% Mengonversi gambar ke grayscale
grayImg = rgb2gray(img);

% Menghitung fitur GLCM untuk gambar yang dipilih
glcm = graycomatrix(grayImg, 'Offset', offsets, 'NumLevels', numGrayLevels, 'Symmetric', true);
stats = graycoprops(glcm, {'Contrast', 'Correlation', 'Energy', 'Homogeneity'});
testFeatures = [stats.Contrast, stats.Correlation, stats.Energy, stats.Homogeneity];

% Memprediksi kelas gambar menggunakan model k-NN
predictedClass = predict(knnModel, testFeatures);

% Menampilkan hasil klasifikasi pada textbox "identifikasi"
set(handles.identifikasi, 'String', predictedClass);

% Memuat daftar file gambar dari folder pengujian
testingFolder = 'datasets/testing/'; % Ganti dengan jalur folder pengujian Anda
% Mendapatkan daftar file gambar dari folder pengujian
imageFiles = dir(fullfile(testingFolder, '*.jpg')); % Ubah ekstensi jika perlu

% Inisialisasi tabel untuk menyimpan hasil prediksi dan label yang benar
resultsTable = table('Size', [length(imageFiles), 4], 'VariableTypes', {'string', 'string', 'string', 'logical'});
resultsTable.Properties.VariableNames = {'ImageName', 'TrueLabel', 'PredictedLabel', 'CorrectPrediction'};

% Loop melalui setiap file gambar
for i = 1:length(imageFiles)
    % Membaca nama file gambar
    imageName = imageFiles(i).name;
    
    % Ekstraksi label yang benar dari nama file gambar
    expression = '\w+-?\w+(?=_\d+\.jpg)';
    trueLabel = regexp(imageName, expression, 'match', 'once');
    
    % Membaca gambar
    selectedImagePath = fullfile(testingFolder, imageName);
    selectedImage = imread(selectedImagePath);

    % Menghitung fitur GLCM untuk gambar yang dipilih
    grayImg = rgb2gray(selectedImage);
    glcm = graycomatrix(grayImg, 'Offset', offsets, 'NumLevels', numGrayLevels, 'Symmetric', true);
    stats = graycoprops(glcm, {'Contrast', 'Correlation', 'Energy', 'Homogeneity'});
    testFeatures = [stats.Contrast, stats.Correlation, stats.Energy, stats.Homogeneity];

    % Melakukan prediksi dengan model KNN
    predictedLabel = string(predict(knnModel, testFeatures));

    % Memeriksa apakah prediksi benar
    isCorrect = strcmp(predictedLabel, trueLabel);
    
    % Menyimpan hasil prediksi dan label yang benar ke dalam tabel
    resultsTable.ImageName(i) = imageName;
    resultsTable.TrueLabel(i) = trueLabel;
    resultsTable.PredictedLabel(i) = predictedLabel;
    resultsTable.CorrectPrediction(i) = isCorrect;
end

% Menghitung akurasi
accuracy = sum(resultsTable.CorrectPrediction) / length(imageFiles) * 100;
% Menampilkan hasil klasifikasi pada textbox "identifikasi"
set(handles.akurasi, 'String', accuracy+"%");




% --- Executes on button press in pushbutton6 (Reset).
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Mengosongkan axes
cla(handles.axes1);
cla(handles.axes2);

% Mengosongkan tabel
data = cell(1, 4);
set(handles.uitable3, 'Data', data);

% Mengosongkan textbox identifikasi
set(handles.identifikasi, 'String', '');

% Mengosongkan textbox akurasi
set(handles.akurasi, 'String', '');
