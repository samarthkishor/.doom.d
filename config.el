;;; ~/.doom.d/config.el -*- lexical-binding: t; -*-

;;
;; Personal Info

(setq user-full-name "Samarth Kishor"
      user-mail-address "samarthkishor1@gmail.com")


;;
;; UI Settings

(setq doom-font (font-spec :family "Fira Code" :size 14))
(setq doom-big-font (font-spec :family "Fira Code" :size 16))
(global-visual-line-mode 1)

(defun fira-code-mode--make-alist (list)
  "Generate prettify-symbols alist from LIST."
  (let ((idx -1))
    (mapcar
     (lambda (s)
       (setq idx (1+ idx))
       (let* ((code (+ #Xe100 idx))
              (width (string-width s))
              (prefix ())
              (suffix '(?\s (Br . Br)))
              (n 1))
         (while (< n width)
           (setq prefix (append prefix '(?\s (Br . Bl))))
           (setq n (1+ n)))
         (cons s (append prefix suffix (list (decode-char 'ucs code))))))
     list)))

(defconst fira-code-mode--ligatures
  '("www" "**" "***" "**/" "*>" "*/" "\\\\" "\\\\\\"
    "{-" "[]" "::" ":::" ":=" "!!" "!=" "!==" "-}"
    "--" "---" "-->" "->" "->>" "-<" "-<<" "-~"
    "#{" "#[" "##" "###" "####" "#(" "#?" "#_" "#_("
    ".-" ".=" ".." "..<" "..." "?=" "??" ";;" "/*"
    "/**" "/=" "/==" "/>" "//" "///" "&&" "||" "||="
    "|=" "|>" "^=" "$>" "++" "+++" "+>" "=:=" "=="
    "===" "==>" "=>" "=>>" "<=" "=<<" "=/=" ">-" ">="
    ">=>" ">>" ">>-" ">>=" ">>>" "<*" "<*>" "<|" "<|>"
    "<$" "<$>" "<!--" "<-" "<--" "<->" "<+" "<+>" "<="
    "<==" "<=>" "<=<" "<>" "<<" "<<-" "<<=" "<<<" "<~"
    "<~~" "</" "</>" "~@" "~-" "~=" "~>" "~~" "~~>" "%%"
    "x" ":" "+" "+" "*"))

(defvar fira-code-mode--old-prettify-alist)

(defun fira-code-mode--enable ()
  "Enable Fira Code ligatures in current buffer."
  (setq-local fira-code-mode--old-prettify-alist prettify-symbols-alist)
  (setq-local prettify-symbols-alist (append (fira-code-mode--make-alist fira-code-mode--ligatures) fira-code-mode--old-prettify-alist))
  (prettify-symbols-mode t))

(defun fira-code-mode--disable ()
  "Disable Fira Code ligatures in current buffer."
  (setq-local prettify-symbols-alist fira-code-mode--old-prettify-alist)
  (prettify-symbols-mode -1))

(define-minor-mode fira-code-mode
  "Fira Code ligatures minor mode"
  :lighter " Fira Code"
  (setq-local prettify-symbols-unprettify-at-point 'right-edge)
  (if fira-code-mode
      (fira-code-mode--enable)
    (fira-code-mode--disable)))

(defun fira-code-mode--setup ()
  "Setup Fira Code Symbols"
  (set-fontset-font t '(#Xe100 . #Xe16f) "Fira Code Symbol"))

(provide 'fira-code-mode)

(add-hook 'prog-mode-hook #'fira-code-mode)


;;
;; MacOS

(when (eq system-type 'darwin)
  (setq mac-option-modifier 'meta
        mac-command-modifier 'control
        mac-control-modifier 'super
        mac-right-command-modifier 'super
        mac-right-option-modifier 'none)
  (add-to-list 'default-frame-alist
               '(ns-transparent-titlebar . t))
  (add-to-list 'default-frame-alist
               '(ns-appearance . dark))
  (add-hook 'window-setup-hook #'toggle-frame-maximized)

  ;; Set the theme according to system Dark Mode settings
  (if (string-equal (shell-command-to-string "defaults read -g AppleInterfaceStyle") "Dark\n")
      (setq doom-theme 'doom-nord)
    (setq doom-theme 'doom-solarized-light)))


;;
;; Packages

(after! org
  :config
  (setq org-directory "~/Dropbox/org/")
  (setq org-log-done 'time)

  (setq org-latex-pdf-process '("xelatex -shell-escape %f" "biber %b" "xelatex -shell-escape %f" "xelatex -shell-escape %f"))
  (setq bibtex-dialect 'biblatex)
  (add-to-list 'org-latex-packages-alist '("" "minted"))
  (setq org-latex-listings 'minted)

  (setq org-agenda-files (list (concat org-directory "tasks.org")
                               (concat org-directory "refile-beorg.org")
                               (concat org-directory "homework.org")))


  ;; use sly instead of slime for lisp in org-babel
  (setq org-babel-lisp-eval-fn "sly-eval"))


(after! projectile
  (add-to-list 'projectile-globally-ignored-directories "dist"))


(after! tex
  (add-to-list 'safe-local-variable-values
               '(TeX-command-extra-options . "-shell-escape")))

(after! python-mode
  :config
  (setq python-shell-interpreter "ipython"))


(use-package! prolog-mode
  :mode ("\\.pl\\'" . prolog-mode))


(use-package! prettier-js
  :config
  (defun enable-minor-mode (my-pair)
    "Enable minor mode if filename match the regexp.  MY-PAIR is a cons cell (regexp . minor-mode)."
    (if (buffer-file-name)
        (if (string-match (car my-pair) buffer-file-name)
            (funcall (cdr my-pair)))))

  ;; (add-hook 'js2-mode-hook 'prettier-js-mode)

  (add-hook 'web-mode-hook (lambda ()
                             (enable-minor-mode
                              '("\\.jsx\\'" . prettier-js-mode)))))


(use-package! company-sml
  :config
  (add-hook 'company-sml 'company-sml-setup))


(use-package! evil-surround
  :config
  (global-evil-surround-mode 1)
  (add-hook 'c++-mode-hook (lambda ()
                             (push '(?< . ("< " . " >")) evil-surround-pairs-alist)))
  (add-hook 'java-mode-hook (lambda ()
                              (push '(?< . ("< " . " >")) evil-surround-pairs-alist)))

  (defmacro define-and-bind-quoted-text-object (name key start-regex end-regex)
    (let ((inner-name (make-symbol (concat "evil-inner-" name)))
          (outer-name (make-symbol (concat "evil-a-" name))))
      `(progn
         (evil-define-text-object ,inner-name (count &optional beg end type)
           (evil-select-paren ,start-regex ,end-regex beg end type count nil))
         (evil-define-text-object ,outer-name (count &optional beg end type)
           (evil-select-paren ,start-regex ,end-regex beg end type count t))
         (define-key evil-inner-text-objects-map ,key #',inner-name)
         (define-key evil-outer-text-objects-map ,key #',outer-name))))

  (define-and-bind-quoted-text-object "pipe" "|" "|" "|")
  (define-and-bind-quoted-text-object "slash" "/" "/" "/")
  (define-and-bind-quoted-text-object "star" "*" "*" "*")
  (define-and-bind-quoted-text-object "dollar" "$" "\\$" "\\$")
  (add-hook 'org-mode-hook (define-and-bind-quoted-text-object "equals" "=" "=" "=")))


;; (use-package! writegood-mode
;;   :hook ((markdown-mode . writegood-mode)
;;          (tex-mode . writegood-mode)
;;          (text-mode . writegood-mode)
;;          (org-mode . writegood-mode)))


(after! company
  (setq company-idle-delay 1))


;; Disable hard line wrapping
(auto-fill-mode -1)


;; Center the cursor
;; Source: https://two-wrongs.com/centered-cursor-mode-in-vanilla-emacs.html
(setq scroll-preserve-screen-position t
      scroll-conservatively 0
      maximum-scroll-margin 0.5
      scroll-margin 99999)


(after! smartparens
  (sp-use-paredit-bindings)
  (setq sp-escape-quotes-after-insert t)
  (defun my-create-newline-and-enter-sexp (&rest _ignored)
    "Open a new brace or bracket expression, with relevant newlines and indent. "
    (newline)
    (indent-according-to-mode)
    (forward-line -1)
    (indent-according-to-mode))
  (setq sp-escape-quotes-after-insert nil)
  (sp-local-pair 'c++-mode "{" nil :post-handlers '((my-create-newline-and-enter-sexp "RET")))
  (sp-local-pair 'c-mode "{" nil :post-handlers '((my-create-newline-and-enter-sexp "RET")))
  (sp-local-pair 'java-mode "{" nil :post-handlers '((my-create-newline-and-enter-sexp "RET")))
  (sp-local-pair 'web-mode "{" nil :post-handlers '((my-create-newline-and-enter-sexp "RET")))
  (sp-local-pair 'typescript-mode "{" nil :post-handlers '((my-create-newline-and-enter-sexp "RET")))
  (sp-local-pair 'js-mode "{" nil :post-handlers '((my-create-newline-and-enter-sexp "RET"))))


(after! mu4e
  (setq mu4e-maildir (expand-file-name "~/Maildir"))
  (setq mu4e-get-mail-command "mbsync -a")
  (setq mu4e-change-filenames-when-moving t) ;; fix for mbsync
  ;; Enable inline images.
  (setq mu4e-view-show-images t)
  (setq mu4e-view-image-max-width 800)
  ;; Use imagemagick, if available.
  (when (fboundp 'imagemagick-register-types)
    (imagemagick-register-types))
  (setq mu4e-view-show-addresses t)
  (add-to-list 'mu4e-view-actions '("View in browser" . mu4e-action-view-in-browser) t)
  (add-hook 'mu4e-mark-execute-pre-hook
            (lambda (mark msg)
              (cond ((member mark '(refile trash)) (mu4e-action-retag-message msg "-\\Inbox"))
                    ((equal mark 'flag) (mu4e-action-retag-message msg "\\Starred"))
                    ((equal mark 'unflag) (mu4e-action-retag-message msg "-\\Starred")))))
  (defun mu4e-message-maildir-matches (msg rx)
    "Determine which account context I am in based on the maildir subfolder"
    (when rx
      (if (listp rx)
          ;; If rx is a list, try each one for a match
          (or (mu4e-message-maildir-matches msg (car rx))
              (mu4e-message-maildir-matches msg (cdr rx)))
        ;; Not a list, check rx
        (string-match rx (mu4e-message-field msg :maildir)))))

  (defun choose-msmtp-account ()
    "Choose account label to feed msmtp -a option based on From header
  in Message buffer; This function must be added to
  message-send-mail-hook for on-the-fly change of From address before
  sending message since message-send-mail-hook is processed right
  before sending message."
    (if (message-mail-p)
        (save-excursion
          (let*
              ((from (save-restriction
                       (message-narrow-to-headers)
                       (message-fetch-field "from")))
               (account
                (cond
                 ((string-match "samarthkishor1@gmail.com" from) "gmail")
                 ((string-match "sk4gz@virginia.edu" from) "uva"))))
            (setq message-sendmail-extra-arguments (list '"-a" account))))))
  (add-hook 'mu4e-compose-mode-hook 'flyspell-mode)
  (setq mu4e-contexts
        `( ,(make-mu4e-context
             :name "gmail"
             :enter-func (lambda () (mu4e-message "Switch to the gmail context"))
             :match-func (lambda (msg)
                           (when msg
                             (mu4e-message-maildir-matches msg "^/gmail")))
             :leave-func (lambda () (mu4e-clear-caches))
             :vars '((user-mail-address     . "samarthkishor1@gmail.com")
                     (user-full-name        . "Samarth Kishor")
                     (mu4e-sent-folder      . "/gmail/sent")
                     (mu4e-drafts-folder    . "/gmail/drafts")
                     (mu4e-trash-folder     . "/gmail/trash")
                     (mu4e-refile-folder    . "/gmail/[Gmail].All Mail")))
           ,(make-mu4e-context
             :name "uva"
             :enter-func (lambda () (mu4e-message "Switch to the UVA context"))
             :match-func (lambda (msg)
                           (when msg
                             (mu4e-message-maildir-matches msg "^/uva")))
             :leave-func (lambda () (mu4e-clear-caches))
             :vars '((user-mail-address     . "sk4gz@virginia.edu")
                     (user-full-name        . "Samarth Kishor")
                     (mu4e-sent-folder      . "/uva/sent")
                     (mu4e-drafts-folder    . "/uva/drafts")
                     (mu4e-trash-folder     . "/uva/trash")
                     (mu4e-refile-folder    . "/uva/[Gmail].All Mail")))))
  (setq message-send-mail-function 'message-send-mail-with-sendmail)
  (setq sendmail-program "/usr/local/bin/msmtp")
  (setq user-full-name "Samarth Kishor")

  ;; tell msmtp to choose the SMTP server according to the "from" field in the outgoing email
  (setq message-sendmail-envelope-from 'header)
  (add-hook 'message-send-mail-hook 'choose-msmtp-account))


(after! flycheck
  (flycheck-define-checker proselint
    "A linter for prose."
    :command ("proselint" source-inplace)
    :error-patterns
    ((warning line-start (file-name) ":" line ":" column ": "
              (id (one-or-more (not (any " "))))
              (message (one-or-more not-newline)
                       (zero-or-more "\n" (any " ") (one-or-more not-newline)))
              line-end))
    :modes (text-mode markdown-mode gfm-mode org-mode))
  (add-to-list 'flycheck-checkers 'proselint)

  (setq flycheck-check-syntax-automatically '(mode-enabled save)))


(after! magit-todos
  :config
  (setq magit-todos-exclude-globs t))


;; Load external files

(load! "+keybindings")
