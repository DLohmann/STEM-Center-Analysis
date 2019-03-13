import pandas as pd

# These links were helpful:
# https://www.datacamp.com/community/tutorials/python-excel-tutorial
# https://docs.python.org/2/library/stdtypes.html#set
# http://pandas.pydata.org/pandas-docs/version/0.16/indexing.html






roster_data = pd.read_excel('data/Bio1_Roster/Bio 001 Fall 2017-Learning Assistance-self reported.xlsx')

print(roster_data)

# Replace all nan values with empty string
roster_data = roster_data.fillna('')

# TODO: Rename column 1 to 'survey_result'



# ***** MAKE A SEPARATE COLUMN FOR EACH SURVEY RESPONSE (INSTEAD OF 1 COLUMN WITH ALL SURVEY RESPONSES) *****
# Find out what the possible responses were, by finding which responses were given
responses = set([])	# A set only keeps track of unique elements. No items are duplicated

for i in range(len(roster_data)):
	responseList = roster_data.loc[i][1].split(',')
	for item in responseList:
		responses.add(item)
		

# For students who did not check any category, the response will be the empty string. Remove the empty response from the set
if ('' in responses):
	responses.remove('')


#responses.columns

# For each response, add a column indicating that response's value into the dataframe
for response in responses:
	roster_data[response] = 0




for i in range(len(roster_data)):
	responseList = roster_data.loc[i][1].split(',')
	for item in responseList:
		roster_data.at[i, item] += 1

# Delete the column

# Write to a file, for viewing
writer = pd.ExcelWriter('example.xlsx')
roster_data.to_excel(writer, 'Sheet1')
writer.save()

