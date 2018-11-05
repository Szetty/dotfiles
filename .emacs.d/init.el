;;; init.el --- Spacemacs Initialization File
;;
;; Copyright (c) 2012-2017 Sylvain Benner & Contributors
;;
;; Author: Sylvain Benner <sylvain.benner@gmail.com>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;; Without this comment emacs25 adds (package-initialize) here
;; (package-initialize)

;; Increase gc-cons-threshold, depending on your system you may set it back to a
;; lower value in your dotfile (function `dotspacemacs/user-config')
(setq gc-cons-threshold 100000000)

(defconst spacemacs-version         "0.200.13" "Spacemacs version.")
(defconst spacemacs-emacs-min-version   "24.4" "Minimal version of Emacs.")

(if (not (version<= spacemacs-emacs-min-version emacs-version))
    (error (concat "Your version of Emacs (%s) is too old. "
                   "Spacemacs requires Emacs version %s or above.")
           emacs-version spacemacs-emacs-min-version)
  (load-file (concat (file-name-directory load-file-name)
                     "core/core-load-paths.el"))
  (require 'core-spacemacs)
  (spacemacs/init)
  (configuration-layer/sync)
  (spacemacs-buffer/display-startup-note)
  (spacemacs/setup-startup-hook)
  (require 'server)
  (unless (server-running-p) (server-start)))

;;Desktop save
(desktop-save-mode 1)

;;meta, control, super, hyper key bindings
(setq mac-control-modifier 'control)
(setq mac-command-modifier 'super)
(setq mac-option-modifier 'meta)

;;mac key bindings
(global-set-key (kbd "s-s") 'save-buffer)
(global-set-key (kbd "s-c") 'clipboard-kill-ring-save)
(global-set-key (kbd "s-x") 'clipboard-kill-region)
(global-set-key (kbd "s-v") 'clipboard-yank)

;; company mode
(require 'company)
(global-company-mode)

(define-key company-active-map (kbd "C-n") 'company-select-next)
(define-key company-active-map (kbd "C-p") 'company-select-previous)

;; comment selection
(global-set-key (kbd "s-/") 'comment-or-uncomment-region)

;;alchemist
(require 'alchemist)
(add-to-list 'elixir-mode-hook 'alchemist-mode-hook)

;; select underscore in word
(modify-syntax-entry ?_ "w" elixir-mode-syntax-table)
(modify-syntax-entry ?@ "w" elixir-mode-syntax-table)

;; delete on selection
(delete-selection-mode 1)

;;Flycheck setups
(eval-after-load 'flycheck '(flycheck-dialyxir-setup))

;;For neotree bugs
(setq helm-split-window-inside-p t)
(with-eval-after-load "helm"
  (defun helm-persistent-action-display-window (&optional split-onewindow)
    "Return the window that will be used for persistent action.
If SPLIT-ONEWINDOW is non-`nil' window is split in persistent action."
    (with-helm-window
      (setq helm-persistent-action-display-window (get-mru-window)))))

;;For moving windows
(global-set-key (kbd "<M-s-left>")  'windmove-left)
(global-set-key (kbd "<M-s-right>") 'windmove-right)
(global-set-key (kbd "<M-s-up>")    'windmove-up)
(global-set-key (kbd "<M-s-down>")  'windmove-down)

;;Multiple cursors
(global-set-key (kbd "C->") 'mc/mark-next-like-this)

;; Moving lines
(defun move-line-up ()
  "Move up the current line."
  (interactive)
  (transpose-lines 1)
  (forward-line -2)
  (indent-according-to-mode))

(defun move-line-down ()
  "Move down the current line."
  (interactive)
  (forward-line 1)
  (transpose-lines 1)
  (forward-line -1)
  (indent-according-to-mode))

(global-set-key [(meta shift up)]  'move-line-up)
(global-set-key [(meta shift down)]  'move-line-down)

(add-to-list 'load-path "~/.emacs.d/custom/")

;; Backup each save
(require 'backup-each-save)
(add-hook 'after-save-hook 'backup-each-save)
(defun backup-each-save-filter (filename)
  (let ((ignored-filenames
         '("^/tmp" "semantic.cache$" "\\.emacs-places$"
           "\\.recentf$" ".newsrc\\(\\.eld\\)?"))
        (matched-ignored-filename nil))
    (mapc
     (lambda (x)
       (when (string-match x filename)
         (setq matched-ignored-filename t)))
     ignored-filenames)
    (not matched-ignored-filename)))
(setq backup-each-save-filter-function 'backup-each-save-filter)
;; end backup each save

;; Autosave when leaving emacs window
(defun save-all ()
  (interactive)
  (save-some-buffers t))

(add-hook 'focus-out-hook 'save-all)

;; paths for documentation lookup
(setq alchemist-goto-erlang-source-dir "~/Projects/source/erlang/")
(setq alchemist-goto-elixir-source-dir "~/Projects/source/elixir/")

;; alchemist hook for erlang
(defun custom-erlang-mode-hook ()
  (define-key erlang-mode-map (kbd "M-,") 'alchemist-goto-jump-back))

(add-hook 'erlang-mode-hook 'custom-erlang-mode-hook)

;; recompile after save
(setq alchemist-hooks-compile-on-save t)

;; cool search on control + s
(global-set-key (kbd "C-s") 'spacemacs/helm-file-smart-do-search-region-or-symbol)

;; find file in neotree
(global-set-key (kbd "s-f") 'neotree-find)
