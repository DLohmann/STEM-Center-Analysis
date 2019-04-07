
# Data reading, cleaning, and processing
import pandas as pd

# Database access
import sqlite3

# These links were helpful:
# https://www.datacamp.com/community/tutorials/python-excel-tutorial
# https://docs.python.org/2/library/stdtypes.html#set
# http://pandas.pydata.org/pandas-docs/version/0.16/indexing.html
# https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.rename.html
# https://pandas.pydata.org/pandas-docs/stable/user_guide/indexing.html


# ***** Reads a survey file, and returns it as a pandas dataframe *****
def read_bio1_survey_as_df(file_name_and_path, semester):

	survey_data = pd.read_excel(file_name_and_path)


	# Replace all nan values with empty string
	survey_data = survey_data.fillna('')

	# Somehow, the renaming causes rows AND columns to be accessed by string (ie survey_data.loc['1']['survey_result']), but we can always use the iloc function to access by index now (ie survey_data.iloc[1][1])
	# Rename column 1 to 'survey_result'
	#survey_data = survey_data.rename(index=str, columns={survey_data.columns[1] : 'survey_result'})
	
	
	# ***** MAKE A SEPARATE COLUMN FOR EACH SURVEY RESPONSE (INSTEAD OF 1 COLUMN WITH ALL SURVEY RESPONSES) *****
	# Find out what the possible responses were, by finding which responses were given
	responses = set([])	# A set only keeps track of unique elements. No items are duplicated

	for i in range(len(survey_data)):
		#print ("row " + str(i) + " : " + str(survey_data.at[i, 1]) + " of type: " + str(type(survey_data.at[i, 1])) )
		responseList = survey_data.iloc[i][1].split(',')
		for item in responseList:
			responses.add(item)
			

	# For students who did not check any category, the response will be the empty string. Remove the empty response from the set
	if ('' in responses):
		responses.remove('')


	#responses.columns

	# For each response, add a column indicating that response's value into the dataframe
	for response in responses:
		survey_data[response] = 0.0	# Set all survey responses, initially, to 0 (no) before setting 1 (yes) results later



	# Set the column corresponding to each survey question. 0 = no, 1 = yes
	for i in range(len(survey_data)):
		responseList = survey_data.iloc[i][1].split(',')
		
		if ('' in responseList):	# remove empty entries, for students who did not choose any option
			responseList.remove('')
		
		for item in responseList:
			survey_data.iat[i, survey_data.columns.get_loc(item) ] += 1
			#survey_data.at[i, item] = 1.0

	# Remove the column with the original string of all survey results
	#survey_data.drop(columns=['survey_result'])
	survey_data = survey_data.drop(columns=[survey_data.columns[1]])


	# Get the semester, and add a semester column
	survey_data["Semester"] = semester

	# Remove spaces and slashes from column names
	column_name_mapping = {survey_data.columns[i] : survey_data.columns[i].replace(' ', '_').replace('/', '_') for i in range(len(survey_data.columns))}	# create a dictionary mapping old column names to new column names
	survey_data = survey_data.rename(index=str, columns=column_name_mapping)	# Rename old column names to new column names (same name, but all special characters are replaced with "_")
	
	# TODO: Delete the index column, so it will not be in the database
	
	return survey_data


# ***** Reads a roster file, and returns it as a pandas dataframe *****
def read_bio1_roster_as_df(file_name_and_path, semester):
	roster_data = pd.read_excel(file_name_and_path)
	
	# Replace all nan values with empty string
	roster_data = roster_data.fillna('')
	
	# Split first name and last name into separate columns
	roster_data = roster_data["Student"].str.split(", ", n=1, expand=True)
	
	# Rename the columns
	column_name_mapping = {0:"Last_Name", 1:"First_Name"}	# create a dictionary mapping old column names to new column names
	roster_data = roster_data.rename(index=str, columns=column_name_mapping)	# Rename old column names to new column names (same name, but all special characters are replaced with "_")
	
	# Get the semester, and add a semester column
	roster_data["Semester"] = semester
	
	return roster_data


# Show all data
file_path = r'data/Bio1_Survey/'

survey_files = [[r'Bio 001 Fall 2017-Learning Assistance-self reported.xlsx', r'Fall 2017'], [r'Bio 001 Spring 2018-Learning Assistance-self reported.xlsx', r'Spring 2018']]


# ***** INSERTING INTO DATABASE *****



# Connect to database
conn = sqlite3.connect("STEM_Center.db")

# ***** ADD ALL SURVEY DATA *****
for semester_file in survey_files:
	survey_data = read_bio1_survey_as_df( (file_path + semester_file[0]), semester = semester_file[1])
	#print(survey_data)
	
	# Write to a file, for viewing
	#writer = pd.ExcelWriter('example.xlsx')
	#survey_data.to_excel(writer, 'Sheet1')
	#writer.save()
	#print("wrote to \'example.xlsx\' file")
	
	# write to database
	survey_data.to_sql('bio1survey', con=conn, if_exists='append')

	



# ***** ADD ALL ROSTER DATA *****
file_path = r'data/Bio1_Roster/'
roster_files = [[r'Bio 001 Fall 2017-Roster.xlsx', r'Fall 2017'], [r'Bio 001 Spring 2018-Roster.xlsx', r'Spring 2018']]

for semester_file in roster_files:
	roster_data = read_bio1_roster_as_df( (file_path + semester_file[0]), semester = semester_file[1])
	#print(roster_data)
	
	
	# write to database
	roster_data.to_sql('bio1roster', con=conn, if_exists='append')
	


conn.close()

