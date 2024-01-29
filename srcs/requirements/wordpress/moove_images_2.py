import pymysql
import re

def transform_url(original_url):
    # Pattern to extract file name and extension
    pattern = r'([^/]+)\.(dat|jpg|pdf|png)'
    match = re.search(pattern, original_url)
    if match:
        file_name, file_extension = match.groups()
        # Transform the URL
        return f"https://files.bio113-dev.com/{file_name}.{file_extension}"
    else:
        # Return the original URL if no match is found
        return original_url


def update_database():
    # Database connection parameters
    db_params = {
        'host': '0.0.0.0',
        'user': 'root',
        'password': 'password',
        'db': 'wordpress'
    }

    try:
        # Connect to the database
        connection = pymysql.connect(**db_params)

        with connection.cursor() as cursor:
            select_query = "SELECT meta_id, meta_value FROM wp_5_postmeta WHERE meta_value REGEXP '\.(dat|jpg|pdf|png)$'"
            cursor.execute(select_query)

            for row in cursor.fetchall():
                meta_id, original_url = row
                transformed_url = transform_url(original_url)

                update_query = "UPDATE wp_5_postmeta SET meta_value = %s WHERE meta_id = %s"
                cursor.execute(update_query, (transformed_url, meta_id))

            # Commit the changes
            connection.commit()

    except Exception as e:
        print(f"An error occurred: {e}")
    finally:
        # Close the database connection
        connection.close()

# Run the update function
update_database()

