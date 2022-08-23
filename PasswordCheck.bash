#!/bin/bash

# Name: PasswordCheck.bash
# Version: 1.0
# Created: 08-22-2022 by Michael Permann
# Updated: 08-22-2022
# The script is for checking whether the end user's password is a known password. Parameter 4 is the password
# that needs to be checked. The current logged in user and results of the password validation are written to 
# a plist file to be read from later with an extension attribute.

CURRENT_USER=$(scutil <<< "show State:/Users/ConsoleUser" | awk '/Name :/ && ! /loginwindow/ { print $3 }')
USER_ID=$(/usr/bin/id -u "$CURRENT_USER")
USER_PASS=$4
PLIST="/Library/Application Support/HeartlandAEA11/Reporting/PasswordCheck.plist"

isPasswordKnown() {
PASSWORD_CHECK_RESULT=$(/usr/bin/dscl /Search -authonly "$CURRENT_USER" "$USER_PASS")
if [ -n "$PASSWORD_CHECK_RESULT" ] # Check whether result of command string length is non-zero.
then
    # Since PASSWORD_CHECK_RESULT string length is non-zero, the password is not known.
    echo 0
else
    # Since PASSWORD_CHECK_RESULT string length is zero, the password is known.
    echo 1
fi
}

createPasswordCheckPlist() {
/usr/libexec/PlistBuddy -c "Add :CurrentUser string $CURRENT_USER" "$PLIST"
/usr/libexec/PlistBuddy -c "Add :PasswordKnown string $RESULT" "$PLIST"
echo "PasswordCheck file created."
}

PasswordCheckPlistExists(){
    if [ -e "$PLIST" ]
    then
        /usr/libexec/PlistBuddy -c "Set :CurrentUser $CURRENT_USER" "$PLIST"
        /usr/libexec/PlistBuddy -c "Set :PasswordKnown $RESULT" "$PLIST"
    else
        createPasswordCheckPlist
    fi
}

if [ "$(isPasswordKnown)" = 1 ]
then
    echo "Password is known."
    RESULT="YES"
    PasswordCheckPlistExists
else
    echo "Password unknown."
    RESULT="NO"
    PasswordCheckPlistExists
fi
