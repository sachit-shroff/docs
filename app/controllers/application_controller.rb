class ApplicationController < ActionController::Base
  helper_method :probably_authenticated?

  def route_not_found
    render file: Rails.root.join("public","404.html"), layout: false, status: 404
  end

  private

  def default_nav
    Rails.application.config.default_nav
  end

  # capture some extra data so we can log it with lograge
  def append_info_to_payload(payload)
    super

    # Use the request ID generated by the aamzon ALB, if available
    payload[:request_id] = request.headers.fetch("X-Amzn-Trace-Id", request.request_id)
    payload[:remote_ip] = request.remote_ip
    payload[:user_agent] = request.user_agent
  end


  # When you login to Buildkite, we set this cookie as an indicator for other
  # services that the user *may* be logged in.
  def probably_authenticated?
    request.cookie_jar[:bk_logged_in] == "true"
  end
end
