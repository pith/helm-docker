;;; helm-docker.el --- Helm Docker

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

;;; Description:

;; This is for now just a work in progress. The goal is to provide UI to access the Docker
;; API via Emacs with Helm.

;;; Dependency:
;;  - docker-client.el (from https://github.com/pith/docker-client)

(require 'url)
(require 'json)
(require 'helm)
(require 'docker-client)

;; Extract name from the "docker ps"
(defun dkr/search-containers ()
  "Returns container names form a list of container"
  (mapcar (lambda (container)
	    (elt (cdr (assoc 'Names container)) 0 ))
	  (dkr/docker-containers)))

;; Actions for container
(defun dkr/helm-action-for-container (actions containerID)
  "Return a list of helm actions available for this container."
  '(("Start container" . dkr/start-container)
  ("Stop container" . dkr/stop-container)))

;; Gets containers and the list of action available on them
(defun dkr/helm-containers ()
  "Returns a list of container for Helm"
  (interactive)
  (helm :sources 
	'((name . "Docker")
	  (candidates . dkr/search-containers)
	  (action-transformer . dkr/helm-action-for-container)
	  )))

;; get a container IP from docker inspect
;; (defun dkr/docker-get-ip (containerID)
;;   "Return the contrainer IP"
;;   (cdr (assoc 'IPAddress (assoc 'NetworkSettings (dkr/docker-inspect containerID)))))

;; (dkr/docker-get-ip container-name)



