# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def show_header?
    params[:controller] !~ /(sessions|users)/
  end

end
