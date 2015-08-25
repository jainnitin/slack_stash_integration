#!/bin/bash
# Notify commits to slack

# Set Slack channel, passed as 2nd argument
channel=$2
icon=$4

# Get push information from Git STDIN
read from_ref to_ref ref_name
if [[ $ref_name == *master* ]]
then
  # Generate commit list
  pushed_commits=`git log --format="%H %h \"%an\" \"%s\" \"%ar\"" $from_ref..$to_ref`
  commit_count=`echo "$pushed_commits" | wc -l`

  text="[<$3|${STASH_REPO_NAME}>] ${STASH_USER_NAME} <$STASH_USER_EMAIL> pushed $commit_count commit"
  if [ $commit_count -gt 1 ]; then text="${text}s"; fi
  text="${text} to ${ref_name#*/}"

  payload="payload={\"channel\":\"$channel\",\"text\":\"$text\",\"icon_emoji\":\"$icon\",\"attachments\":[{\"fallback\":\"Table of commits in this push.\",\"color\":\"good\",\"fields\":["

  # Indexes
  # [0] Full hash
  # [1] Abbrev hash
  # [2] Author name
  # [3] Commit message
  # [4] Author relative date
  comm_desc_col="{\"title\":\"Commit\",\"short\":true,\"value\":\""
  author_time_col="{\"title\":\"Author\",\"short\":true,\"value\":\""
  while read -r line; do
      eval array=($line)
      commit_link="<$3/commits/${array[0]}|${array[1]}>"
      comm_desc_col="${comm_desc_col}${commit_link}: ${array[3]}\n"
      author_time_col="${author_time_col}${array[2]}, ${array[4]}\n"
  done <<< "$pushed_commits"

  comm_desc_col="${comm_desc_col}\"},"
  author_time_col="${author_time_col}\"}"

  payload="${payload}${comm_desc_col}${author_time_col}]}]}"
  curl -X POST --data-urlencode "$payload" $1
fi
