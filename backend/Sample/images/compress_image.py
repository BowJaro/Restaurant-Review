import os
from PIL import Image

def save_original(image_path, output_path):
    with Image.open(image_path) as img:
        img.save(output_path)

def resize_image(image_path, output_path, divisor):
    with Image.open(image_path) as img:
        width, height = img.size
        img = img.resize((int(width / divisor), int(height / divisor)), Image.LANCZOS)
        img.save(output_path)

def compress_image_to_size(image_path, output_path, max_size_kb=50, initial_quality=70, step=10):
    save_original(image_path, output_path)
    
    file_size_kb = os.path.getsize(output_path) / 1024
    while file_size_kb > 100:
        resize_image(output_path, output_path, 1.5)
        file_size_kb = os.path.getsize(output_path) / 1024
    
    quality = initial_quality
    while True:
        with Image.open(output_path) as img:
            img.save(output_path, quality=quality, optimize=True)
        if os.path.getsize(output_path) <= max_size_kb * 1024:
            break
        quality -= step
        if quality <= 29:  # Set a lower bound to avoid extremely poor quality
            break
    return os.path.getsize(output_path)

def compress_images(input_dir, output_dir, max_size_kb=50):
    for root, dirs, files in os.walk(input_dir):
        for dir in dirs:
            new_input_dir = os.path.join(root, dir)
            new_output_dir = os.path.join(output_dir, dir)
            compress_images(new_input_dir, new_output_dir, max_size_kb)

        for file in files:
            if file.lower().endswith(('png', 'jpg', 'jpeg')):
                file_path = os.path.join(root, file)
                relative_path = os.path.relpath(root, input_dir)
                output_path = os.path.join(output_dir, relative_path, file)
                
                os.makedirs(os.path.dirname(output_path), exist_ok=True)
                
                try:
                    final_size = compress_image_to_size(file_path, output_path, max_size_kb)
                    print(f"Compressed and resized {file_path} to {final_size / 1024:.2f}KB")
                except Exception as e:
                    print(f"Failed to process {file_path}: {e}")

input_directory = "C:/laptrinh/hocki7/Restaurant-Review/backend/images/restaurants/"
output_directory = "C:/laptrinh/hocki7/Restaurant-Review/backend/images/restaurants_copy4/"
compress_images(input_directory, output_directory, max_size_kb=50)
print("Done")
