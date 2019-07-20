#!/usr/bin/python

#Name: HyperStats
#Creators: Sandesh Hebbar <hebbarsandesh98@gmail.com>, Dheeraj Acharya <dheerajacharya78@gmail.com>
#Description: HyperV VM Resource Utilizaiton Statistics Reporter

import json
import paramiko
import getpass
from flask import Flask, g, jsonify, request    

app = Flask(__name__)

connected = False

ssh = paramiko.SSHClient()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())

ip = ""
user = ""
password = ""

def connectSSH(ip, user, password):
	try:
		ssh.connect(ip,username=user, password=password)
	except Exception as e:
		raise e
	else:
		global connected
		connected = True
		print("Connected to the client")

def shutdown_server():
    func = request.environ.get('werkzeug.server.shutdown')
    if func is None:
        raise RuntimeError('Not running with werkzeug server')
    func()

#initial HTML webpage that will further prompt the user to get the required report
@app.route('/')
def init():
	global connected
	if(connected == False):
		connectSSH(ip, user, password)
		
	str = "<html><body style=\"font-family: 'Courier New', Courier, monospace\"><br><div><img style=\"width: 15%; display: block; margin: 0 auto;\" alt=\"HyperStats Logo\" src=\"https://image.flaticon.com/icons/png/512/414/414183.png\" /><h1 style=\"text-align: center\">HyperStats</h1><p style=\"text-align: center\"><b>HyperV Resource Utilization Statistics Reporter</b></p><p style=\"text-align: center\"><b><span style=\"font-size: 20px\">&copy;</span> Sandesh Hebbar, Dheeraj Acharya</b></p><hr style=\"width: 70%\"></div><br><br><div><table style=\"width: 100%\"><thead></thead><tbody><tr><td style=\"width: 25%; text-align: center\"><div><h4>vCPU Usage</h4><button onclick=\"location.href='/cpustats'\">Get Report</button></div></td><td style=\"width: 25%; text-align: center\"><div><h4>Memory Parameters</h4><button onclick=\"location.href='/memstats'\">Get Report</button></div></td><td style=\"width: 25%; text-align: center\"><div><h4>Disk Utilization Information</h4><button onclick=\"location.href='/diskstats'\">Get Report</button></div></td><td style=\"width: 25%; text-align: center\"><div><h4>Network Statistics</h4><button onclick=\"location.href='/netstats'\">Get Report</button></div></td></tr></tbody></table></div></body></html>"
	return str

#an endpoint to shutdown the server (in case the terminal fails or in cases of exceptions)
@app.route('/system/shutdown')
def shutdwn():
    shutdown_server()

    str = "<html><body style=\"font-family: 'Courier New', Courier, monospace\"><br><div><img style=\"width: 15%; display: block; margin: 0 auto;\" alt=\"HyperStats Logo\" src=\"https://image.flaticon.com/icons/png/512/414/414183.png\" /><h2 style=\"text-align: center\">The server has been shut down successfully</h2></div></body></html>"
    return str

#returns network statistics in JSON format
@app.route('/netstats')
def network():

    try:
		global connected
		if(connected == False):
			connectSSH(ip, user, password)
		
		f = open("/usr/share/hyperstats/PowerShell_Scripts/networkStats.ps1", "r")
		script = f.read()
    except Exception as e:
        raise e
    else:
		cmd = 'powershell -InputFormat Text -OutputFormat Text ' + script
		stdin, stdout, stderr = ssh.exec_command(cmd)
		
		content = json.load(stdout)

		return jsonify(content)

#returns vCPU usage in JSON format
@app.route('/cpustats')
def cpu():

    try:
		global connected
		if(connected == False):
			connectSSH(ip, user, password)
		
		f = open("/usr/share/hyperstats/PowerShell_Scripts/cpuStats.ps1", "r")
		script = f.read()
    except Exception as e:
        raise e
    else:
		cmd = 'powershell -InputFormat Text -OutputFormat Text ' + script
		stdin, stdout, stderr = ssh.exec_command(cmd)
		
		content = json.load(stdout)

		return jsonify(content)

#returns memory parameters in JSON format
@app.route('/memstats')
def memory():

    try:
		global connected
		if(connected == False):
			connectSSH(ip, user, password)
		
		f = open("/usr/share/hyperstats/PowerShell_Scripts/memoryStats.ps1", "r")
		script = f.read()
    except Exception as e:
        raise e
    else:
		cmd = 'powershell -InputFormat Text -OutputFormat Text ' + script
		stdin, stdout, stderr = ssh.exec_command(cmd)
		content = json.load(stdout)

		return jsonify(content)

#returns disk utilization statistics in JSON format
@app.route('/diskstats')
def disk():

    try:
		global connected
		if(connected == False):
			connectSSH(ip, user, password)
		
		f = open("/usr/share/hyperstats/PowerShell_Scripts/diskUtilStats.ps1", "r")
		script = f.read()
    except Exception as e:
        raise e
    else:
		cmd = 'powershell -InputFormat Text -OutputFormat Text ' + script
		stdin, stdout, stderr = ssh.exec_command(cmd)
		content = json.load(stdout)

		return jsonify(content)

#specify the port in JSON format
if __name__ == "__main__":
	try:
		print("\x1b[1m"+"\n--------------------HyperStats--------------------" +"\x1b[0m")
		print("\x1b[3m"+"\nHyperV VM Resource Utlization Statistics Reporter\n" +"\x1b[0m")
		print("\x1b[1m"+"--------------------------------------------------\n"+"\x1b[0m")
		ip = raw_input("Target IP Address: ")
		user = raw_input("SSH Username: ")
		password = getpass.getpass('Password:')
		connectSSH(ip, user, password)
	except Exception as e:
		raise e
	else:		
		app.run(debug=False,host='0.0.0.0', port=9898)

