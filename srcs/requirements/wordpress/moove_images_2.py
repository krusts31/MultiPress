import pymysql
import re

def transform_url(original_url):
    pattern = r'([^/]+)\.(dat|jpg|pdf|png)'
    match = re.search(pattern, original_url)
    if match:
        file_name, file_extension = match.groups()
        return f"https://files.bio113-dev.com/{file_name}.{file_extension}"
    else:
        return original_url


def update_database():

    db_params = {
        'host': '0.0.0.0',
        'user': 'root',
        'password': 'password',
        'db': 'wordpress'
    }

    try:
        # Connect to the database
        #  http://lv.bio113-dev.com/wp-content/uploads/sites/5/2024/01 -> https://files.bio113-dev.com/{file_name}.{file_extension}
        # os.path.splitext(test.rsplit('/')[-1])[0] file_name
        # os.path.splitext(test.rsplit('/')[-1])[1] file_extension


        connection = pymysql.connect(**db_params)

        with connection.cursor() as cursor:
            select_query = "SELECT post_content, guid 
FROM wp_5_posts 
WHERE guid REGEXP 'http://lv\.bio113-dev\.com/wp-content/uploads/sites/5/2024/01/.*\.(dat|jpg|pdf|png)$' 
   OR post_content REGEXP 'http://lv\.bio113-dev\.com/wp-content/uploads/sites/5/2024/01/.*\.(dat|jpg|pdf|png)$';
"

            cursor.execute(select_query)

            for row in cursor.fetchall():
                meta_id, original_url = row
                transformed_url = transform_url(original_url)

                update_query = "UPDATE wp_5_postmeta SET meta_value = %s WHERE meta_id = %s"
                cursor.execute(update_query, (transformed_url, meta_id))

            connection.commit()

    except Exception as e:
        print(f"An error occurred: {e}")
    finally:
        connection.close()

update_database()
