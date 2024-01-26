import pandas as pd

# Load the first CSV file
df1 = pd.read_csv('merged.csv')

# Load the second CSV file
df2 = pd.read_csv('shrinked_lv.csv')

# Extract the column from the first dataframe
column_to_append = df1['Price']

# Append this column to the second dataframe
df2['price'] = column_to_append

# Save the updated dataframe to a new CSV file
df2.to_csv('new_lv.csv', index=False)

