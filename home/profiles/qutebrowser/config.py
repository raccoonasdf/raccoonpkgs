c.tabs.padding = {
    'bottom': 2,
    'top': 2,
    'left': 5,
    'right': 5
}

ctrl_binds = {
    '<Ctrl-H>': 'back',
    '<Ctrl-Shift-H>': 'back -t',
    '<Ctrl-J>': 'tab-next',
    '<Ctrl-K>': 'tab-prev',
    '<Ctrl-L>': 'forward',
    '<Ctrl-Shift-L>': 'forward -t',

    '<Ctrl-B>': 'bookmark-add',
    '<Ctrl-Shift-B>': 'bookmark-del',
    '<Ctrl-D>': 'tab-close',
    '<Ctrl-Shift-D>': 'close',
    '<Ctrl-E>': 'edit-text',
    '<Ctrl-G>': 'tab-give',
    '<Ctrl-I>': 'devtools right',
    '<Ctrl-Shift-I>': 'devtools window',
    '<Ctrl-M>': 'tab-mute',
    '<Ctrl-N>': 'open -t',
    '<Ctrl-O>': 'open -t',
    '<Ctrl-P>': 'pin',
    '<Ctrl-R>': 'reload',
    '<Ctrl-Shift-R>': 'reload -f',
    '<Ctrl-S>': 'download',
    '<Ctrl-U>': 'undo',
    '<Ctrl-Shift-U>': 'undo -w',

    '<Ctrl-\'>': 'mode-enter passthrough'
}


c.bindings.commands['insert'] = {
    '<Shift-Escape>': 'fake-key <Escape>',
    **ctrl_binds
}


c.bindings.default['normal'] = {}

c.bindings.commands['normal'] = {
    '/': 'set-cmd-text /',
    '?': 'set-cmd-text ?',
    '.': 'search-next',
    ',': 'search-prev',

    ':': 'set-cmd-text :',

    '\'': 'mode-enter insert',

    '""': 'yank url',
    '"p': 'yank pretty-url',
    '"t': 'yank title',
    '"d': 'yank domain',
    '"s': 'yank selection',

    ';;': 'hint all',
    ';t': 'hint all tab-bg',
    ';s': 'hint all download',
    ';h': 'hint all hover',
    ';y': 'hint all yank',
    ';i': 'hint inputs',
    ';v': 'hint links spawn -d mpv {hint-url}',

    'h': 'scroll left',
    'j': 'scroll down',
    'k': 'scroll up',
    'l': 'scroll right',

    '`h': 'open -t qute://history',
    '`b': 'open -t qute://bookmarks',
    '`s': 'open -t qute://settings',
    '`v': 'open -t qute://version',

    '<Ctrl-V>': 'spawn -d mpv {url}',
    **ctrl_binds,

    '<Alt-B>': 'set-cmd-text -s :bookmark-load',
    '<Alt-O>': 'set-cmd-text -s :open',
    '<Alt-Shift-O>': 'set-cmd-text -s :open -t',
    '<Alt-G>': 'set-cmd-text -s :tab-give',
    '<Alt-Q>': 'set-cmd-text :quit --save',
    '<Escape>': 'clear-keychain ;; search ;; fullscreen --leave'
}
