c.auto_save.session = True
config.set('content.headers.user_agent', 'Mozilla/5.0 ({os_info}) AppleWebKit/{webkit_version} (KHTML, like Gecko) {upstream_browser_key}/{upstream_browser_version} Safari/{webkit_version}', 'https://web.whatsapp.com/')
config.set('content.headers.user_agent', 'Mozilla/5.0 ({os_info}; rv:71.0) Gecko/20100101 Firefox/71.0', 'https://accounts.google.com/*')
config.set('content.headers.user_agent', 'Mozilla/5.0 ({os_info}) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99 Safari/537.36', 'https://*.slack.com/*')
config.set('content.headers.user_agent', 'Mozilla/5.0 ({os_info}; rv:71.0) Gecko/20100101 Firefox/71.0', 'https://docs.google.com/*')
config.set('content.images', True, 'chrome-devtools://*')
config.set('content.images', True, 'devtools://*')
config.set('content.javascript.enabled', True, 'chrome-devtools://*')
config.set('content.javascript.enabled', True, 'devtools://*')
config.set('content.javascript.enabled', True, 'chrome://*/*')
config.set('content.javascript.enabled', True, 'qute://*/*')
config.set('content.notifications', True, 'https://www.reddit.com')
config.set('content.notifications', True, 'https://www.facebook.com')
config.set('content.notifications', True, 'https://www.youtube.com')
c.hints.chars = 'sadfjklewcmpgh'
c.hints.uppercase = True
c.statusbar.widgets = ['keypress', 'history', 'tabs', 'progress']
c.tabs.background = True
c.url.default_page = 'https://www.google.com/'
c.url.searchengines = {'DEFAULT': 'https://www.google.com/search?q={}'}
c.url.start_pages = 'https://www.google.com/'
config.bind('M', 'hint links spawn umpv {hint-url}')
