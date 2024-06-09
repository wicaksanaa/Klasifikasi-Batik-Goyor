% Memuat model KNN dari file
loadedModel = load('knnModel_6.mat');
knnModel = loadedModel.knnModel;

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
fprintf('Akurasi model KNN: %.2f%%\n', accuracy);

% Menyimpan hasil prediksi ke dalam file Excel
excelFilename = 'hasil_prediksi.xlsx'; % Nama file Excel untuk menyimpan hasil prediksi
writetable(resultsTable, excelFilename);

fprintf('Hasil prediksi telah disimpan dalam file Excel: %s\n', excelFilename);

% Menampilkan tabel hasil prediksi
disp(resultsTable);
