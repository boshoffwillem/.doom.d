;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Willem Boshoff"
      user-mail-address "boshoffwillem@protonmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
(setq doom-font (font-spec :family "FantasqueSansMono Nerd Font" :size 15 :weight 'regular)
      doom-variable-pitch-font (font-spec :family "Cantarell" :size 14))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-gruvbox)
;; (setq doom-theme 'doom-dark+)
;; (setq doom-theme 'doom-one)
;; (setq doom-theme 'doom-one-light)
;; (setq doom-theme 'doom-ayu-light)
;; (setq doom-theme 'doom-acario-light)
;; (setq doom-theme 'doom-old-hope)
;; (setq doom-theme 'doom-tomorrow-day)
;; (setq doom-theme 'doom-tomorrow-night)
;; (load-theme 'intellij)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; Improve garbage collection performance.
(setq gc-cons-threshold (* 100 1024 1024))

;; Improve processing of sub-processes that generates large chunk.
(setq read-process-output-max (* 1024 1024))

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(add-hook 'prog-mode-hook #'global-tree-sitter-mode)

(map! :leader
      (:prefix-map ("l" . "lsp-actions")
       :desc "Code actions" "a" #'lsp-execute-code-action
       :desc "Find definition" "d" #'lsp-find-definition
       (:prefix ("e" . "symbols")
        :desc "Project errors" "p" #'consult-lsp-diagnostics
        )
       (:prefix ("f" . "format")
        :desc "Format region" "r" #'lsp-format-region
        :desc "Format buffer" "b" #'lsp-format-buffer
        )
       :desc "Signature help" "h" #'lsp-ui-doc-show
       :desc "Find implementations" "i" #'lsp-find-implementation
       (:prefix ("p" . "peek")
        :desc "Peek definitions" "d" #'lsp-ui-peek-find-definitions
        :desc "Peek implementations" "i" #'lsp-ui-peek-find-implementations
        :desc "Peek usages" "u" #'lsp-ui-peek-find-references
        )
       :desc "Rename" "r" #'lsp-rename
       (:prefix ("s" . "symbols")
        :desc "Search symbol in project" "p" #'consult-lsp-symbols
        :desc "Search symbol in file" "f" #'consult-lsp-file-symbols
        :desc "Show file symbols" "l" #'lsp-treemacs-symbols
        )
       :desc "Find usages" "u" #'lsp-find-references
       )
      )

;; Turn off line wrapping
(setq global-visual-line-mode nil)

(after! company-mode
  :config
  (setq company-idle-delay 0
        company-show-quick-access t)
  )

(after! lsp-mode
  :config
  (setq lsp-eldoc-render-all t
        lsp-auto-execute-action nil
        lsp-signature-doc-lines 100
        lsp-diagnostic-clean-after-change t
        lsp-headerline-breadcrumb-enable t
        lsp-lens-place-position 'above-line)
  )

(after! lsp-ui
  :config
  (setq lsp-ui-sideline-show-diagnostics t
        lsp-ui-sideline-show-hover nil
        lsp-ui-sideline-show-code-actions nil
        lsp-ui-sideline-update-mode 'point
        lsp-ui-sideline-delay 0.2)
  (setq lsp-ui-doc-enable t
        lsp-ui-doc-position 'at-point)
  )

(defun wb/terraform-setup ()
  "Setup for terraform mode."
  (tree-sitter-require 'hcl)
  (tree-sitter-mode)
  (setq-local tab-width 2))

(add-hook 'terraform-mode-hook #'wb/terraform-setup)
(add-hook 'terraform-mode-hook #'lsp-deferred)

;; .xml files
(setq nxml-slash-auto-complete-flag t)
(add-hook 'nxml-mode-hook
          (lambda ()
            (setq-local tab-width 2)
            (tree-sitter-mode)
            ))

(defun wb/yaml-setup ()
  "Setup for yaml mode."
  (setq-local tab-width 2)
  (setq yaml-indent-offset 2)
  (setq-local evil-shitf-width yaml-indent-offset)
  (tree-sitter-mode)
  )

(add-hook 'yaml-mode-hook #'wb/yaml-setup)
