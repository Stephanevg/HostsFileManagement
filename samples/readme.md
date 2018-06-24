# Hosts File Samples to try out class

## Default hosts file
This file is just a copy of the default hosts file found in c:\windows\system32\drivers\etc.

## hosts01
This file has some invalid ipv4 Addresses. This will throw an exception.

>I was wondering if you want it to continue or stop when reading the hosts file. It should definitely throw if an invalid Entry is submitted. The host file can also be edited manually with wrong entries. Maybe you could use it as a way to parse invalid hosts files as well

## hosts02
In this file only the comment (#) wa removed from the beginning of the file. This generated an exception: "Cannot convert value ''".

## host03
Here the comment has been removed and the IP Address aligned to the left. This resolves the line corectly, but HostName and the FQDN is misaligned. I think white spaces is the culprit here...

>I'm not sure what the specifics are of creating a hosts file (it's been a while). Say if only the FQDN is specified, will you extrapolate the hostname from the FQDN?

# Creating you own hosts file samples
If you're using Notepad.exe to edit and save, make sure select 'All Files' from **Save as type** and place the file between quotations like so: _"hosts04"_