;;; $DOOMDIR/init.el -*- lexical-binding: t; -*-

;; This file controls what Doom modules are enabled and what order they load
;; in. Remember to run 'doom sync' after modifying it!

;; NOTE: Press 'SPC h d h' (or 'C-h d h' for non-vim users) to access Doom's
;;   documentation. There you'll find a link to Doom's Module Index where all of
;;   our modules are listed, including what flags they support.

;; NOTE: Move your cursor over a module's name (or its flags) and press 'K' (or
;;   'C-c c k' for non-vim users) to view its documentation. This works on flags
;;   as well (those symbols that start with a plus).
;;
;;   Alternatively, press 'gd' (or 'C-c c d') on a module to browse its
;;   directory (for easy access to its source code).

(doom! :input
       :completion
       company            ; the ultimate code completion backend
       (corfu +orderless) ; complete with cap(f), cape and a flying feather!
       vertico            ; the search engine of the future

       :ui
       doom              ; what makes DOOM look the way it does
       indent-guides     ; highlighted indent columns
       (modeline +light) ; snazzy, Atom-inspired modeline, plus API
       ophints           ; highlight the region an operation acts on
       (popup +defaults) ; tame sudden yet inevitable temporary windows
       smooth-scroll     ; So smooth you won't believe it's not butter
       treemacs          ; a project drawer, like neotree but cooler
       (vc-gutter +pretty) ; vcs diff in the fringe
       vi-tilde-fringe   ; fringe tildes to mark beyond EOB
       workspaces        ; tab emulation, persistence & separate workspaces

       :editor
       (evil +everywhere); come to the dark side, we have cookies
       file-templates    ; auto-snippets for empty files
       fold              ; (nigh) universal code folding
       multiple-cursors  ; editing in many places at once
       snippets          ; my elves. They type so I don't have to
       (whitespace +guess +trim)  ; a butler for your whitespace
       ;;word-wrap         ; soft wrapping with language-aware indent

       :emacs
       dired             ; making dired pretty [functional]
       electric          ; smarter, keyword-based electric-indent
       eww               ; the internet is gross
       ibuffer           ; interactive buffer management
       tramp             ; remote files at your arthritic fingertips
       undo              ; persistent, smarter undo for your inevitable mistakes
       vc                ; version-control and Emacs, sitting in a tree

       :term
       ghostel           ; the best terminal emulation in Emacs

       :checkers
       syntax              ; tasing you for every semicolon you forget

       :tools
       direnv
       editorconfig      ; let someone else argue about tabs vs spaces
       (eval +overlay)     ; run code, run (also, repls)
       lookup              ; navigate your code and its documentation
       lsp      ; M-x vscode
       magit             ; a git porcelain for Emacs
       make              ; run make tasks from Emacs
       pdf               ; pdf enhancements
       tree-sitter       ; syntax and parsing, sitting in a tree...

       :os
       (:if (featurep :system 'macos) macos)  ; improve compatibility with macOS

       :lang
       emacs-lisp        ; drown in parentheses
       (go +lsp)         ; the hipster dialect
       json              ; At least it ain't XML
       javascript        ; all(hope(abandon(ye(who(enter(here))))))
       lua               ; one-based indices? one-based indices
       markdown          ; writing docs for people to ignore
       nix               ; I hereby declare "nix geht mehr!"
       org               ; organize your plain life in plain text
       python            ; beautiful is better than ugly
       (rust +lsp)       ; Fe2O3.unwrap().unwrap().unwrap().unwrap()
       sh                ; she sells {ba,z,fi}sh shells on the C xor
       yaml              ; JSON, but readable

       :email
       ;;(mu4e +org +gmail)
       ;;notmuch
       ;;(wanderlust +gmail)

       :app
       calendar
       (rss +org)        ; emacs as an RSS reader

       :config
       (default +bindings +smartparens))
