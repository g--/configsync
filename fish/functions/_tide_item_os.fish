function _tide_item_os
    _tide_detect_os | read -l os_icon os_color os_bg_color
    _tide_print_item os $os_icon
end
