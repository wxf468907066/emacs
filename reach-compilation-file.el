(defvar *compilation-file* "Makefile")

(defun reach-compilation-file ()
  "If your compile command containts 'make', goes up in the path until it finds a makefile.

I use it like this:
    (add-hook 'compilation-mode-hook '(lambda ()
                                        (require 'reach-compilation-file)))"
  (when (string-match "make"
                      (car compilation-arguments))
    ;; Search for the compilation file traversing up the directory tree.
    (let* ((dir (expand-file-name default-directory))
           (parent (file-name-directory (directory-file-name dir))))
      (while (and (not (file-readable-p (concat dir *compilation-file*)))
                  (not (string= parent dir)))
        (setq dir parent
              parent (file-name-directory (directory-file-name dir))))
      (if (string= dir parent)
          (error "Search file %s is missing" *compilation-file*)
        (setq default-directory dir)))))

(setq compilation-process-setup-function 'reach-compilation-file)

(provide 'reach-compilation-file)
