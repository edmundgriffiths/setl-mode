# A (rudimentary) SETL mode for Emacs

There doesn’t seem to be any Emacs mode for editing programs written in the set-based language SETL; so here’s a very basic one.

## Installing SETL mode

Put `setl-mode.el` where Emacs can find it, and add the following lines to your init file:

`(autoload 'setl-mode "setl-mode.el")`

`(add-to-list 'auto-mode-alist '("\\.setl\\'" . setl-mode))`

## Using SETL mode

It should come on automatically when you open a file with a `.setl` extension. If you have GNU SETL installed, you can run SETL code (the active region/highlighted selection if there is one, the whole buffer if there isn’t) within Emacs by using `C-c e` (short for `execute-setl`). The output will appear in the echo area if it’s no more than a few lines, otherwise in a separate shell output buffer.
