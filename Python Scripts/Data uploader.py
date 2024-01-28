import gspread
import firebase_admin
from firebase_admin import db
import random
from oauth2client.service_account import ServiceAccountCredentials



cred_obj = firebase_admin.credentials.Certificate('/mnt/7B466E99795271A1/Makerspace/agneepath_security_app/Python Scripts/agneepath-2024-firebase-adminsdk-mz69y-01fd8027f5.json')
default_app = firebase_admin.initialize_app(cred_obj, {
	'databaseURL':'https://agneepath-2024-default-rtdb.asia-southeast1.firebasedatabase.app/'
	})
# Set up credentials
scope = ['https://spreadsheets.google.com/feeds',
         'https://www.googleapis.com/auth/drive']
creds = ServiceAccountCredentials.from_json_keyfile_name('/mnt/7B466E99795271A1/Makerspace/agneepath_security_app/Python Scripts/agneepath-2024-fab0c98b676f.json', scope)

# Create a client
client = gspread.authorize(creds)

# Open the Google Sheet
sheet = client.open('TeamInfo-combined').sheet1

# Get all records
records = sheet.get_all_records()
ref=db.reference('Guests')
# Print records
for i in records:
    
    ref.update({i['ID']:{'Name':i['Name'],'Batch':i['Batch'],'Designation':i['Designation '],'PhoneNo':i['Contact no.'],'Current Status':'out'}})
    print(id)