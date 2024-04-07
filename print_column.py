import pandas as pd
import sys

csv_name = sys.argv[1]

column_name = sys.argv[2]

df2 = pd.read_csv(csv_name)

print(df2[column_name].to_string(index=False))
