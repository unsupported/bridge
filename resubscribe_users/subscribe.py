#!/usr/bin/env python3
# this script is unsupported and should be vetted by
# the organization or individual using it.
# working as of August 23rd, 2018
import datetime
import requests, json
import csv
import os

token = input("Enter your Bridge API token: ")
subdomain = input("Enter your subdomain (for example.bridgeapp.com, use 'example'): ")
filepath = input("Enter the CSV file path: ")

# do not edit below this comment unless you really know
# Python3 and want to modify the script at your own risk

# CSV sample:
# uid
# 12345
# 12346

base_url = 'https://{0}.bridgeapp.com/api/author'.format(subdomain)
headers = {'Authorization':token,'Content-Type':'application/json'}

err_list = []

if not os.path.isfile(filepath):
  raise ValueError('the file does not exist or the path is incorrect')

csvfile = open(filepath,mode='r',newline='', encoding='utf-8-sig')
the_list = csv.DictReader(csvfile)

def process_user_list(user_list):
  for row in user_list:
    payload = {'user':{'unsubscribed':False}}
    user = requests.patch(base_url + '/users/uid:' + row['uid'],data=json.dumps(payload),headers=headers)

    if(user.status_code == 200):
      print("User {i} is now subscribed".format(i=row['uid']))
    else:
      print("User {i} returned a status of {S}".format(i=row['uid'],S=user.status_code))
      err_list.append({'user_uid':row['uid'],'status':user.status_code, 'call':"PATCH /author/users"})

def write_error_log(error_list):
  with open('subscribe_errors_' + str(datetime.datetime.now()).replace(" ", "_") + '.csv',newline='',mode='w+') as err_file:
    fieldnames = ['user_uid','status','call']
    writer = csv.DictWriter(err_file, fieldnames=fieldnames)
    writer.writeheader()
    for row in error_list:
      writer.writerow(row)
    
process_user_list(the_list)
write_error_log(err_list)
