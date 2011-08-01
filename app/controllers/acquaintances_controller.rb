class AcquaintancesController < ApplicationController
  def find
    @infos = rest_graph.get('me')
  end
end
