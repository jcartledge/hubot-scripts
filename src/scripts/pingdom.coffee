# Description:
#   Check status, uptime and response time from Pingdom
#
# Dependencies:
#   "pingdom-client": "0.1.0"
#   "moment": "1.7.0"
#
# Configuration:
#   PINGDOM_API_KEY
#   PINGDOM_USERNAME
#   PINGDOM_PASSWORD
#
# Commands:
#   pingdom sitename
#
# Author:
#   jcartledge

module.exports = (robot) ->
  pc = (require 'pingdom-client').createClient(
    process.env.PINGDOM_API_KEY,
    process.env.PINGDOM_USERNAME,
    process.env.PINGDOM_PASSWORD)
  moment = require 'moment'

  robot.hear /pingdom (.+)/, (msg) ->
    output = (check) ->
      msg.send "Site: #{check.name}"
      msg.send "Status: #{check.status}"
      msg.send "Response time: #{check.lastresponsetime}ms"
      msg.send "Last check: #{(moment.unix check.lasttesttime).fromNow()}"
      msg.send "Last error: #{(moment.unix check.lasterrortime).fromNow()}"

    name_re = new RegExp msg.match[1].replace /[-[\]{}()*+?.,\\^$|#\s]/g, "\\$&"
    pc.getCheckList (err, checks) ->
      output check for check in checks.checks when check.name.match name_re
