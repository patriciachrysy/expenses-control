module ApplicationHelper
  def back_button(url, icon_class = 'las la-arrow-left')
    link_to raw("<i class='#{icon_class}'></i>"), url, class: 'clear-button icon-button'
  end

  def right_button(url, text)
    link_to text, url, class: 'clear-button'
  end

  def right_submit_button(form, submit_text)
    form.submit submit_text, class: 'clear-button'
  end
end
