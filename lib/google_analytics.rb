require 'sucker_punch'
require 'rest-client'

class AnalyticsJob
  include SuckerPunch::Job

  def perform(ga_id, request, client_id, timestamp)
    return unless ga_id.present?

    # See https://developers.google.com/analytics/devguides/collection/protocol/v1/parameters
    params = {
      v: 1,                                       # Protocol version
      tid: ga_id,                                 # Google Analytics tracking id
      cid: client_id,                             # Unique client id
      dr: request.referrer,                       # Document referrer
      t: 'pageview',                              # Hit type
      ni: 1,                                      # This request is non-interactive
      dl: request.url,                            # Document location
      dh: request.host,                           # Hostname
      dp: request.path,                           # Document page address
      qt: ((::Time.now - timestamp)*1000).to_i,   # Queue time delta (ms)
      z: (rand*1000000000000).to_i                # Cache buster (just random number)
    }

    ::RestClient.get(
        'http://www.google-analytics.com/collect',
        params: params, timeout: 5, open_timeout: 5,
        user_agent: request.user_agent
    )
  end
end