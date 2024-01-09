module ApplicationHelper
    def back_button(url, icon_class = 'la la-arrow-left')
        link_to raw("<i class='#{icon_class}'></i>"), url, class: 'clear-button icon-button'
    end

    def right_button(url, text)
        link_to text, url, class: 'clear-button'
    end
end
