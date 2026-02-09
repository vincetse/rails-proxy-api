class RootController < ApplicationController
  def index
    json_response({})
  end

  include Response
  include ExceptionHandler
end
