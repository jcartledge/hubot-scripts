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

    github.get url, (resp) ->

      time = moment(resp.commit.committer.date).fromNow()
      msg.send "#{resp.commit.author.name} #{time}."

      msg.send resp.commit.message

      message = []
      message.push "#{resp.stats.additions} additions" if resp.stats.additions > 1
      message.push "#{resp.stats.additions} addition" if resp.stats.additions == 1
      message.push "#{resp.stats.deletions} deletions" if resp.stats.deletions > 1
      message.push "#{resp.stats.deletions} deletion" if resp.stats.deletions == 1
      msg.send message.join(', ') + '.' if message
