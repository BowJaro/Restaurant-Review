import os

def generate_sql(folder_path, output_path, start_id, prefix):
    # Check if the folder path exists
    if not os.path.exists(folder_path):
        print(f"Folder path {folder_path} does not exist.")
        return

    # Open the output file for writing
    with open(output_path, 'w') as file:
        # Initialize the ID
        current_id = start_id

        # Iterate through all files in the folder
        for root, dirs, files in os.walk(folder_path):
            for filename in files:
                # Construct the URL
                folder_name = os.path.basename(root)
                url = f"{prefix}/{folder_name}/{filename}"

                # Write the SQL statement to the file
                sql_statement = f"INSERT INTO image (id, url) VALUES ({current_id}, '{url}');\n"
                file.write(sql_statement)

                # Increment the ID
                current_id += 1

# Example usage
folder_path = "C:/laptrinh/hocki7/restaurant-data/menus"
output_path = "C:/laptrinh/hocki7/restaurant-data/image_menu_sql.sql"
start_id = 548
prefix = 'images'

generate_sql(folder_path, output_path, start_id, prefix)
