# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def show_header?
    params[:controller] !~ /(sessions|users)/
  end

  def sort_link(title, column, options = {})
    condition = options[:unless] if options.has_key?(:unless)
    sort_dir = params[:d] == 'up' ? 'down' : 'up'
    link_to_unless condition, title, request.parameters.merge( {:c => column, :d => sort_dir} )
  end
end
