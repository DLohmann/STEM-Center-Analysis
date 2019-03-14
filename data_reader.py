#!/usr/bin/python3

# Data reading, cleaning, and processing
import pandas as pd
import csv
import os
import re

# Database access
import sqlite3

# Get file path
cwd = os.getcwd()
file_path = cwd + r'/data/stem_center_sign_in'


# Takes in the name of a file, and returns the pandas dataframe containing that file's data
def read_file_as_df (file_name):
	# Get semester, which should be in file at coordinates 2C, or 23. But the csv reader reads this as 12 (because python counts from 0)
	semester = ''
	
	# Get the number of rows to read (until the sign-in entries are done, and the csv file is just showing other statistics)
	numRows = 7	# The first rows that is not blank in the leftmost column is row 7
	
	# The number of rows to skip before reading the data
	numToSkip = 6
	
	with open(file_name, 'r') as f:
		mycsv = csv.reader(f)
		mycsv = list(mycsv)
		semester = mycsv[1][2]
		
		# get the number of rows to read by counting the amount of places until a blank row
		numRows = 7
		while (mycsv[numRows] != []):
			numRows += 1
		
		
	# Now semester will be something like 'STEM Center Consulting-AOA 130-Fall 2016'
	# So we want to split on the '-' character, and then get the last substring 'Fall 2016' 
	semester = re.split(re.compile('-+'), semester)[-1]
	
	# Open csv, and read into pandas dataframe
	# pandas read_csv applies the 'nrows' operation to calculate the last row to read, before applying the 'skiprows' 
	# operation to skip them. So the 'nrows' still includes all rows that are skipped. So we have to take these out to 
	# ensure not to read extra rows after. Also subtract 1, to exclude the 1st row, the column names.
	numRows = numRows - numToSkip - 1 
	
	file = pd.read_csv(file_name, skiprows=numToSkip, nrows=numRows)
	df = pd.DataFrame(file)
	
	# Print file info:
	print ('semester is: ' + semester + ', columns are: ' + ', '.join(df))
	
	# Get rid of entries after the last one (we do not care about other data under the main sign in)
	# https://stackoverflow.com/questions/41320406/drop-all-rows-after-first-occurance-of-nan-in-specific-column-pandas
	
	# Add a column for the semester
	df['Semester'] = semester
	
	# Rename column names to not include special characters like whitespace or \. This is to make it easier to work with the SQLite database
	#newNames = {df.columns[i].replace(' ', '_').replace('/', '_') for i in range(len(df.columns))}
	column_name_mapping = {df.columns[i] : df.columns[i].replace(' ', '_').replace('/', '_') for i in range(len(df.columns))}	# create a dictionary mapping old column names to new column names
	df = df.rename(index=str, columns=column_name_mapping)	# Rename old column names to new column names (same name, but all special characters are replaced with "_")
	# The rename function made both the rows and columns accessed by string (ie file_data.loc['0']['Transaction_ID']), but we can always use the iloc function to access by index now (ie file_data.iloc[0][0])
	
	# Drop NaN values, and replace them with the empty string
	df = df.fillna('')
	
	#print ('All data:')
	#print(df.to_string())
	
	#print("Data's head is: ")
	#print(df.head)
	
	# TODO: Save as excel file to processed data folder
	
	# TODO: Delete index column, so that it will not be inserted into database later
	
	return df



# ***** Create database *****

# Delete the old database, if it exists
#if (os.path.exists('STEM_Center.db')):
#	os.remove('STEM_Center.db')

# Read the database specification:
#rf = open('STEM_Center_Sign_In_Tables.sql', 'r')	# Read database, if it already exists
rf = open('STEM_Center_Sign_In_Tables.sql')	# Create a new database
db_spec = rf.read()
rf.close()

# Connect to database
conn = sqlite3.connect("STEM_Center.db")

# Make the database file and tables, using the specification
#conn.executescript(db_spec)

# For debugging (with only 1 file in list)
#file_list = ['STEM Center Consulti_20180921_1326_3419.csv']


# ***** Add all STEM Center signins to database *****
for file_name in os.listdir(file_path):	#file_list:
	
	# ensure it is a CSV file
	if (not(file_name.endswith(".csv"))):
		continue	# Skip over files that are not csv files
	
	# Add file path to file name to get the path to read file from. Then read it as a pandas dataframe
	file_path_and_name = file_path + "/" + file_name
	
	print("Reading file: \"" + file_path_and_name + "\" into database")
	
	file_data = read_file_as_df(file_path_and_name)



	# Print (for debugging)
	#print(file_data.head())	#print top portion of data
	#print(file_data.to_string())	# print all data

	

	# Insert dataframe into a database
	file_data.to_sql('signins', con=conn, if_exists='append')

	'''
	for i in range(len(file_data)):
		rowVals = tuple(file_data.ix[i])
		conn.execute("INSERT INTO signins VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);", rowVals)
	'''

	'''
	for i in range(len(file_data)):
		conn.execute( "INSERT INTO signin
					+ "(Transaction_ID, Passed_Denied, First_Name, Last_Name, Email, CatCard_ID, Active) VALUES"
					+ "();"
	'''






# Test by printing all data from database table signins
'''
print ("\n\n\nQUERYING DATABASE\n\n\n")
query = conn.execute("SELECT * FROM signins;")
for row in query:
	print(row)
'''

# TODO: Read Bio 1 data into database




conn.close()

#TODO: For some reason, there is a space in front of all semester names. But for some Fall 2016 entries, there is not. So there are 2 fall 2016 semesters: 'Fall 2016' and ' Fall 2016'. Must take this away.


