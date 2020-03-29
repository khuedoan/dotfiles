#+----------+
#| SETTINGS |
#+----------+

c.auto_save.session = True
config.set('content.autoplay', False)
c.input.insert_mode.auto_load = True
c.tabs.mode_on_change = 'restore'
c.hints.chars = 'sadfjklewcmpgh;'
c.hints.uppercase = True
c.statusbar.widgets = ['keypress', 'history', 'tabs', 'progress']
c.tabs.background = True
c.url.default_page = 'https://www.google.com/'
c.url.searchengines = {'DEFAULT': 'https://www.google.com/search?q={}'}
c.url.start_pages = 'https://www.google.com/'

# Notifications
config.set('content.notifications', True, 'https://www.reddit.com')
config.set('content.notifications', True, 'https://www.facebook.com')
config.set('content.notifications', True, 'https://www.youtube.com')
config.set('content.notifications', True, 'https://www.messenger.com')

#+--------------+
#| KEY BINDINGS |
#+--------------+

config.bind('M', 'hint links spawn umpv {hint-url}')
config.bind('<Ctrl+Tab>', 'tab-next')
config.bind('<Ctrl+Shift+Tab>', 'tab-prev')

#+-------+
#| THEME |
#+-------+

# Palette
colors = {
    'black': '#282a36',
    'red': '#ff5555',
    'green': '#50fa7b',
    'yellow': '#f1fa8c',
    'blue': '#bd93f9',
    'magenta': '#ff79c6',
    'cyan': '#8be9fd',
    'white': '#f8f8f2',
    'background': "#282a36",
    'foreground': "#f8f8f2",
}

palette = {
    'background': '#282a36',
    'background-alt': '#282a36',
    'background-attention': '#181920',
    'border': '#282a36',
    'current-line': '#44475a',
    'selection': '#44475a',
    'foreground': '#f8f8f2',
    'foreground-alt': '#e0e0e0',
    'foreground-attention': '#ffffff',
    'comment': '#6272a4',
    'cyan': '#8be9fd',
    'green': '#50fa7b',
    'orange': '#ffb86c',
    'pink': '#ff79c6',
    'purple': '#bd93f9',
    'red': '#ff5555',
    'yellow': '#f1fa8c'
}


# Completion
c.colors.completion.category.bg = palette['background']
c.colors.completion.category.border.bottom = palette['border']
c.colors.completion.category.border.top = palette['border']
c.colors.completion.category.fg = palette['foreground']
c.colors.completion.even.bg = palette['background']
c.colors.completion.odd.bg = palette['background-alt']
c.colors.completion.fg = palette['foreground']
c.colors.completion.item.selected.bg = palette['selection']
c.colors.completion.item.selected.border.bottom = palette['selection']
c.colors.completion.item.selected.border.top = palette['selection']
c.colors.completion.item.selected.fg = palette['foreground']
c.colors.completion.match.fg = palette['orange']
c.colors.completion.scrollbar.bg = palette['background']
c.colors.completion.scrollbar.fg = palette['foreground']

# Downloads
c.colors.downloads.bar.bg = palette['background']
c.colors.downloads.error.bg = palette['background']
c.colors.downloads.error.fg = palette['red']
c.colors.downloads.stop.bg = palette['background']
c.colors.downloads.system.bg = 'none'

# Hints
c.colors.hints.bg = palette['background']
c.colors.hints.fg = palette['foreground']
c.hints.border = '1px solid ' + palette['background-alt']
c.colors.hints.match.fg = palette['purple']
c.colors.keyhint.bg = palette['background']
c.colors.keyhint.fg = palette['purple']
c.colors.keyhint.suffix.fg = palette['selection']

# Messages
c.colors.messages.error.bg = palette['background']
c.colors.messages.error.border = palette['background-alt']
c.colors.messages.error.fg = palette['red']
c.colors.messages.info.bg = palette['background']
c.colors.messages.info.border = palette['background-alt']
c.colors.messages.info.fg = palette['comment']
c.colors.messages.warning.bg = palette['background']
c.colors.messages.warning.border = palette['background-alt']
c.colors.messages.warning.fg = palette['red']

# Prompts
c.colors.prompts.bg = palette['background']
c.colors.prompts.border = '1px solid ' + palette['background-alt']
c.colors.prompts.fg = palette['cyan']
c.colors.prompts.selected.bg = palette['selection']

# Status bar
c.colors.statusbar.caret.bg = palette['background']
c.colors.statusbar.caret.fg = palette['orange']
c.colors.statusbar.caret.selection.bg = palette['background']
c.colors.statusbar.caret.selection.fg = palette['orange']
c.colors.statusbar.command.bg = palette['background']
c.colors.statusbar.command.fg = palette['pink']
c.colors.statusbar.command.private.bg = palette['background']
c.colors.statusbar.command.private.fg = palette['foreground-alt']
c.colors.statusbar.insert.bg = palette['foreground-attention']
c.colors.statusbar.insert.fg = palette['background-attention']
c.colors.statusbar.normal.bg = palette['background']
c.colors.statusbar.normal.fg = palette['foreground']
c.colors.statusbar.passthrough.bg = palette['background']
c.colors.statusbar.passthrough.fg = palette['orange']
c.colors.statusbar.private.bg = palette['background-alt']
c.colors.statusbar.private.fg = palette['foreground-alt']
c.colors.statusbar.progress.bg = palette['background']
c.colors.statusbar.url.error.fg = palette['red']
c.colors.statusbar.url.fg = palette['foreground']
c.colors.statusbar.url.hover.fg = palette['cyan']

# Tabs
c.colors.tabs.bar.bg = palette['selection']
c.colors.tabs.even.bg = palette['selection']
c.colors.tabs.even.fg = palette['foreground']
c.colors.tabs.indicator.error = palette['red']
c.colors.tabs.indicator.start = palette['orange']
c.colors.tabs.indicator.stop = palette['green']
c.colors.tabs.indicator.system = 'none'
c.colors.tabs.odd.bg = palette['selection']
c.colors.tabs.odd.fg = palette['foreground']
c.colors.tabs.selected.even.bg = palette['background']
c.colors.tabs.selected.even.fg = palette['foreground']
c.colors.tabs.selected.odd.bg = palette['background']
c.colors.tabs.selected.odd.fg = palette['foreground']
c.colors.tabs.pinned.even.bg = palette['selection']
c.colors.tabs.pinned.even.fg = palette['foreground']
c.colors.tabs.pinned.odd.bg = palette['selection']
c.colors.tabs.pinned.odd.fg = palette['foreground']
c.colors.tabs.pinned.selected.even.bg = palette['background']
c.colors.tabs.pinned.selected.even.fg = palette['foreground']
c.colors.tabs.pinned.selected.odd.bg = palette['background']
c.colors.tabs.pinned.selected.odd.fg = palette['foreground']
