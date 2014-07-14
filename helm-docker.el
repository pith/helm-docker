;;; helm-docker.el --- Helm support for Docker

;; URL: https://github.com/pith/helm-docker
;; Created: 16th June 2014
;; Version: 0.1

;; Copyright (C) 2014 Pierre THIROUIN <pierre.thirouin@gmail.com>

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; This is for now just a work in progress. The goal is to provide UI to access the Docker
;; API via Emacs with Helm.

;;; Dependency:
;;  - docker-client.el (from https://github.com/pith/docker-client)

;;; Code:

(require 'url)
(require 'json)
(require 'helm)
(require 'docker-client)

;; Extract name from the "docker ps"

(defun dkr/search-containers (all)
  "Return container names form a list of container."
  (mapcar 
   (lambda (container)
     (elt (cdr (assoc 'Names container)) 0 ))
   (dkr/docker-containers all))
  )

(defun dkr/container-candidates (all)
  "Transform a list of container names into a list of candidates.

 (name1 name2) ->  ((name1 . name1) (name2 . name2))"
  (mapcar
   (lambda (container)
     (cons container container))
   (dkr/search-containers all)))


;; Actions for container
(defun dkr/helm-action-for-container (actions containerID)
  "Return a list of helm ACTIONS available for this container.
Argument CONTAINERID container name."
  '(("Start container" . dkr/start-container)
    ("Stop container" . dkr/stop-container)))

(defvar helm-source-runnung-containers-list nil)
(setq helm-source-runnung-containers-list
      `((name . "Running containers")
        (candidates . (lambda ()
                        (dkr/container-candidates "0")))
        (action-transformer . dkr/helm-action-for-container))
      )
(defvar helm-source-containers-list nil)
(setq helm-source-containers-list
      `((name . "All containers")
        (candidates . (lambda ()
                        (dkr/container-candidates "1")))
        (action-transformer . dkr/helm-action-for-container))
      )

(defun helm-docker-containers ()
  "Return the list of all the container with Helm."
  (interactive)
  (helm :sources
        '(helm-source-runnung-containers-list
          helm-source-containers-list)
        :buffer "*helm Docker containers*"
        ))

;; get a container IP from docker inspect
;; (defun dkr/docker-get-ip (containerID)
;;   "Return the contrainer IP"
;;   (cdr (assoc 'IPAddress (assoc 'NetworkSettings (dkr/docker-inspect containerID)))))

;; (dkr/docker-get-ip container-name)




(provide 'helm-docker)

;;; helm-docker.el ends here
