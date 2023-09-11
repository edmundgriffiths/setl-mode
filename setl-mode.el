;;; setl-mode.el --- support for the SETL programming language -*- lexical-binding: t; -*-

;; Copyright (C) 2023 Edmund Griffiths

;; Author: Edmund Griffiths <edmund_griffiths@hotmail.com>
;; Created: 11 September 2023
;; Version: 1.0

;; Keywords: languages
;; URL: https://github.com/edmundgriffiths/setl-mode

;; This file is not part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Installation:

;; Save this file somewhere in your load-path and add the following lines
;; to your init file:
;;    (autoload 'setl-mode "setl-mode.el")
;;    (add-to-list 'auto-mode-alist '("\\.setl\\'" . setl-mode))

;; Usage

;; Assuming you have GNU SETL installed, you can run either the active region or
;; (if there is no active region) the whole program by using the execute-setl command
;; (abbreviated C-c e).

;; Remark

;; This is very rudimentary, but there doesn't seem to be anything else doing the
;; job. If you do find another SETL mode it will probably be better than this one.

;;; Code:

(define-generic-mode setl-mode

  ;; SETL comments
  '("--" "$")

  ;; keywords/reserved words/builtins/etc
  '("abs" "accept" "acos" "and" "any" "arb" "asin" "atan" "atan2" "bit_and"
    "bit_not" "bit_or" "bit_xor" "break" "call" "callout" "ceil" "char" "chdir"
    "clear_error" "clock" "close" "close_await" "close_autoreap" "close_zombie"
    "command_line" "command_name" "cos" "cosh" "date" "denotype" "div" "domain"
    "dup" "dup2" "eof" "even" "exec" "exp" "fdate" "fexists" "filename" "fileno"
    "filepos" "filter" "fix" "fixed" "float" "floating" "floor" "flush" "fork"
    "from" "fromb" "frome" "fsize" "ftrunc" "get" "geta" "getb" "getc" "getchar"
    "getegid" "getenv" "geteuid" "getfile" "getgid" "getline" "getn" "getpgrp"
    "getpid" "getppid" "gets" "getsid" "getuid" "getwd" "glob" "gmark" "gsub"
    "hex" "hostaddr" "hostname" "ichar" "impl" "in" "incs" "inherit" "intslash"
    "ip_addresses" "ip_names" "is_atom" "is_boolean" "is_integer" "is_map"
    "is_mmap" "is_numeric" "is_om" "is_real" "is_routine" "is_set" "is_smap"
    "is_string" "is_tuple" "is_open" "join" "kill" "lambda" "last_error" "len" "less"
    "lessf" "lexists" "link" "log" "lpad" "magic" "mark" "match" "max" "min"
    "mkstemp" "mod" "nargs" "newat" "no_error" "not" "notany" "notin" "npow"
    "nprint" "nprinta" "odd" "open" "or" "peekc" "peekchar" "peer_address"
    "peer_name" "peer_port" "peer_sockaddr" "pexists" "pid" "pipe"
    "pipe_from_child" "pipe_to_child" "port" "pow" "pretty" "print" "printa"
    "pump" "put" "puta" "putb" "putc" "putchar" "putfile" "putline" "puts"
    "random" "range" "rany" "rbreak" "rlen" "rmatch" "rnotany" "rspan" "read"
    "reada" "readlink" "reads" "recv" "recvfrom" "recv_fd" "rem" "rename"
    "reverse" "rewind" "round" "routine" "rpad" "seek" "select" "send" "sendto"
    "send_fd" "setctty" "setegid" "setenv" "seteuid" "setgid" "setpgid"
    "setrandom" "setsid" "setuid" "set_intslash" "set_magic" "shutdown" "sign"
    "sin" "sinh" "sockaddr" "socketpair" "span" "split" "sort" "status"
    "str" "strad" "sub" "subset" "symlink" "system" "sys_read" "sys_write" "tan"
    "tanh" "tcgetpgrp" "tcsetpgrp" "tie" "time" "to_lower" "to_upper" "tod"
    "tty_pump" "type" "umask" "ungetc" "ungetchar" "unhex" "unlink" "unpretty"
    "unsetctty" "unsetenv" "unstr" "untie" "val" "wait" "waitpid" "whole" "with"
    "write" "writea" "forall" "for" "program" "end" "proc" "op" "loop" "sqrt" "if"
    "then" "else" "quit" "null" "elseif" "case" "when" "otherwise" "while" "false"
    "true" "om" "stdin" "stdout" "stderr" "seek_set" "seek_cur" "seek_end" "shut_rd"
    "shut_wr" "shut_rdwr" "continue" "exit" "until" "stop" "assert" "of" "return"
    "var" "const" "notexists" "title" "procedure" "class" "package" "body" "use")
  
  '(("\\`#!.*$" . 'font-lock-comment-face)
    ;; a line beginning #! is a comment only if it's the very first line

    ;; operators etc and brackets -- the latest Emacs has dedicated faces for these,
    ;; but they aren't universally available, so instead we use a couple of faces
    ;; we're not using for anything else
    ("[:=><;,#|\\?\\./\\+\\*-]" . 'font-lock-doc-face)
    ("[]\\[(){}]" . 'font-lock-builtin-face))

  nil

  '((lambda ()

      ;; treat 'strings' the same as "strings"
      (modify-syntax-entry ?' "\"")

      ;; hopefully-reasonable indentation/tab behaviour -- modify this bit if you
      ;; have other preferences
      (set (make-local-variable 'tab-width) 3)
      (set (make-local-variable 'indent-line-function) 'indent-relative)
      (set (make-local-variable 'indent-tabs-mode) t)
      (set (make-local-variable 'backward-delete-char-untabify-method) nil)
      (local-set-key (kbd "TAB") 'tab-to-tab-stop)

      ;; key binding for execute-setl
      (local-set-key (kbd "C-c e") 'execute-setl)))
  
  "A mode for editing SETL programs.")

(defun execute-setl ()
  "Passes the active region, or if no active region exists then the entire buffer, to the SETL interpreter."
  (interactive)
  (if (use-region-p)
      (shell-command-on-region (region-beginning) (region-end) "setl")
      (shell-command-on-region (point-min) (point-max) "setl")))

(provide 'setl-mode)

;;; setl-mode.el ends here
