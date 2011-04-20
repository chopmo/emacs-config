;;; Load path
;;; =========
(setq load-path (append (list "~/.emacs.d"
                              "~/.emacs.d/lib"
                              "~/.emacs.d/color-theme-6.6.0") load-path))

;;; Load ELPA
;;; =========
(require 'package)
(package-initialize)


;;; UTF-8 encoding
;;; ==============
(setq locale-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

;;; Ruby support
;;; ============
(autoload 'ruby-mode "ruby-mode" "Major mode for ruby files" t)
(add-to-list 'auto-mode-alist '("\\.rb$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Rakefile" . ruby-mode))
(add-to-list 'auto-mode-alist '("Gemfile" . ruby-mode))
(add-to-list 'auto-mode-alist '("Capfile" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.rake$" . ruby-mode))
(add-to-list 'interpreter-mode-alist '("ruby" . ruby-mode))

(add-hook 'ruby-mode-hook
          '(lambda ()
             ;(inf-ruby-keys)
             ;; Undo ruby-mode overwrite of my prev/next 5 lines shortcuts
             (define-key ruby-mode-map "\e\C-p" nil)
             (define-key ruby-mode-map "\e\C-n" nil)))

; Themes
; (color-theme-late-night)
; (color-theme-arjen)

; (color-theme-charcoal-black)

; (color-theme-vim-colors)


(require 'rvm)
(add-to-list 'load-path "~/.emacs.d/lib/rdebug")
(require 'rdebug)

;;; Support for a few other formats
;;; ===============================
(autoload 'haml-mode "haml-mode" "" t)
(autoload 'sass-mode "sass-mode" "" t)

(autoload 'yaml-mode "yaml-mode" "" t)
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))

(require 'aes)
(aes-enable-auto-decryption)

(require 'epa-file)
(epa-file-enable)

(load "ido-init.el")

; Rinari
;; (add-to-list 'load-path "~/.emacs.d/lib/rinari")
;; (require 'rinari)



;;; Rails support
;;; =============
; Let's see if I'll need it

; (setq load-path (cons "~/.emacs.d/rails" load-path)) 
; (require 'rails)
;; Make rails-core recognize Rails 2.0 style views
;; (add-to-list 'rails-templates-list "html.erb" t)

; This was not a very nice thing to enable globally!!
;; (remove-hook 'write-file-hooks 'untabify-before-write)


(defun open-rails-project (root-dir)
  (interactive "D")
  (let ((root-dir (if (string-match "/$" root-dir) root-dir (concat root-dir "/")))
        (paths '("app/models/*.rb"
                 "app/controllers/*.rb"
                 "app/helpers/*.rb"
                 "app/mailers/*.rb"
                 "app/views/*"
                 "config/routes.rb"
                 "config/database.yml"
                 "db/schema.rb"
                 "config/locales/*.yml"
                 "spec/acceptance/*.rb" ; This may be a bit project-specific...
                 "Gemfile"
                )))
    (dolist (p paths)
      (find-file (concat root-dir p) t))))


;;; Visual aids
;;; ===========
;; Adapted from http://www.emacswiki.org/emacs/hl-line%2b.el
(defun flash-current-line (&optional arg)
  (global-hl-line-mode 1)
  (run-at-time 0.2 nil #'(lambda () (global-hl-line-mode 0))))

(defadvice move-beginning-of-line (before flash-if-at-column-zero)
  (if (= (point) (point-at-bol))
      (flash-current-line)))

(ad-activate 'move-beginning-of-line)


;;; Remove toolbar and scrollbars if running in a GUI
;;; =================================================
(if window-system
    (progn
      (tool-bar-mode 0)
      (scroll-bar-mode -1)))


;;; Load a few external files
;;; =========================
(load "light-symbol")
(load "utils.el")
(require 'ack)

;;; Key bindings
;;; ============
(add-hook 'dired-mode-hook
          '(lambda ()
             (local-unset-key "\C-\M-n")
             (local-unset-key "\C-\M-p")
             (local-unset-key "\C-o")
             (local-set-key "" 'dired-up-directory)
             (local-set-key "\C-j" 'dired-find-alternate-file)
             (local-set-key "o" 'dired-display-file)
             (local-set-key "W" 'wdired-change-to-wdired-mode)))

(add-hook 'rinari-minor-mode-hook
          '(lambda()
             (local-set-key (kbd "C-M-=") 'rinari-insert-erb-skeleton)
             (local-set-key (kbd "C-M-'") '(lambda () (interactive) (rinari-insert-erb-skeleton t)))))

(global-set-key "u" 'browse-url-at-point)
(global-set-key "g" (quote ack))
(global-set-key (kbd "M-s M-s") (lambda () (interactive) (save-some-buffers t)))
(global-set-key (kbd "M-o M-r") 'open-rails-project)

;; Leaving the rest commented out until I know if I'll miss them
;; Just playing with macros here...this could also be written:
;; (global-set-key (quote [C-tab]) (lambda nil (interactive) (other-window 1)))

;; (defmacro def-window-switcher (reverse)
;;   `(lambda () (interactive) (other-window ,(if reverse -1 1))))

;; (global-set-key (quote [C-tab]) (def-window-switcher nil))
;; (global-set-key (quote [S-C-tab]) (def-window-switcher t))

; (global-set-key (quote [backtab]) (quote hippie-expand))
; (global-set-key "" (quote uncomment-region))

(global-set-key (quote [f11]) (quote open-dot-emacs-file))
; (global-set-key (quote [S-f11]) 'open-local-config-file)
; (global-set-key [?\M-#] 'query-replace-regexp)
(global-set-key [f6] 'next-error)
(global-set-key [S-f6] 'previous-error)
; (global-set-key [?\C-c ?g] 'goto-line)
(global-set-key [?\C-c ?v] 'revert-buffer)

; (global-set-key [S-backspace] '(lambda () (interactive) (delete-backward-char 1)))
; (global-set-key (quote [backtab]) (quote lisp-complete-symbol))

(global-set-key "f" (quote fill-region))
; (global-set-key "p" (quote fill-paragraph))

(global-set-key "\C-o" 'other-window)
(global-set-key (kbd "S-C-o") '(lambda () (interactive) (other-window -1)))
(global-set-key "\C-\M-o" 'other-frame)

(global-set-key "\C-t" 'ido-goto-symbol)
(global-set-key "A" 'apropos)
(global-set-key (kbd "M-k") 'bury-buffer)
(global-set-key (kbd "M-C-k") 'kill-current-buffer)
(global-set-key (kbd "M-C-S-k") 'delete-window)

; Use meta+shift+[j/k/l/i] to navigate between windows
(global-set-key (kbd "M-L") 'windmove-right)
(global-set-key (kbd "M-J") 'windmove-left)
(global-set-key (kbd "M-I") 'windmove-up)
(global-set-key (kbd "M-K") 'windmove-down)

(global-set-key (kbd "M-C-g") 'egg-status)

;;; Faster point movement
;;; =====================
(global-set-key "\M-\C-p"
  '(lambda () (interactive) (previous-line 5)))

(global-set-key "\M-\C-n"
  '(lambda () (interactive) (next-line 5)))


;;; Pager improvements
;;; ==================
(require 'pager)
(global-set-key "\C-v" 'pager-page-down)
(global-set-key "\M-v" 'pager-page-up)
(global-set-key "\M-N" 'pager-row-down)
(global-set-key "\M-P" 'pager-row-up)

;;; Aliases
;;; =======
(defalias 'tmopen (lambda () (interactive)
  (eshell-command (concat "mate " buffer-file-name))))

(defalias 'pydebug (lambda () (interactive)
  (insert "import pdb; pdb.set_trace() # __PYDEBUG__")
  (save-buffer)))

(defalias 'rbdebug (lambda () (interactive)
  (insert "require 'ruby-debug'; debugger # __RBDEBUG__")
  (save-buffer)))

;;; Load and customize Ido
;;; ======================
(require 'ido)
(ido-mode 1)

; Use ido with imenu to quickly jump to methods in current buffer.
; See http://www.emacswiki.org/cgi-bin/wiki/ImenuMode
(require 'imenu)
(defun ido-goto-symbol ()
  "Will update the imenu index
   and then use ido to select a
   symbol to navigate to"
  (interactive)
  (imenu--make-index-alist)
  (let ((name-and-pos '())
        (symbol-names '()))
    (flet ((addsymbols (symbol-list)
                       (when (listp symbol-list)
                         (dolist (symbol symbol-list)
                           (let ((name nil) (position nil))
                             (cond
                              ((and (listp symbol) (imenu--subalist-p symbol))
                               (addsymbols symbol))

                              ((listp symbol)
                               (setq name (car symbol))
                               (setq position (cdr symbol)))

                              ((stringp symbol)
                               (setq name symbol)
                               (setq position (get-text-property 1 'org-imenu-marker symbol))))

                             (unless (or (null position) (null name))
                               (add-to-list 'symbol-names name)
                               (add-to-list 'name-and-pos (cons name position))))))))
      (addsymbols imenu--index-alist))
    (let* ((selected-symbol (ido-completing-read "Symbol? " symbol-names))
           (position (cdr (assoc selected-symbol name-and-pos))))
      (goto-char position))))

(setq
 ido-max-prospects 6
 ido-confirm-unique-completion t)

;;; Misc customizations
;;; ===================
(setq dabbrev-case-fold-search nil)
(setq debug-on-error nil)
(put 'downcase-region 'disabled nil)
(put 'dired-find-alternate-file 'disabled nil)
(put 'narrow-to-region 'disabled nil)

; Disable splash screen and startup message
(setq inhibit-startup-message t)
(setq initial-scratch-message nil)

; Improve the way buffer names are made unique
(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward)

; Enable syntax highlighting by default
(global-font-lock-mode t)
(setq font-lock-maximum-decoration t)

; Disable autosave and backup
(setq auto-save-default nil)
(setq make-backup-files nil)

; Force to use spaces for tabs and to be 3 spaces
(setq-default indent-tabs-mode nil)
(setq-default tab-width 3)

; Remove menu bar
; (menu-bar-mode 0) ; not needed on mac, it's there anyway

; Enable transient mark mode
(transient-mark-mode 1)
(column-number-mode 1)
(display-time-mode t)
(blink-cursor-mode -1)

(fset 'yes-or-no-p 'y-or-n-p)
(require 'paren) (show-paren-mode t)
(setq message-log-max 512)

(setq-default truncate-partial-width-windows nil)
(setq query-replace-highlight t)
(setq search-highlight t)
(setq kill-whole-line t)

(autoload 'linum-mode "linum" "Show line numbers" t)

; Mac keys
(setq mac-command-modifier 'meta)
(setq mac-option-modifier 'meta)

;;; Color theme
;;; ===========
(require 'color-theme)
(color-theme-initialize)
(color-theme-dark-laptop)


;;; Git integration
;;; ===============
(require 'egg)

;;; Load local customizations for this machine
;;; ==========================================
(let ((local-config-filename (concat "~/.emacs.d/local/" (system-name) ".el")))
  (if (file-exists-p local-config-filename)
    (load local-config-filename)))


;;; Load YAS
;;; ========
(add-to-list 'load-path
                  "~/.emacs.d/yasnippet")
(require 'yasnippet)
(setq yas/prompt-functions '( yas/ido-prompt
                              yas/completing-prompt))
(yas/initialize)
(yas/load-directory "~/.emacs.d/yasnippet/snippets")
(yas/load-directory "~/.emacs.d/yasnippets-rails/rails-snippets")
;; said shoulda snippets
(yas/load-directory "~/.emacs.d/yasnippets-shoulda")

;;; A few orgmode tweaks
;;; ====================
(setq org-clock-persist 'history)
(org-clock-persistence-insinuate)


(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(button ((((supports :underline t)) (:box (:line-width 2 :color "gray" :style released-button)))))
 '(escape-glyph ((((background dark)) (:foreground "gray30"))))
 '(flymake-errline ((((class color)) (:underline "red"))))
 '(flymake-warnline ((((class color)) (:underline "lightblue"))))
 '(ido-only-match ((((class color)) (:foreground "Green"))))
 '(ido-subdir ((((min-colors 88) (class color)) (:foreground "orange1"))))
 '(italic ((((supports :underline t)) (:underline "gray"))))
 '(link ((((class color) (min-colors 88) (background dark)) (:foreground "cyan1"))))
 '(mode-line-inactive ((t (:background "black" :foreground "wheat"))))
 '(mumamo-background-chunk-major ((((class color) (min-colors 88) (background dark)) nil)))
 '(mumamo-background-chunk-submode ((((class color) (min-colors 88) (background dark)) nil)))
 '(p4-depot-added-face ((t (:foreground "lightblue"))))
 '(p4-depot-deleted-face ((t (:foreground "orange"))))
 '(p4-diff-del-face ((t (:foreground "orange"))))
 '(p4-diff-file-face ((t nil)))
 '(p4-diff-head-face ((t nil)))
 '(p4-diff-ins-face ((t (:foreground "lightblue"))))
 '(rcirc-server ((((class color) (min-colors 88) (background dark)) (:foreground "gray50"))))
 '(region ((t (:background "DarkOliveGreen"))))
 '(trailing-whitespace ((((class color) (background dark)) nil))))

(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(blink-cursor-delay 0.0)
 '(blink-cursor-interval 0.2)
 '(compilation-scroll-output t)
 '(confirm-kill-emacs (quote yes-or-no-p))
 '(display-time-24hr-format t)
 '(eshell-buffer-name "*eshell*")
 '(eshell-output-filter-functions nil)
 '(eshell-send-direct-to-subprocesses t)
 '(eudc-protocol (quote ldap))
 '(eudc-server "ldap")
 '(gdb-enable-debug t)
 '(gnus-fetch-old-headers (quote some))
 '(gnus-inhibit-mime-unbuttonizing nil)
 '(gnus-summary-line-format "%U%R %d %*%5L%I %(%z%[%-23,23n%]%) %s
")
 '(gud-gdb-command-name "gdb --annotate=1")
 '(gud-tooltip-echo-area nil)
 '(gud-tooltip-mode t)
 '(icicle-reminder-prompt-flag nil)
 '(ido-default-buffer-method (quote selected-window))
 '(ido-default-file-method (quote selected-window))
 '(ido-enable-flex-matching t)
 '(ido-use-faces nil)
 '(inferior-lisp-program "sbcl")
 '(js-indent-level 2)
 '(large-file-warning-threshold nil)
 '(mumamo-background-chunk-major (quote default))
 '(mumamo-background-chunk-submode (quote default))
 '(mumamo-chunk-coloring (quote no-chunks-colored))
 '(mumamo-set-major-mode-delay -1)
 '(ns-command-modifier (quote meta))
 '(org-export-latex-classes (quote (("article" "\\documentclass[11pt]{article}
\\usepackage[utf8]{inputenc}
\\usepackage[T1]{fontenc}
\\usepackage{graphicx}
\\usepackage{longtable}
\\usepackage{float}
\\usepackage{wrapfig}
\\usepackage{soul}
\\usepackage{amssymb}
\\usepackage{hyperref}" ("\\section{%s}" . "\\section*{%s}") ("\\subsection{%s}" . "\\subsection*{%s}") ("\\subsubsection{%s}" . "\\subsubsection*{%s}") ("\\paragraph{%s}" . "\\paragraph*{%s}") ("\\subparagraph{%s}" . "\\subparagraph*{%s}")) ("report" "\\documentclass[11pt]{report}
\\usepackage[utf8]{inputenc}
\\usepackage[T1]{fontenc}
\\usepackage{graphicx}
\\usepackage{longtable}
\\usepackage{float}
\\usepackage{wrapfig}
\\usepackage{soul}
\\usepackage{amssymb}
\\usepackage{hyperref}" ("\\part{%s}" . "\\part*{%s}") ("\\chapter{%s}" . "\\chapter*{%s}") ("\\section{%s}" . "\\section*{%s}") ("\\subsection{%s}" . "\\subsection*{%s}") ("\\subsubsection{%s}" . "\\subsubsection*{%s}")) ("book" "\\documentclass[11pt]{book}
\\usepackage[utf8]{inputenc}
\\usepackage[T1]{fontenc}
\\usepackage{graphicx}
\\usepackage{longtable}
\\usepackage{float}
\\usepackage{wrapfig}
\\usepackage{soul}
\\usepackage{amssymb}
\\usepackage{hyperref}" ("\\part{%s}" . "\\part*{%s}") ("\\chapter{%s}" . "\\chapter*{%s}") ("\\section{%s}" . "\\section*{%s}") ("\\subsection{%s}" . "\\subsection*{%s}") ("\\subsubsection{%s}" . "\\subsubsection*{%s}")))))
 '(org-export-pdf-remove-logfiles t)
 '(org-startup-folded (quote showeverything))
 '(p4-user-email "")
 '(python-indent 3)
 '(rails-tags-command "/opt/local/bin/ctags -e -a --Ruby-kinds=-f -o %s -R %s")
 '(rcirc-default-nick "chopmo")
 '(rcirc-default-user-full-name "Jacob Poulsgaard Tjoernholm")
 '(rcirc-default-user-name "chopmo")
 '(rcirc-startup-channels-alist (quote (("^irc.freenode.net$" "#clojure"))))
 '(remember-data-file "~/Dropbox/org/notes.org")
 '(ruby-electric-expand-delimiters-list nil)
 '(safe-local-variable-values (quote ((folded-file . t))))
 '(speedbar-use-images t)
 '(tags-revert-without-query t)
 '(warning-suppress-types (quote ((\(undo\ discard-info\)))))
 '(weblogger-config-alist (quote (("default" ("user" . "chopmo") ("server-url" . "http://chopmo.wordpress.com/xmlrpc.php") ("weblog" . "5186267"))))))


