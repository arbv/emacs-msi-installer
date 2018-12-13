(defun emacs-x86_64-build-p ()
  (not (null (string-match "^[xX]?86_64.+" system-configuration))))

(defun generate-version-wxi (filename)
  (when (file-exists-p filename)
    (delete-file filename))
  (with-temp-buffer
    (insert "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n")
    (insert "<Include>\n")
    (insert (format "  <?define MajorVersion=\"%d\" ?>\n" emacs-major-version))
    (insert (format "  <?define MinorVersion=\"%d\" ?>\n" emacs-minor-version))
    (insert (format "  <?define BuildVersion=\"%d\" ?>\n" emacs-build-number))
    (insert (format "  <?define Platform=\"%s\" ?>\n" (if (emacs-x86_64-build-p)
                                                          "x64"
                                                        "x86")))
    (insert (format "  <?define Win64=\"%s\" ?>\n" (if (emacs-x86_64-build-p)
                                                       "yes"
                                                     "no")))
    (insert "</Include>\n")
    (write-file filename)))

(generate-version-wxi ".\\installer\\Version.wxi")

