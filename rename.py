import os
import shutil

def rename_images_in_folders(root_dir):
    # Membuat list dari sub-direktori di root_dir
    subdirectories = [subdir for subdir in os.listdir(root_dir) if os.path.isdir(os.path.join(root_dir, subdir))]

    for subdir in subdirectories:
        subdir_path = os.path.join(root_dir, subdir)
        # Mendapatkan list dari semua file di dalam sub-direktori
        files = [file for file in os.listdir(subdir_path) if os.path.isfile(os.path.join(subdir_path, file))]
        
        # Menghitung jumlah gambar dalam sub-direktori
        num_images = len(files)
        
        # Memastikan setidaknya ada satu gambar di dalam sub-direktori
        if num_images == 0:
            print(f"Tidak ada gambar di dalam folder {subdir_path}")
            continue
        
        # Iterasi melalui setiap gambar di dalam sub-direktori
        for i, file in enumerate(files):
            # Mendapatkan ekstensi file
            _, extension = os.path.splitext(file)
            # Membuat nama baru untuk gambar dengan format: nama_folder_angka
            new_name = f"{subdir}_{i+1}{extension}"
            # Path lama dan path baru untuk gambar
            old_path = os.path.join(subdir_path, file)
            new_path = os.path.join(subdir_path, new_name)
            # Mengganti nama file
            shutil.move(old_path, new_path)
            print(f"File {file} diubah menjadi {new_name}")

# Menjalankan fungsi untuk merename gambar-gambar di dalam folder
root_directory = "datasets/"
rename_images_in_folders(root_directory)
