# Meta.vim

Meta.vim brings select keybindings from readline, Emacs, and VS Code to Vim. Most of them involve the `Meta` key, which is <kbd>Alt</kbd> in my terminal emulator.

## Mappings

Most mappings work in normal, insert, visual, and cmdline mode.

`<C-A>` and `<C-E>` go to the beginning/end of the line. For original `<C-A>` behavior: `<M-x>` (added) and `<C-X>` (built-in) increase/decrease a number. For original `<C-E>` behavior: `<C-Y>` (built-in) and `<C-H>` (added) scroll up and down.

`<C-K>` kills the rest of the line in insert/cmdline mode. (`<C-U>` is built-in and kills the beginning of the line.)

`<C-S-K>` deletes the current line.

**NOTE:** On macOS, the mapping to delete the current line should be `<D-S-K>` (i.e. Cmd+Shift+K) but neovim does not seem to support this even with its `CSI u` support. Therefore, macOS users should map Cmd+Shift+K to emit Ctrl+Shift+K in their terminals.

`<C-T>` transposes the previous two characters in insert/cmdline mode. For original `<C-T>` behavior: `<C-F>` (added) and `<C-D>` (built-in) indent/dedent the current line in insert mode.

`<M-t>` and `<M-T>` transpose the previous two words/WORDS.

`<M-b>`/`<M-Left>` and `<M-f>`/`<M-Right>` navigate by words. `<M-BS>` and `<M-Del>` delete them.

`<M-S-Left>` and `<M-S-Right>` navigate by WORDS. `<M-B>` and `<M-S-Del>` delete them.

**NOTE:** The mapping for deleting WORDS backwards should be `<M-S-BS>`, but Vim cannot detect this. Instead, you can map <kbd>Shift</kbd><kbd>Alt</kbd><kbd>Backspace</kbd> to `\x1bB` in your terminal emulator, as I have done in [my kitty config][kitty].

`<M-Up>` and `<M-Down>` move the current line/selection up/down.

`<M-S-Up>` and `<M-S-Down>` copy the current line/selection up/down.

## Dependencies

Requires [vim-unimpaired](https://github.com/tpope/vim-unimpaired) for `<M-Up>` and `<M-Down>`.

## License

© 2020 Mitchell Kember

Meta.vim is available under the MIT License; see [LICENSE](LICENSE.md) for details.

[kitty]: https://github.com/mk12/dotfiles/blob/3cb3b30078c471f299164889f5ea4727164f1c2e/.config/kitty/kitty.conf#L113
