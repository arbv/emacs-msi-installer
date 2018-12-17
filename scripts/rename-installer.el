(defun get-emacs-patform ()
  (car (split-string system-configuration "-")))

(defun get-installer-name ()
  (format "emacs-%d.%d-%s" emacs-major-version emacs-minor-version (get-emacs-patform)))

(defun rename-installer ()
  (let ((new-msi-name (concat (get-installer-name) ".msi"))
        (new-wixpdb-name (concat (get-installer-name) ".wixpdb"))
        (msi-name "emacs-installer.msi")
        (wixpdb-name "emacs-installer.wixpdb"))
    (when (file-exists-p msi-name)
      (rename-file msi-name new-msi-name t))
    (when (file-exists-p wixpdb-name)
      (rename-file wixpdb-name new-wixpdb-name t))))

(rename-installer)

