
;;
;; package business
;;

(require 'package)

(dolist (repo '(("marmalade" . "http://marmalade-repo.org/packages/")
                ("melpa" . "https://melpa.org/packages/")
                ;;("melpa" . "http://melpa.milkbox.net/packages/")
                ))
  (add-to-list 'package-archives repo))
(package-initialize)

(when (not package-archive-contents)
  (package-refresh-contents))

(defvar my-packages
  '(ac-slime
    align-cljlet
    auto-complete
    clojure-mode
    clojurescript-mode
    monokai-theme
    cyberpunk-theme
    dired-details
    find-file-in-project
    magit
    markdown-mode
    cider
    which-key
    org
    find-file-in-project
    paredit
    company
    tide
    feature-mode
    web-mode
    minimap
    yaml-mode
    json-mode
    nodejs-repl
    yasnippet
    el-get
    undo-tree
    highlight-symbol
    rainbow-delimiters))

(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))

;;yasnippet snippets
(setq yas-snippet-dirs
      '("~/.emacs.d/yasnippet-snippets/"))

(require 'which-key)
(which-key-mode)

;;
;; visual settings
;;

(setq inhibit-splash-screen t
      initial-scratch-message nil
      truncate-partial-width-windows nil
      initial-major-mode 'clojure-mode
      linum-format "%d  "
      visual-bell t)

(line-number-mode 1)
(column-number-mode 1)
(global-linum-mode 1)
;;(global-rainbow-delimiters-mode 1)
(winner-mode 1)

(setq mode-line
      '((t (:background "magenta" :foreground "black" :box (:line-width -1 :style released-button))))
      show-paren-match
      '((t (:background "gold" :foreground "black")))
      show-paren-mismatch
      '((t (:background "medium violet red" :foreground "white"))))

;;
;; quirk fixes, behaviors
;;

;;; compiz fix
(add-to-list 'default-frame-alist '(alpha . 100))

(setq x-select-enable-clipboard t
      make-backup-files nil
      auto-save-default nil
      diff-switches "-u -w"
      whitespace-style '(trailing lines space-before-tab
                         face indentation space-after-tab))

(setq-default tab-width 2
              indent-tabs-mode nil
              c-basic-offset 2
              sh-basic-offset 2
              js-indent-level 2)

(fset 'yes-or-no-p 'y-or-n-p)
(delete-selection-mode t)
(show-paren-mode t)
(auto-compression-mode t)
(recentf-mode 1)
(setq diff-switches "-u -w")
;;(menu-bar-mode 0)

;;
;; custom.el
;;

(setq custom-file "~/.emacs.d/custom.el")
(when (file-exists-p custom-file)
  (load custom-file))

;;
;; creature comforts
;;

(require 'ido)
(ido-mode t)
(setq ido-save-directory-list-file "~/.emacs.d/.ido.last"
      ido-enable-flex-matching t
      ido-use-filename-at-point 'guess
      ido-show-dot-for-dired t)

(defun recentf-ido-find-file ()
  "Find a recent file using ido.
   From Phil Hagelberg's emacs-starter-kit."
  (interactive)
  (let ((file (ido-completing-read "Choose recent file: " recentf-list nil t)))
    (when file
      (find-file file))))

(global-set-key (kbd "C-x f") 'recentf-ido-find-file)
(global-set-key (kbd "M-/") 'hippie-expand)

;;; :set wrapscan emulation
(defadvice isearch-search (after isearch-no-fail activate)
  (unless isearch-success
    (ad-disable-advice 'isearch-search 'after 'isearch-no-fail)
    (ad-activate 'isearch-search)
    (isearch-repeat (if isearch-forward 'forward))
    (ad-enable-advice 'isearch-search 'after 'isearch-no-fail)
    (ad-activate 'isearch-search)))

;;; vim dt emulation
(defadvice zap-to-char (after my-zap-to-char-advice (arg char) activate)
  "Kill up to the ARG'th occurence of CHAR, and leave CHAR.
  The CHAR is replaced and the point is put before CHAR."
  (insert char)
  (forward-char -1))

;;
;; org settings
;;

(define-key global-map "\C-ca" 'org-agenda)
(setq org-hide-leading-stars t
      org-src-window-setup 'current-window
      org-todo-keywords (quote ((sequence "TODO" "ONGOING" "DONE")))
      org-todo-keyword-faces
      '(("ONGOING" . "orange")))

;;
;; linux fullscreen
;;

(defvar my-fullscreen-p t "Check if fullscreen is on or off")

(defun my-non-fullscreen ()
  (interactive)
  (progn
    (set-frame-parameter nil 'width 82)
    (set-frame-parameter nil 'fullscreen 'fullheight)))

(defun my-fullscreen ()
  (interactive)
  (set-frame-parameter nil 'fullscreen 'fullboth))

(defun toggle-fullscreen ()
  (interactive)
  (setq my-fullscreen-p (not my-fullscreen-p))
  (if my-fullscreen-p
      (my-non-fullscreen)
    (my-fullscreen)))

;;
;; window-system specific
;;

(if window-system
    (progn
      (global-set-key (kbd "M-m") 'toggle-fullscreen)
      (if (boundp 'tool-bar-mode) (tool-bar-mode -1))
      (set-fringe-style -1)
      ;;(tooltip-mode -1)
      (scroll-bar-mode -1)
      (modify-frame-parameters (selected-frame)
                               (list (cons 'cursor-type 'hollow)))
      ;;(load-theme 'monokai t)
      (load-theme 'cyberpunk t)
      )

  (set-face-background 'default "nil"))

(add-hook 'after-init-hook 
      (lambda () (load-theme 'cyberpunk t)))

;;
;; lisp jockeying
;;

(add-to-list 'auto-mode-alist '("\\.cljs.hl\\'" . clojurescript-mode))


(setq html5-elements
      '(a abbr acronym address applet area article aside audio b base basefont
        bdi bdo big blockquote body br button canvas caption center cite code
        col colgroup command data datalist dd del details dfn dir div dl
        dt em embed eventsource fieldset figcaption figure font footer form frame frameset
        h1 h2 h3 h4 h5 h6 head header hgroup hr html i
        iframe img input ins isindex kbd keygen label legend li link html-map
        mark menu html-meta meter nav noframes noscript object ol optgroup
        option output p param pre progress q rp rt ruby
        s p samp script section select small source span strike strong style sub
        summary sup table tbody td textarea tfoot th thead html-time
        title tr track tt u ul html-var video wbr))

(add-hook 'clojurescript-mode-hook
          '(lambda ()
             (dolist (el html5-elements)
               (put-clojure-indent el 'defun))))


;;typescript mode
(add-hook 'typescript-mode-hook
          (lambda ()
            (tide-setup)
            (flycheck-mode +1)
            (setq flycheck-check-syntax-automatically '(save mode-enabled))
            (eldoc-mode +1)
            ;; company is an optional dependency. You have to
            ;; install it separately via package-install
            ;;(company-mode-on)
            ))

(setq company-tooltip-align-annotations t)





;; Tide can be used along with web-mode to edit tsx files
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . web-mode))
(add-hook 'web-mode-hook
          (lambda ()
            (when (string-equal "tsx" (file-name-extension buffer-file-name))
              (tide-setup)
              (flycheck-mode +1)
              (setq flycheck-check-syntax-automatically '(save mode-enabled))
              (eldoc-mode +1)
              (company-mode-on))))



;;
;; change font size
;;

(defun increase-font-size ()
  (interactive)
  (set-face-attribute 'default nil :height
                      (ceiling (* 1.10
                                  (face-attribute 'default :height)))))

(defun decrease-font-size ()
  (interactive)
  (set-face-attribute 'default nil :height
                      (floor (* 0.9
                                (face-attribute 'default :height)))))

;;
;; key bindings
;;

(global-set-key (kbd "C-+") 'increase-font-size)
(global-set-key (kbd "C--") 'decrease-font-size)
(global-set-key (kbd "M-j") 'join-line)
(global-set-key (kbd "RET") 'newline-and-indent)

(global-set-key (kbd "S-C-<left>") 'shrink-window-horizontally)
(global-set-key (kbd "S-C-<right>") 'enlarge-window-horizontally)
(global-set-key (kbd "S-C-<down>") 'shrink-window)
(global-set-key (kbd "S-C-<up>") 'enlarge-window)

;; Behave like */# in Vim, jumping to symbols under point.
(global-set-key (kbd "C-x *") 'highlight-symbol-next)
(global-set-key (kbd "C-*") 'highlight-symbol-prev)

(put 'narrow-to-region 'disabled nil)
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'set-goal-column 'disabled nil)

;;
;; mvnrepl
;;

(defgroup mvnrepl nil
  "run mvn clojure:repl from emacs"
  :prefix "mvnrepl-"
  :group 'applications)

(defcustom mvnrepl-mvn "mvn"
  "Maven 'mvn' command."
  :type 'string
  :group 'mvnrepl)

(defun mvnrepl-project-root ()
  "Look for pom.xml file to find project root."
  (let ((cwd default-directory)
        (found nil)
        (max 10))
    (while (and (not found) (> max 0))
      (if (file-exists-p (concat cwd "pom.xml"))
          (setq found cwd)
        (setq cwd (concat cwd "../") max (- max 1))))
    (and found (expand-file-name found))))

(defun mvnrepl ()
  "From a buffer with a file in the project open, run M-x mvn-repl to get a project inferior-lisp"
  (interactive)
  (let ((project-root (mvnrepl-project-root)))
    (if project-root
        (inferior-lisp (concat mvnrepl-mvn " -f " project-root "/pom.xml clojure:repl"))
      (message (concat "Maven project not found.")))))

(provide 'mvnrepl)

;;
;; package-specific customizations
;;

;;; find-file-in-project

(setq ffip-patterns '("*")
      ffip-use-project-cache nil
      ffip-project-file '("project.clj" ".git"))

(defun ffip-toggle-use-project-cache ()
  "Toggles project file caching for find-file-in-project.el."
  (interactive)
  (setq ffip-use-project-cache (not ffip-use-project-cache))
  (message (concat "Project caching "
                   (if ffip-use-project-cache
                       "enabled."
                     "disabled."))))

(global-set-key (kbd "C-x M-f") 'find-file-in-project)
(global-set-key (kbd "C-x M-F") 'ffip-toggle-use-project-cache)

;; paredit

(defvar paredit-modes
  '(clojure
    emacs-lisp
    lisp
    lisp-interaction
    ielm
    js
    typescript
    repl))

(dolist (mode paredit-modes)
  (add-hook (intern (concat (symbol-name mode) "-mode-hook"))
            (lambda ()
              (paredit-mode +1)
              (define-key paredit-mode-map (kbd "M-)")
                'paredit-forward-slurp-sexp))))

;; rainbow-delimiter modes
(defvar rainbow-delimiter-modes
  '(clojure
    emacs-lisp
    lisp
    lisp-interaction
    ielm
    js
    repl))

(dolist (mode rainbow-delimiter-modes)
  (add-hook (intern (concat (symbol-name mode) "-mode-hook")) #'rainbow-delimiters-mode))

;;; ibuffer

(global-set-key (kbd "C-x C-b") 'ibuffer)
(setq ibuffer-expert t)
(setq ibuffer-show-empty-filter-groups nil)
(add-hook 'ibuffer-mode-hook
          '(lambda ()
             (ibuffer-auto-mode 1)
             (ibuffer-switch-to-saved-filter-groups "home")))

(defun paredit-nonlisp ()
  "Turn on paredit mode for non-lisps."
  (interactive)
  (set (make-local-variable 'paredit-space-for-delimiter-predicates)
       '((lambda (endp delimiter) nil)))
  (paredit-mode 1))

;;react-native
(add-to-list 'auto-mode-alist '("\\.jsx?$" . web-mode))
(setq web-mode-markup-indent-offset 2
      web-mode-css-indent-offset 2
      web-mode-code-indent-offset 2)
(setq js-indent-level 2)



(add-hook 'java-mode-hook #'yas-minor-mode)

;;;###autoload
(eval-after-load 'js
  '(progn (define-key js-mode-map "{" 'paredit-open-curly)
          (define-key js-mode-map "}" 'paredit-close-curly-and-newline)
          (add-hook 'js-mode-hook 'paredit-nonlisp)
          (setq js-indent-level 2)
          ;; fixes problem with pretty function font-lock
          (define-key js-mode-map (kbd ",") 'self-insert-command)
          (font-lock-add-keywords
           'js-mode `(("\\(function *\\)("
                       (0 (progn (compose-region (match-beginning 1)
                                                 (match-end 1)
                                                 ,(make-char 'greek-iso8859-7 107)
                                                 ;;"\u0192"
                                                 )
                                 nil)))))))

;;; typescript add {} to paredit and λ for pretty functions
(eval-after-load 'typescript-mode
  '(progn
     (define-key typescript-mode-map "{" 'paredit-open-curly)
     (define-key typescript-mode-map "}" 'paredit-close-curly-and-newline)
     ;;(add-hook 'typescript-mode-hook (lambda () (lll local-unset-key (kbd "{"))))     
     (add-hook 'typescript-mode-hook 'paredit-nonlisp)
     (setq typescript-indent-level 2)
     ;; fixes problem with pretty function font-lock
     (define-key typescript-mode-map (kbd ",") 'self-insert-command)
     (font-lock-add-keywords
      'typescript-mode `(("\\(function *\\)("
                          (0 (progn (compose-region (match-beginning 1)
                                                    (match-end 1)
                                                    ,(make-char 'greek-iso8859-7 107)
                                                    ;;"\u0192"
                                                    )
                                    nil)))))
     ;; (font-lock-add-keywords
     ;;  'typescript-mode `(("\\((\\)\\(.*\\)\\()\\) *=>"
     ;;                      (0 (progn (compose-region (match-beginning 1)
     ;;                                                (match-end 1)
     ;;                                                ,(make-char 'greek-iso8859-7 107)
     ;;                                                ;;"\u0192"
     ;;                                                )
     ;;                                nil))
     ;;                      )))
     ))

