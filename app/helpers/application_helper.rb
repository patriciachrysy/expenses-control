module ApplicationHelper
  def back_button(url, icon_class = 'las la-arrow-left')
    link_to raw("<i class='#{icon_class}'></i>"), url, class: 'clear-button icon-button'
  end

  def right_button(url, icon_class = 'las la-arrow-left')
    link_to raw("<i class='#{icon_class}'></i>"), url, class: 'clear-button icon-button'
  end

  def right_submit_button(form, submit_text)
    form.submit submit_text, class: 'clear-button'
  end

  def menu_button
    '<button id="toggleSidebar" class="menu-button"><i class="las la-bars"></i></button>'.html_safe
  end

  def line_awesome_icons
    %w[home arrow-left heart wallet pen book building flower]
  end
end
