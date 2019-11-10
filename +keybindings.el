;;; ~/.doom.d/+keybindings.el -*- lexical-binding: t; -*-

;; Leader configuration
(map!
 ;; evil
 :desc "Increment number" :n "C-a" #'evil-numbers/inc-at-pt
 :desc "Decrement number" :n "C-S-a" #'evil-numbers/dec-at-pt

 ;; swiper
 :desc "Find in file" :g "C-s" #'swiper

 ;; org-mode
 (:after org-mode
   (:map org-mode-map
     :localleader
     :n  "t"  #'org-todo
     :n  "d"  #'org-deadline
     :n  "s"  #'org-schedule)))
