import pymysql
import re

#try:
connection = pymysql.connect(host='0.0.0.0', user='root', password='password', db='wordpress')
pattern = r'\d+/\d{4}/\d{2}/.*\.(dat|jpg|pdf|png)$'

with connection.cursor() as cursor:
    # Step 1: Fetch the list of tables and columns
    cursor.execute("SELECT TABLE_NAME, COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'wordpress'")
    tables = cursor.fetchall()

    for table in tables:
         table_name = table[0]
         column_name = table[1]
         #hit = 'https://bio113.com/th/340x300_6/*' 
         hit = '.*\.(dat|jpg|pdf|png)$' 
         query = f"SELECT * FROM {table_name} WHERE {column_name} REGEXP '{hit}'"
         cursor.execute(query)
         results = cursor.fetchall()
         match = re.search(pattern, str(results))
         if match:
            captured_value = match.group()
#         if results:
#             print("QUERY:", query)
#             print("RESULTS:", results)
#             print(f"Found {hit} in table {table_name}, column {column_name}")
