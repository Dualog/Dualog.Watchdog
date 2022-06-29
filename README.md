# Dualog Watchdog

Powershell script for monitoring Dualog services. 


## **What problem does it solve**

Some old computers with bad hardware (often running Win7) have a hard time starting our Ship Clients (Dualog Access, Drive, Protect).
They tend to use longer time than windows allows for starting up (30s) and other times they crash and cannot recover by themselves.
This leads to the customer having to remote in to the computer to start the service.

See https://github.com/Dualog/Dualog.Watchdog/issues/1 for common errors.

## **Installing**

To install this script you need an administrator account on the computer you are deploying it to.
The script has to be trusted and a scheduled task has to be set up on the computer to run this script.


Script must be located under `C:\Dualog\Watchdog\watchdog.ps1`

### **Setting up Windows Task Scheduler**

Copy the `watchdog.xml` file to the host computer then import it via Schedule Tasks in Windows:

![Screenshot](https://user-images.githubusercontent.com/17533404/145787089-9511a58c-d5b3-400b-8bc9-4f72eb08b17e.png)
