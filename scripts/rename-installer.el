;; Created by Artem Boldariev <artem.boldarev@gmail.com>, 2018.
;; This file is distributed under the terms of CC0 license (Public Domain).

;; See the 'LICENSE.txt' file for the additional details.
;;
;; This file is not part of GNU Emacs.

(defun get-emacs-patform ()
  (car (split-string system-configuration "-")))

(defun get-installer-name ()
  (format "emacs-%d.%d-%s" emacs-major-version emacs-minor-version (get-emacs-patform)))

(defun rename-installer (&optional per-user)
  (let ((new-msi-name (concat (get-installer-name)
			      (if per-user
				  "-per-user"
				"")
			      ".msi"))
        (new-wixpdb-name (concat (get-installer-name)
				 (if per-user
				     "-per-user"
				   "")
				 ".wixpdb"))
        (msi-name "emacs-installer.msi")
        (wixpdb-name "emacs-installer.wixpdb"))
    (when (file-exists-p msi-name)
      (rename-file msi-name new-msi-name t))
    (when (file-exists-p wixpdb-name)
      (rename-file wixpdb-name new-wixpdb-name t))))

;;(rename-installer)

