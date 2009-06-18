# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def display_flash(flash)
    if !flash[:notice].blank?
      flash_wrapper("notice", flash[:notice])
    elsif !flash[:warning].blank?
      flash_wrapper("warning", flash[:warning])
    elsif !flash[:error].blank?
      flash_wrapper("error", flash[:error])
    end
  end
  
  def flash_wrapper(flash_type, message)
    "<div class=\"#{flash_type}\">#{message}</div>"
  end
  
end
