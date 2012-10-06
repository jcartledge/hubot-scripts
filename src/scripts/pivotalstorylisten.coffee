# Description:
#   Listen for a specific story from PivotalTracker
#
# Dependencies:
#   "xml2js"
#
# Configuration:
#   HUBOT_PIVOTAL_TOKEN
#
# Commands:
#   paste a pivotal tracker link or type "sid-####" in the presence of hubot
#
# Authors:
#   christianchristensen
#   jcartledge

module.exports = (robot) ->
  robot.hear /(sid-|SID-|pivotaltracker.com\/story\/show)/i, (msg) ->
    Parser = require("xml2js").Parser
    token = process.env.HUBOT_PIVOTAL_TOKEN
    story_id = msg.message.text.match(/\d+$/) # look for some numbers in the string

    dump_error = (err) ->
      msg.send("Pivotal says: #{err}")
      return

    story_url = (project_id, story_id) ->
      "https://www.pivotaltracker.com/services/v3/projects/#{project.id}/stories/#{story.id}"

    projects_cb =  (err, res, body) ->
      return dump_error(err) if err
      (new Parser).parseString body, (err, json)->
        for project in json.projects.project
          msg.http(story_url(project.id, story_id))
            .headers("X-TrackerToken": token)
            .get() story_cb

    story_cb = (err, res, body) ->
      return dump_error(err) if err
      if res.statusCode != 500
        (new Parser).parseString body, (err, story)->
          story = story.story
          return if !story.id
          message = "##{story.id[0]['_']} \"#{story.name}\""
          message += " (#{story.owned_by})" if story.owned_by
          message += " is #{story.current_state}" if story.current_state
          msg.send message
          return

    msg.http("http://www.pivotaltracker.com/services/v3/projects")
      .headers("X-TrackerToken": token)
      .get() projects_cb
