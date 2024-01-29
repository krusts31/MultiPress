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
         query = f"SELECT * FROM {table_name} WHERE {column_name} LIKE '%wp-content/uploads/sites/5%'"
         cursor.execute(query)
         results = cursor.fetchall()
         if results:
             print(f"Found '.jpg' in table {table_name}, column {column_name}")
