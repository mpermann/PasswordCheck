#!/bin/bash

# Name: PasswordCheckEA.bash
# Version: 1.0
# Created: 08-23-2022 by Michael Permann
# Updated: 08-23-2022
# The script is meant to be run as an extension attribute in Jamf Pro. It's for reporting on whether 
# the end user's password is a known password. The data is read from a plist file that was created
# when the PasswordCheck.bash script was run. The output is $USERNAME YES/NO $DATE or NA if the plist
# file doesn't exist.

PLIST="/Library/Application Support/HeartlandAEA11/Reporting/PasswordCheck.plist"
USER_WHEN_RUN=$(/usr/bin/defaults read "/Library/Application Support/HeartlandAEA11/Reporting/PasswordCheck.plist" 'CurrentUser')
PASSWORD_KNOWN=$(/usr/bin/defaults read "/Library/Application Support/HeartlandAEA11/Reporting/PasswordCheck.plist" 'PasswordKnown')
DATE_STAMP=$(/usr/bin/defaults read "/Library/Application Support/HeartlandAEA11/Reporting/PasswordCheck.plist" 'Date')

if [ -e "$PLIST" ]
    then
        echo "<result>$USER_WHEN_RUN $PASSWORD_KNOWN $DATE_STAMP</result>"
    else
        echo "<result>NA</result>"
fi
