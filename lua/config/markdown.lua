-- config/markdown.lua

require('render-markdown').setup {
  heading = {
    -- Turn on / off heading icon & background rendering
    enabled = true,
    -- Replaces '#+' of 'atx_h._marker'
    -- The number of '#' in the heading determines the 'level'
    -- The 'level' is used to index into the array using a cycle
    -- The result is left padded with spaces to hide any additional '#'
    icons = { '󰲡 ', '󰲣 ', '󰲥 ', '󰲧 ', '󰲩 ', '󰲫 ' },
    -- Added to the sign column
    -- The 'level' is used to index into the array using a cycle
    signs = { '󰫎 ' },
    -- The 'level' is used to index into the array using a clamp
    -- Highlight for the heading icon and extends through the entire line
    backgrounds = { 'DiffAdd', 'DiffChange', 'DiffDelete' },
    -- The 'level' is used to index into the array using a clamp
    -- Highlight for the heading and sign icons
    foregrounds = {
      '@markup.heading.1.markdown',
      '@markup.heading.2.markdown',
      '@markup.heading.3.markdown',
      '@markup.heading.4.markdown',
      '@markup.heading.5.markdown',
      '@markup.heading.6.markdown',
    },
  },
  code = {
    -- Turn on / off code block & inline code rendering
    enabled = true,
    -- Determines how code blocks & inline code are rendered:
    --  none: disables all rendering
    --  normal: adds highlight group to code blocks & inline code
    --  language: adds language icon to sign column and icon + name above code blocks
    --  full: normal + language
    style = 'full',
    -- Highlight for code blocks & inline code
    highlight = 'ColorColumn',
  },
  dash = {
    -- Turn on / off thematic break rendering
    enabled = true,
    -- Replaces '---'|'***'|'___'|'* * *' of 'thematic_break'
    -- The icon gets repeated across the window's width
    icon = '─',
    -- Highlight for the whole line generated from the icon
    highlight = 'LineNr',
  },
  bullet = {
    -- Turn on / off list bullet rendering
    enabled = true,
    -- Replaces '-'|'+'|'*' of 'list_item'
    -- How deeply nested the list is determines the 'level'
    -- The 'level' is used to index into the array using a cycle
    -- If the item is a 'checkbox' a conceal is used to hide the bullet instead
    icons = { '●', '○', '◆', '◇' },
    -- Highlight for the bullet icon
    highlight = 'Normal',
  },
  -- Checkboxes are a special instance of a 'list_item' that start with a 'shortcut_link'
  -- There are two special states for unchecked & checked defined in the markdown grammar
  checkbox = {
    -- Turn on / off checkbox state rendering
    enabled = true,
    unchecked = {
      -- Replaces '[ ]' of 'task_list_marker_unchecked'
      icon = '󰄱 ',
      -- Highlight for the unchecked icon
      highlight = '@markup.list.unchecked',
    },
    checked = {
      -- Replaces '[x]' of 'task_list_marker_checked'
      icon = '󰱒 ',
      -- Highligh for the checked icon
      highlight = '@markup.heading',
    },
    -- Define custom checkbox states, more involved as they are not part of the markdown grammar
    -- As a result this requires neovim >= 0.10.0 since it relies on 'inline' extmarks
    -- Can specify as many additional states as you like following the 'todo' pattern below
    --   The key in this case 'todo' is for healthcheck and to allow users to change its values
    --   'raw': Matched against the raw text of a 'shortcut_link'
    --   'rendered': Replaces the 'raw' value when rendering
    --   'highlight': Highlight for the 'rendered' icon
    custom = {
      todo = { raw = '[-]', rendered = '󰥔 ', highlight = '@markup.raw' },
    },
  },
  quote = {
    -- Turn on / off block quote & callout rendering
    enabled = true,
    -- Replaces '>' of 'block_quote'
    icon = '▋',
    -- Highlight for the quote icon
    highlight = '@markup.quote',
  },
  pipe_table = {
    -- Turn on / off pipe table rendering
    enabled = true,
    -- Determines how the table as a whole is rendered:
    --  none: disables all rendering
    --  normal: applies the 'cell' style rendering to each row of the table
    --  full: normal + a top & bottom line that fill out the table when lengths match
    style = 'full',
    -- Determines how individual cells of a table are rendered:
    --  overlay: writes completely over the table, removing conceal behavior and highlights
    --  raw: replaces only the '|' characters in each row, leaving the cells unmodified
    --  padded: raw + cells are padded with inline extmarks to make up for any concealed text
    cell = 'padded',
        -- Characters used to replace table border
        -- Correspond to top(3), delimiter(3), bottom(3), vertical, & horizontal
        -- stylua: ignore
        border = {
            '┌', '┬', '┐',
            '├', '┼', '┤',
            '└', '┴', '┘',
            '│', '─',
        },
    -- Highlight for table heading, delimiter, and the line above
    head = '@markup.heading',
    -- Highlight for everything else, main table rows and the line below
    row = 'Normal',
    -- Highlight for inline padding used to add back concealed space
    filler = 'Conceal',
  },
  -- Callouts are a special instance of a 'block_quote' that start with a 'shortcut_link'
  -- Can specify as many additional values as you like following the pattern from any below, such as 'note'
  --   The key in this case 'note' is for healthcheck and to allow users to change its values
  --   'raw': Matched against the raw text of a 'shortcut_link'
  --   'rendered': Replaces the 'raw' value when rendering
  --   'highlight': Highlight for the 'rendered' text and quote markers
  callout = {
    note = { raw = '[!NOTE]', rendered = '󰋽 Note', highlight = 'DiagnosticInfo' },
    tip = { raw = '[!TIP]', rendered = '󰌶 Tip', highlight = 'DiagnosticOk' },
    important = { raw = '[!IMPORTANT]', rendered = '󰅾 Important', highlight = 'DiagnosticHint' },
    warning = { raw = '[!WARNING]', rendered = '󰀪 Warning', highlight = 'DiagnosticWarn' },
    caution = { raw = '[!CAUTION]', rendered = '󰳦 Caution', highlight = 'DiagnosticError' },
    -- Obsidian: https://help.a.md/Editing+and+formatting/Callouts
    abstract = { raw = '[!ABSTRACT]', rendered = '󰨸 Abstract', highlight = 'DiagnosticInfo' },
    todo = { raw = '[!TODO]', rendered = '󰗡 Todo', highlight = 'DiagnosticInfo' },
    success = { raw = '[!SUCCESS]', rendered = '󰄬 Success', highlight = 'DiagnosticOk' },
    question = { raw = '[!QUESTION]', rendered = '󰘥 Question', highlight = 'DiagnosticWarn' },
    failure = { raw = '[!FAILURE]', rendered = '󰅖 Failure', highlight = 'DiagnosticError' },
    danger = { raw = '[!DANGER]', rendered = '󱐌 Danger', highlight = 'DiagnosticError' },
    bug = { raw = '[!BUG]', rendered = '󰨰 Bug', highlight = 'DiagnosticError' },
    example = { raw = '[!EXAMPLE]', rendered = '󰉹 Example', highlight = 'DiagnosticHint' },
    quote = { raw = '[!QUOTE]', rendered = '󱆨 Quote', highlight = '@markup.quote' },
  },
  link = {
    -- Turn on / off inline link icon rendering
    enabled = true,
    -- Inlined with 'image' elements
    image = '󰥶 ',
    -- Inlined with 'inline_link' elements
    hyperlink = '󰌹 ',
    -- Applies to the inlined icon
    highlight = '@markup.link.label.markdown_inline',
  },
}
