# Slack Stash Integration

Integrate Stash with Slack using Webhooks. Additions to the Gist from [@molaschi](https://github.com/molaschi)
https://gist.github.com/molaschi/f1a296c6f09d2aa92875

## Requirements

- a working stash installation
- a repository you to notify slack on pushes
- stash user with administration priviledges
- full access to the server (linux) where stash is installed on
- a team configured on slack
- slack user with administration priviledges
 
## Prepare your stash server ##

- Download the script on your Stash server e.g.
```
wget https://raw.githubusercontent.com/jainnitin/slack_stash_integration/master/stash_slack.sh
```
- Make it executable
```
chmod +x stash_slack.sh
```

## Configure Slack ##
1. Access to slack: 
https://*YOUR_TEAM*.slack.com/services/new (replace YOUR_TEAM with your team name)
2. Select "Incoming WebHooks"
3. Choose a channel from drop-down and click "Add incoming WebHook"
4. You have a new webhook configured! Copy the URL under "Your Unique Webhook URL"

## Configure Stash ##
1. Access to stash web interface
2. Go to your repository
3. Click on Settings
4. Click on Hooks
5. Click on "Add Hook" button and then on "Search"
6. Search for "External Hooks" and click "Install"
7. Once installed, go back to Hooks page in your repository
8. Click on "Enable" on the "External **Post Receive** Hook" row (not pre-receive)
9. Put the full path to the stash_slack.sh executable script in "Executable" field: e.g. `/home/stashuser/bin/stash_slack.sh`
10. Fill "Positional Parameters" with:
    - 1st line: Web hook url you copied at last point in previous paragraph
    - 2nd line: Channel name (#general)
    - 3rd line: full path to your web interface repository page (without trailing slash)
    - 4th line: emoji for your notification (:rocket:)
```
https://openmindonline.slack.com/services/hooks/incoming-webhook?token=6PPy9nEngOuRhl79XbSPrRCK
#general
https://your_stash_server/projects/ACME/repos/foo
:rocket:
```

Everything should work and when you push something, you should be able to get notification like

![Slack Image](https://raw.githubusercontent.com/jainnitin/slack_stash_integration/master/slack_notification.png)

