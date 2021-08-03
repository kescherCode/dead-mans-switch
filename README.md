# dead-mans-switch

A simple dead man's switch, set off using periodic script executions (using cron or systemd timers).

## Dependencies

`date`, any `mailx` provider (such as `s-nail`).
Optional (when using the DNS killswitch feature): `dig`, often offered by the `bind` package on many Linux distros.

## A simple what?

Yes, you read that right. If you don't know what a dead man's switch is:
In real life, it's a simple device that does an action when a button is no longer pressed.
A dark example of this is often seen in TV series related to crime, where a hostage taker
announces that they have a dead man's switch connected to a bomb,
therefore making a raid of the hostages' location impossible.

However, this dead man's switch is not hooked up to a bomb. No, it serves a much more useful
purpose. When it notices that you're dead, it will send a predefined message along with it,
as well as potentially one or more attachments, to one or more recipients via email.

## How does it work?

First, you set up the script `dms-update.sh` somewhere (with a changed path, if needed).
Afterwards, you run either run it manually every once in a while, or launch it in your bashrc.
This will put the timestamp of your "last sign of life" into a file everytime it is run.

Now the script `dms.sh` comes into play, which also has to be set up somewhere.
This one can be run by a cronjob, possibly being run every few hours or so.
It should be edited before being placed as a cronjob, updating all appropriate paths, names and email addresses.

If the script detects that the "last sign of life" has become old, an email will be sent out to you in order to
warn you that the dead man's switch will set off in 24 hours. This is to prevent accidentally setting the switch off.
After the warning period passes, the switch will be set off and email all configured addresses with the predefined message and attachments.
It will also send an info to yourself that the switch has been set off, in case you are, in fact, still alive.

## Why did you make this?
Some people I told about this project thought I might be suicidal or scared of being murdered by someone.
**This is not the case.**
I simply want to make sure that my infrastructure and other stuff is not left running unmaintained for too long if something happens to me.
I also want to easily make my personal files available to my loved ones in such a case.

As such, my setup is that the predefined message is a message giving info about the switch's purpose,
what likely happened to me and instructions on how to proceed with the attached files.
The first attached file is an encrypted message, the decryption key of which the recipients received beforehand.
The second attached file is a password manager database.

## If this was for you, why did you publish this?
That's because all the other "dead man's switch" repositories I've found online simply didn't fit my needs.
I can't imagine I'm the only one that needs this project, so it's licensed under the WTFPL. Enjoy!

## Donate
You feel like being generous or want to support me on stuff like free software development and hosting mirrors?
In that case, please check the GitHub sidebar for this repo or my [website](https://kescher.at/#donate).
