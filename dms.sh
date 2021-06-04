#!/usr/bin/env bash

datapath="/usr/local/etc/dms"
dead_man_timestamp_path="${datapath}/dmt"
# Recommended: Any message you put in a message file should have a maximum of 80 characters per line.
dead_man_message_path="${datapath}/dmm"
dead_man_message_warning_path="${datapath}/dmm_warning"
# If you don't want to attach any files, set the variable to ()
# If you intend to share secrets, an encrypted file should be sent as attachment.
# The key should be known to the recipients beforehand.
dead_man_attachment_paths=("${datapath}/message.gpg" "/path/to/other/important/file")
warning_sent="${datapath}/wsent"
dms_sent="${datapath}/dmssent"

# In this case, the mail(s) have been sent already.
[ -f "${dms_sent}" ] && exit 0

dead_name="Your Name"
dead_address="${dead_name} <your@email.address>"
from_address="DMS <no-reply@email.address>"
send_addresses=("One <one@email.address>" "Two <two@email.address>" "Three <three@email.address>")

warningsubject="[DMS] Setting off in 24 hours!"
sentsubject="[DMS] The switch has been set off."
subjectline="${dead_name} is unresponsive, possible death."

[ ! -f "${dead_man_timestamp_path}" ] && echo "Timestamp file not found. Exiting." && exit 1
timestamp="$(cat "${dead_man_timestamp_path}")"
[ -z "${timestamp}" ] && echo "No timestamp in timestamp file. Exiting." && exit 1
time_now="$(date +%s)"

# In hours
time_diff=$(( ( "${time_now}" - "${timestamp}" ) / 3600 ))
# 336 hours are 14 days
if [ "$time_diff" -ge 336 ]; then
    mail_text="Last login: $(date --date="@${timestamp}")"$'\n'"$(cat "${dead_man_message_path}")"
    attachments=()
    for a in "${dead_man_attachment_paths[@]}"; do
        attachments+=('-a' "${a}")
    done
    for f in "${send_addresses[@]}"; do
        printf "%s\n" "${mail_text}" | mail -s "$subjectline" "${attachments[@]}" -r "$from_address" "$f"
    done
    mail -s "$sentsubject" -r "$from_address" "$dead_address" < /dev/null
    touch "${dms_sent}"
    exit 0
fi

# In this case, the mail has been sent already.
[ -f "${warning_sent}" ] && exit 0

# If the time difference has reached 336-24 hours before the send threshold, we send a warning (if not already done)
if [ "$time_diff" -ge 312 ]; then
    mail_text="Last login: $(date --date="@${timestamp}")"$'\n'"$(cat "${dead_man_message_warning_path}")"
    printf "%s\n" "${mail_text}" | mail -s "$warningsubject" -r "$from_address" "$dead_address"
    touch "${warning_sent}"
fi
