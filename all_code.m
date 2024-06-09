trainingFolder = 'datasets/training/';

% Memuat dataset pelatihan
trainingData = imageDatastore(trainingFolder, 'IncludeSubfolders', true, 'LabelSource', 'foldernames');

% Ekstraksi label dari nama folder untuk dataset pelatihan
trainingData.Labels = categorical(trainingData.Labels);

% Tampilkan jumlah data pelatihan per kelas
tblTraining = countEachLabel(trainingData);
disp('Jumlah data pelatihan per kelas:');
disp(tblTraining);

% Parameter GLCM
offsets = [0 1; -1 1; -1 0; -1 -1];
numOffsets = size(offsets, 1);
numGrayLevels = 256;
distances = [1];

% Ekstraksi fitur GLCM untuk data pelatihan
numTrainingImages = numel(trainingData.Files);
numFeatures = numOffsets * numel(distances) * 4; % 4 adalah jumlah fitur yang diekstraksi dari setiap GLCM

trainingFeatures = zeros(numTrainingImages, numFeatures);

for i = 1:numTrainingImages
    img = readimage(trainingData, i);
    grayImg = rgb2gray(img);
    glcm = graycomatrix(grayImg, 'Offset', offsets, 'NumLevels', numGrayLevels, 'Symmetric', true);
    stats = graycoprops(glcm, {'Contrast', 'Correlation', 'Energy', 'Homogeneity'});
    trainingFeatures(i, :) = [stats.Contrast, stats.Correlation, stats.Energy, stats.Homogeneity];
end

nilai_k = 8;

% Pelatihan model KNN
knnModel = fitcknn(trainingFeatures, trainingData.Labels, 'NumNeighbors', nilai_k);

% Simpan model KNN ke file
save('knnModel_8.mat', 'knnModel');