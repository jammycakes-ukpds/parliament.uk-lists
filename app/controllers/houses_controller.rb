class HousesController < ApplicationController
  before_action :data_check, :build_request

  ROUTE_MAP = {
    index:             proc { ParliamentHelper.parliament_request.houses },
    lookup_by_letters: proc { |params| ParliamentHelper.parliament_request.houses.partial(params[:letters]) }
  }.freeze

  def index
    @houses = @request.get.sort_by(:name)
  end

  def lookup_by_letters
    data = @request.get

    if data.size == 1
      redirect_to house_path(data.first.graph_id)
    else
      redirect_to houses_path
    end
  end
end