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
  moment = require 'moment'
  pc = (require 'pingdom-client').createClient process.env.PINGDOM_API_KEY,
    process.env.PINGDOM_USERNAME,
    process.env.PINGDOM_PASSWORD

  output = (check) -> """
    Site: #{check.name}
    Status: #{check.status}
    Response time: #{check.lastresponsetime}ms
    Last check: #{(moment.unix check.lasttesttime).fromNow()}
    Last error: #{(moment.unix check.lasterrortime).fromNow()}
    """

  robot.hear /pingdom (.+)/, (msg) ->
    console.log pc
    name_re = new RegExp msg.match[1].replace /[-[\]{}()*+?.,\\^$|#\s]/g, "\\$&"
    pc.getCheckList (err, checks) ->
      msg.send output check for check in checks.checks when check.name.match name_re
