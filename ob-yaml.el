;;; ob-yaml.el --- org-babel functions for YAML source blocks

;; Copyright (C) 2023 Ladislav Lhotka

;; Author: Ladislav Lhotka
;; Keywords: literate programming, YAML, configuration
;; Homepage: https://github.com/llhotka/ob-yaml
;; Version: 0.01

;;; License:

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Commentary:

;; This module enables YAML source code blocks in Org Babel. It was created
;; as a trivial modification of the Emacs Lisp template
;;
;; https://git.sr.ht/~bzg/worg/tree/master/item/org-contrib/babel/ob-template.el
;;
;; After loading this file, e.g. via M-x load-file, support for YAML has to be
;; added, e.g. by evaluating
;;
;; (add-to-list 'org-babel-load-languages '(yaml . t))
;;
;; After that, code blocks like the following can be included in Org mode
;; files:
;;
;; #+begin_src yaml :tangle hello.yaml
;; greeting: "Hello, world!"
;; #+end_src

;;; Code:
(require 'ob)
(require 'ob-ref)
(require 'ob-comint)
(require 'ob-eval)

;; define a file extension for YAML
(add-to-list 'org-babel-tangle-lang-exts '("yaml" . "yaml"))

;; built-in default header arguments are fine
(defvar org-babel-default-header-args:yaml '())

;; The remaining functions are left unimplemented as we don't need
;; any evaluation of YAML blocks.

(defun org-babel-expand-body:yaml (body params &optional processed-params)
  "Expand BODY according to PARAMS, return the expanded body."
  (require 'inf-yaml nil t)
  (let ((vars (org-babel--get-vars (or processed-params (org-babel-process-params params)))))
    (concat
     (mapconcat ;; define any variables
      (lambda (pair)
        (format "%s=%S"
                (car pair) (org-babel-yaml-var-to-yaml (cdr pair))))
      vars "\n")
     "\n" body "\n")))

(defun org-babel-execute:yaml (body params)
  "Execute a block of YAML code with org-babel.
This function is called by `org-babel-execute-src-block'"
  (message "executing YAML source code block")
  (let* ((processed-params (org-babel-process-params params))
         ;; set the session if the value of the session keyword is not the
         ;; string `none'
         (session (unless (string= value "none")
                   (org-babel-yaml-initiate-session
                    (cdr (assq :session processed-params)))))
         ;; variables assigned for use in the block
         (vars (org-babel--get-vars processed-params))
         (result-params (assq :result-params processed-params))
         ;; either OUTPUT or VALUE which should behave as described above
         (result-type (assq :result-type processed-params))
         ;; expand the body with `org-babel-expand-body:yaml'
         (full-body (org-babel-expand-body:yaml
                     body params processed-params)))
    ;; actually execute the source-code block either in a session or
    ;; possibly by dropping it to a temporary file and evaluating the
    ;; file.
    ;; 
    ;; for session based evaluation the functions defined in
    ;; `org-babel-comint' will probably be helpful.
    ;;
    ;; for external evaluation the functions defined in
    ;; `org-babel-eval' will probably be helpful.
    ;;
    ;; when forming a shell command, or a fragment of code in some
    ;; other language, please preprocess any file names involved with
    ;; the function `org-babel-process-file-name'. (See the way that
    ;; function is used in the language files)
    ))

(defun org-babel-prep-session:yaml (session params)
  "Prepare SESSION according to the header arguments specified in PARAMS."
  )

(defun org-babel-yaml-var-to-yaml (var)
  "Convert an elisp var into a string of YAML source code
specifying a var of the same value."
  (format "%S" var))

(defun org-babel-yaml-table-or-string (results)
  "If the results look like a table, then convert them into an
Emacs-lisp table, otherwise return the results as a string."
  )

(defun org-babel-yaml-initiate-session (&optional session)
  "If there is not a current inferior-process-buffer in SESSION then create.
Return the initialized session."
  (unless (string= session "none")
    ))

(provide 'ob-yaml)
;;; ob-yaml.el ends here
