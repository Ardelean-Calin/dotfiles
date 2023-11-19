{
  pkgs,
  config,
  ...
}: {
  xdg.configFile."nvim/lua/plugins/colorscheme.lua" = {
    text = ''
      return {
      	'echasnovski/mini.base16',
				version = '*',
      	opts = {
      			palette = {
      				base00 = "#${config.colorScheme.colors.base00}", -- Default Background
      					base01 = "#${config.colorScheme.colors.base01}", -- Lighter Background (Used for status bars, line number and folding marks)
      					base02 = "#${config.colorScheme.colors.base02}", -- Selection Background
      					base03 = "#${config.colorScheme.colors.base03}", -- Comments, Invisibles, Line Highlighting
      					base04 = "#${config.colorScheme.colors.base04}", -- Dark Foreground (Used for status bars)
      					base05 = "#${config.colorScheme.colors.base05}", -- Default Foreground, Caret, Delimiters, Operators
      					base06 = "#${config.colorScheme.colors.base06}", -- Light Foreground (Not often used)
      					base07 = "#${config.colorScheme.colors.base07}", -- Light Background (Not often used)
      					base08 = "#${config.colorScheme.colors.base08}", -- Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
      					base09 = "#${config.colorScheme.colors.base09}", -- Integers, Boolean, Constants, XML Attributes, Markup Link Url
      					base0A = "#${config.colorScheme.colors.base0A}", -- Classes, Markup Bold, Search Text Background
      					base0B = "#${config.colorScheme.colors.base0B}", -- Strings, Inherited Class, Markup Code, Diff Inserted
      					base0C = "#${config.colorScheme.colors.base0C}", -- Support, Regular Expressions, Escape Characters, Markup Quotes
      					base0D = "#${config.colorScheme.colors.base0D}", -- Functions, Methods, Attribute IDs, Headings
      					base0E = "#${config.colorScheme.colors.base0E}", -- Keywords, Storage, Selector, Markup Italic, Diff Changed
      					base0F = "#${config.colorScheme.colors.base0F}", -- Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?>
      				}
      		}
      }'';
  };
}
