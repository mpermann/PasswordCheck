#!/bin/bash

# Name: PasswordCheckEA.bash
# Version: 1.0.1
# Created: 08-23-2022 by Michael Permann
# Updated: 07-13-2024
# The script is meant to be run as an extension attribute in Jamf Pro. It's for reporting on whether 
# the end user's password is a known password. The data is read from a plist file that was created
# when the PasswordCheck.bash script was run. The output is $USERNAME YES/NO $DATE or NA if the plist
# file doesn't exist.

PLIST="/Library/Management/PCC/Reports/PasswordCheck.plist"
USER_WHEN_RUN=$(/usr/bin/defaults read "/Library/Management/PCC/Reports/PasswordCheck.plist" 'CurrentUser')
PASSWORD_KNOWN=$(/usr/bin/defaults read "/Library/Management/PCC/Reports/PasswordCheck.plist" 'PasswordKnown')
DATE_STAMP=$(/usr/bin/defaults read "/Library/Management/PCC/Reports/PasswordCheck.plist" 'Date')

if [ -e "$PLIST" ]
    then
        echo "<result>$PASSWORD_KNOWN $USER_WHEN_RUN $DATE_STAMP</result>"
    else
        echo "<result>NA</result>"
fi
