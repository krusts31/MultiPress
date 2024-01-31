import pymysql

#try:
connection = pymysql.connect(host='0.0.0.0', user='root', password='password', db='wordpress')

with connection.cursor() as cursor:
    # Step 1: Fetch the list of tables and columns
    cursor.execute("SELECT TABLE_NAME, COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'wordpress'")
    tables = cursor.fetchall()

    for table in tables:
         table_name = table[0]
         column_name = table[1]
         #hit = 'https://bio113.com/th/340x300_6/*' 
         #hit = 'http://lv\.bio113-dev\.com/.*' 
         hit = 'https://lv.bio113-dev.com/wp-content/uploads/sites/5/2024/01/ortosist__ma___o_5a1d382bcc784600x600.png'
         query = f"SELECT * FROM {table_name} WHERE {column_name}='{hit}'"
         cursor.execute(query)
         results = cursor.fetchall()
         if hit in results:
             print("QUERY:", query)
             print("RESULTS:", results)
             print(f"Found {hit} in table {table_name}, column {column_name}")
