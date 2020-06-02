#+----------+
#| SETTINGS |
#+----------+

# General
c.auto_save.session = True
c.content.autoplay = False
c.input.insert_mode.auto_load = True

# Hints
c.hints.chars = 'sadfjklewcmpgh;'
c.hints.uppercase = True

# Status bar
c.statusbar.widgets = ['keypress', 'history', 'tabs', 'progress']

# Downloads
c.downloads.position = 'bottom'

# Tabs
c.tabs.position = 'left'
c.tabs.width = '20%'
c.tabs.background = True
c.tabs.mode_on_change = 'restore'
c.tabs.padding = {'top': 3, 'right': 3, 'bottom': 3, 'left': 3}
c.tabs.indicator.width = 1
c.tabs.indicator.padding = {"bottom": 0, "left": 0, "right": 10, "top": 0}

# URL
c.url.searchengines = {'DEFAULT': 'https://www.google.com/search?q={}'}
c.url.start_pages = 'https://www.google.com/'
c.url.default_page = 'https://www.google.com/'

# Notifications
config.set('content.notifications', True, 'https://www.facebook.com')
config.set('content.notifications', True, 'https://www.instagram.com')
config.set('content.notifications', True, 'https://www.messenger.com')
config.set('content.notifications', True, 'https://www.reddit.com')
config.set('content.notifications', True, 'https://www.youtube.com')

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
black = '#282a36'
red = '#ff5555'
green = '#50fa7b'
yellow = '#f1fa8c'
blue = '#bd93f9'
magenta = '#ff79c6'
cyan = '#8be9fd'
white = '#f8f8f2'
background = "#282a36"
foreground = "#f8f8f2"

# Completion
c.colors.completion.category.bg = background
c.colors.completion.category.fg = foreground
c.colors.completion.category.border.bottom = background
c.colors.completion.category.border.top = background
c.colors.completion.even.bg = background
c.colors.completion.odd.bg = background
c.colors.completion.fg = foreground
c.colors.completion.item.selected.bg = foreground
c.colors.completion.item.selected.border.bottom = foreground
c.colors.completion.item.selected.border.top = foreground
c.colors.completion.item.selected.fg = background
c.colors.completion.match.fg = green
c.colors.completion.scrollbar.bg = background
c.colors.completion.scrollbar.fg = foreground

# Downloads
c.colors.downloads.bar.bg = background
c.colors.downloads.error.bg = background
c.colors.downloads.error.fg = red
c.colors.downloads.stop.bg = background
c.colors.downloads.system.bg = 'none'

# Hints
c.colors.hints.bg = background
c.colors.hints.fg = foreground
c.hints.border = '1px solid ' + background
c.colors.hints.match.fg = blue
c.colors.keyhint.bg = background
c.colors.keyhint.fg = blue
c.colors.keyhint.suffix.fg = background

# Messages
c.colors.messages.error.bg = background
c.colors.messages.error.border = background
c.colors.messages.error.fg = red
c.colors.messages.info.bg = background
c.colors.messages.info.border = background
c.colors.messages.info.fg = foreground
c.colors.messages.warning.bg = background
c.colors.messages.warning.border = background
c.colors.messages.warning.fg = red

# Prompts
c.colors.prompts.bg = background
c.colors.prompts.border = '1px solid ' + background
c.colors.prompts.fg = cyan
c.colors.prompts.selected.bg = background

# Status bar
c.colors.statusbar.caret.bg = background
c.colors.statusbar.caret.fg = yellow
c.colors.statusbar.caret.selection.bg = background
c.colors.statusbar.caret.selection.fg = yellow
c.colors.statusbar.command.bg = background
c.colors.statusbar.command.fg = foreground
c.colors.statusbar.command.private.bg = background
c.colors.statusbar.command.private.fg = foreground
c.colors.statusbar.insert.bg = foreground
c.colors.statusbar.insert.fg = background
c.colors.statusbar.normal.bg = background
c.colors.statusbar.normal.fg = foreground
c.colors.statusbar.passthrough.bg = background
c.colors.statusbar.passthrough.fg = yellow
c.colors.statusbar.private.bg = blue
c.colors.statusbar.private.fg = foreground
c.colors.statusbar.progress.bg = foreground
c.colors.statusbar.url.error.fg = red
c.colors.statusbar.url.fg = foreground
c.colors.statusbar.url.hover.fg = cyan

# Tabs
c.colors.tabs.bar.bg = background
c.colors.tabs.even.bg = background
c.colors.tabs.even.fg = foreground
c.colors.tabs.indicator.error = red
c.colors.tabs.indicator.start = yellow
c.colors.tabs.indicator.stop = green
c.colors.tabs.indicator.system = 'none'
c.colors.tabs.odd.bg = background
c.colors.tabs.odd.fg = foreground
c.colors.tabs.selected.even.bg = foreground
c.colors.tabs.selected.even.fg = background
c.colors.tabs.selected.odd.bg = foreground
c.colors.tabs.selected.odd.fg = background
c.colors.tabs.pinned.even.bg = background
c.colors.tabs.pinned.even.fg = foreground
c.colors.tabs.pinned.odd.bg = background
c.colors.tabs.pinned.odd.fg = foreground
c.colors.tabs.pinned.selected.even.bg = foreground
c.colors.tabs.pinned.selected.even.fg = background
c.colors.tabs.pinned.selected.odd.bg = foreground
c.colors.tabs.pinned.selected.odd.fg = background
