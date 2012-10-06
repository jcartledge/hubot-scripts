# Description:
#   Listen for a github commit URL
#
# Dependencies:
#   "githubot"
#   "moment"
#
# Configuration:
#   HUBOT_GITHUB_TOKEN
#   HUBOT_GITHUB_USER
#
# Commands:
#   paste a github commit link in the presence of hubot
#
# Author:
#   jcartledge

module.exports = (robot) ->

  github = require('githubot')(robot)
  moment = require('moment')

  robot.hear /github.com\/([^\/]+)\/([^\/]+)\/commit\/(.*)/i, (msg) ->
    [url, owner, repo, sha] = msg.match
    url = "https://api.github.com/repos/#{owner}/#{repo}/commits/#{sha}"

    author = (commit) -> "By #{commit.author.name}"
    time = (commit) -> moment(commit.committer.date).fromNow()
    changes = (stats) ->
      message = []
      message.push "#{stats.additions} additions" if stats.additions > 1
      message.push "#{stats.additions} addition" if stats.additions == 1
      message.push "#{stats.deletions} deletions" if stats.deletions > 1
      message.push "#{stats.deletions} deletion" if stats.deletions == 1
      message.join(', ') + '.' if message

    github.get url, (resp) ->
      msg.send [
        author(resp.commit)
        time(resp.commit)
        changes(resp.stats)
      ].join "\n"
