
;; Inspired and copy-pasta from https://github.com/davidmiller/lintnode
;;
;; Commentary:
;; Dependancy on json-mode
;;
;; Installation:
;;
;; Put this in your load-path, then add the following to your .emacs.
;;
;;     (require 'jspath-mode)
;;     (add-hook 'json-mode-hook
;;         (lambda () (jspath-mode-hook)))
;;
;; Configuration
;;
;; Do M-x customize-group jspath-mode to customize paths, port and autostart.
;;
;; Usage:
;;
;; To start jspath-server, either
;; * run M-x jspath-mode-start
;; * run jspath-query
;;


;; Code:
(defcustom jspath-mode-node-program "node"
  "The program name to invoke node.js."
  :type 'string
  :group 'jspath-mode)

(defcustom jspath-mode-location "~/.emacs.d/modes/jspath-mode"
  "The directory jspath-mode's app.js may be found in."
  :type 'string
  :group 'jspath-mode)

(defcustom jspath-mode-port 3005
  "The port the jspath-mode server runs on."
  :type 'integer
  :group 'jspath-mode)

(defun jspath-mode-start ()
  "Start the jspath-mode server.
Uses `jspath-mode-node-program' and `jspath-mode-location'."
  (interactive)
  (message "Starting jspath-mode")
  (let ((jspath-mode-location (expand-file-name (concat jspath-mode-location "/app.js"))))
    (start-process "jspath-mode-server" "*jspath-mode*"
                   jspath-mode-node-program
                   jspath-mode-location
                   "--port" (number-to-string jspath-mode-port)
				   )))

(defun jspath-mode-stop ()
  "stop the jspath-mode server process"
  (interactive)
  (if (get-process "jspath-mode-server")
      (kill-process "jspath-mode-server")))

(defun jspath-mode-restart()
  "Restart the jspath-mode server - typically we've fiddled with the configuration"
  (interactive)
  (jspath-mode-stop)
  (sit-for 1)
  (jspath-mode-start))

(defun jspath-mode-init ()
  (let* ((jspath-url (format "http://127.0.0.1:%d/query" jspath-mode-port)))
    (list "curl " (list "--silent" "--form" (format "source=\"<%s\"" buffer-file-name)
                       "--form" (format "filename=%s" buffer-file-name)
		       "--form querypath=\"%s\""
                       jspath-url))))

(defun jspath-query (querypath)
  (interactive "sQuery: ")
  (cond ((not (get-process "jspath-mode-server"))
	(jspath-mode-start)
	(sit-for 1)))
  (let ((buffer (get-buffer-create "*jspath result*"))
	 (results (shell-command-to-string (format "%s %s" (nth 0 (jspath-mode-init)) (format (mapconcat 'identity (nth 1 (jspath-mode-init)) " ") querypath)))))
     (with-current-buffer buffer
     (setq buffer-read-only nil)
     (end-of-buffer)
     (insert results)
     (insert "\n--------------------------------------------------------------------------------\n")
     (setq buffer-read-only t)
     (display-buffer buffer))))

(provide 'jspath-mode)
