![alt tag](https://financesonline.com/uploads/2015/10/bridgeth.jpeg)

# Subscribe Users

The subscribe user script is used to update a CSV list of users in order to allow them to receive Bridge notifications. It will counteract the [Unsubscribe script] (https://github.com/unsupported/bridge/tree/master/unsubscribe_users)

# Requirements and usage

The subscribe script requires a Bridge API token to be generated with Account Admin set as the role.

A CSV file with 'uid' as the header for a single column containing the UID for the users you'd like to subscribe to notifications in Bridge, for example:
uid
123456
123457
email@sampleemail.com
email2@sampleemail2.com

Use cases:

- Reverse the unsubscribe script
- Perform notifications can only be turned off by unsubscribing the user. The subscribe script can be used if an admin only wants to temporarily stop Perform notifications to re-subscribe users.

# Error File Produced
This script will put an error CSV in the same folder as the script when it is complete.

# Bridge
Bridge is a new LMS geared towards the corporate space. For additional information,
visit [https://www.getbridge.com/](https://www.getbridge.com/)

# Support
As always, all the files are provided AS-IS, without warranty, and without any support beyond this
document and anyone kind enough to help from the community.

This is an unsupported, community-created project. Keep that in mind. Instructure won't be
able to help you fix or debug this. That said, the community will hopefully help support
and keep both the script and this documentation up-to-date.

Good luck!
