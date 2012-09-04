# Description:
#   Check status, uptime and response time from Pingdom
#
# Dependencies:
#   "pingdom": "0.6.2"
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
  moment = require 'moment'
  pc = require 'pingdom'

  output = (check) -> """
    Site: #{check.name}
    Status: #{check.status}
    Response time: #{check.lastresponsetime}ms
    Last check: #{(moment.unix check.lasttesttime).fromNow()}
    Last error: #{(moment.unix check.lasterrortime).fromNow()}
    """

  robot.hear /pingdom (.+)/, (msg) ->
    name_re = new RegExp msg.match[1].replace /[-[\]{}()*+?.,\\^$|#\s]/g, "\\$&"
    pc.getChecks(
      process.env.PINGDOM_API_KEY
      process.env.PINGDOM_USERNAME
      process.env.PINGDOM_PASSWORD
      {}
      (checks) ->
        msg.send output check for check in checks.checks when check.name.match name_re
    )
