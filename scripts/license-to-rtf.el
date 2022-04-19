;; Created by Artem Boldariev <artem.boldarev@gmail.com>, 2018.
;; This file is distributed under the terms of CC0 license (Public Domain).

;; See the 'LICENSE.txt' file for the additional details.
;;
;; This file is not part of GNU Emacs.

(require 'cl-lib)
(require 'cl-extra)
(require 'subr-x) ; string-trim

(defun read-lines (filename)
  (with-temp-buffer
    (insert-file filename)
    (goto-char (point-min))
    (let ((lines))
      (while (not (eobp))
        (let* ((lbegin (point))
               (lend (progn
                       (forward-line 1)
                       (1- (point)))))
          (if (= lbegin lend)
              (push "" lines)
            (push (buffer-substring lbegin lend) lines))))
      (nreverse lines))))

(defun cleanup-string-for-rtf (str)
  (cl-labels ((replace-in-string (what with in)
                                 (replace-regexp-in-string (regexp-quote what) with in nil 'literal)))
    (let ((text (string-trim str)))
      (replace-in-string "{" "\\'7b" (replace-in-string "}" "\\'7d" (replace-in-string "\\" "\\'5c" text))))))

(defun lines-to-paragraphs (lines)
  (let ((pars))
    (dolist (l lines)
      (let ((text (cleanup-string-for-rtf l)))
        (cond
         ((and (cl-plusp (length text))
               (null pars))
          (push text pars))
         ((and (cl-plusp (length text))
               (car pars))
          (setcar pars (cl-concatenate 'string (car pars) " " text)))
         ((cl-plusp (length text))
          (setcar pars text))
         (t (when (car pars)
              (push nil pars))))))
    (nreverse (if (car pars)
                  pars
                (cdr pars)))))

(defun write-rtf (pars filename)
  (with-temp-buffer
    (insert "{\\rtf1\\ansi\n")
    (insert "\\deffn0\n")
    (insert "{\\fonttbl\\f0\\fswiss Helvetica;}\n")
    (insert "\\fs20\n")
    (dolist (p pars)
      (insert p)
      (insert "\\par\\par\n"))
    (insert "}")
    (when (file-exists-p filename)
      (delete-file filename))
    (write-file filename nil)))

(defun license-to-rtf (in out)
  (write-rtf (lines-to-paragraphs (read-lines in))
             out))

(license-to-rtf (format ".\\emacs\\share\\emacs\\%d.%d\\etc\\COPYING"
                        emacs-major-version
                        emacs-minor-version)
                ".\\installer\\LICENSE.rtf")

