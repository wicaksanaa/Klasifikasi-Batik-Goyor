import os
import shutil

# Fungsi untuk memindahkan 3 gambar terbaru dari suatu folder ke folder baru
def move_latest_images(source_folder, destination_folder):
    # Memastikan folder tujuan ada atau dibuat jika belum ada
    if not os.path.exists(destination_folder):
        os.makedirs(destination_folder)

    # Mengambil list semua gambar dalam folder sumber dan mengurutkannya berdasarkan tanggal modifikasi terakhir
    images = sorted([file for file in os.listdir(source_folder) if file.lower().endswith(('.png', '.jpg', '.jpeg', '.gif', '.bmp'))], key=lambda x: os.path.getmtime(os.path.join(source_folder, x)), reverse=True)

    # Memilih 3 gambar terbaru
    selected_images = images[:3]

    # Memindahkan gambar-gambar terpilih ke folder tujuan
    for image in selected_images:
        source_path = os.path.join(source_folder, image)
        destination_path = os.path.join(destination_folder, image)
        shutil.move(source_path, destination_path)
        print(f"Moved {image} to {destination_path}")

# Memindahkan 3 gambar terbaru dari setiap folder ke folder baru
def move_latest_images_from_folders(parent_folder, new_folder):
    # Mendapatkan daftar semua folder di dalam parent_folder
    folders = [f for f in os.listdir(parent_folder) if os.path.isdir(os.path.join(parent_folder, f))]

    # Iterasi melalui setiap folder dan memanggil move_latest_images untuk setiap folder
    for folder in folders:
        source_folder = os.path.join(parent_folder, folder)
        move_latest_images(source_folder, new_folder)

# Menentukan folder sumber dan folder tujuan
parent_folder = "datasets/"
new_folder = "testing/"

# Memanggil fungsi untuk memindahkan gambar-gambar
move_latest_images_from_folders(parent_folder, new_folder)
