;;; ~/.doom.d/+keybindings.el -*- lexical-binding: t; -*-

;; Source: https://github.com/rschmukler/doom.d/blob/master/%2Bbindings.el

;; Leader configuration
(map!
 (:leader
   :desc "Horizonal Split"        :n  "s"   #'split-window-below
   :desc "Vertical Split"         :n  "v"   #'split-window-right

   :desc "Next Error"             :n  "]"   #'flycheck-next-error
   :desc "Previous Error"         :n  "["   #'flycheck-previous-error

   :desc "Find file content"      :n  "f"   #'counsel-projectile-ag
   :desc "Find project"           :n  "p"   #'projectile-switch-project

   :desc "Eval"                   :n  "e"   #'+eval/buffer
   :v    "e"                                #'+eval/region

   :desc "Save buffer"            :n  "RET" #'save-buffer

   :desc "Delete the window"      :n  "q"   #'delete-window
   :desc "Ivy open buffers"       :n  "b"   #'ivy-switch-buffer

   :desc "Toggle between file and tests"  :n "t" #'projectile-toggle-between-implementation-and-test

   (:desc "help" :prefix "h"
     :n "h" help-map
     :desc "Apropos"               :n "a" #'apropos
     :desc "Reload theme"          :n "R" #'doom/reload-theme
     :desc "Find library"          :n "l" #'find-library
     :desc "Toggle Emacs log"      :n "m" #'doom/popup-toggle-messages
     :desc "Command log"           :n "L" #'global-command-log-mode
     :desc "Describe function"     :n "f" #'describe-function
     :desc "Describe key"          :n "k" #'describe-key
     :desc "Describe char"         :n "c" #'describe-char
     :desc "Describe mode"         :n "M" #'describe-mode
     :desc "Show messages"         :n "m" #'view-echo-area-messages
     :desc "Describe variable"     :n "v" #'describe-variable
     :desc "Describe face"         :n "F" #'describe-face
     :desc "Describe DOOM setting" :n "s" #'doom/describe-setting
     :desc "Describe DOOM module"  :n "d" #'doom/describe-module
     :desc "Find definition"       :n "." #'+jump/definition
     :desc "Find references"       :n "/" #'+jump/references
     :desc "Find documentation"    :n "h" #'+jump/documentation
     :desc "What face"             :n "'" #'doom/what-face
     :desc "What minor modes"      :n ";" #'doom/what-minor-mode
     :desc "Info"                  :n "i" #'info
     :desc "Toggle profiler"       :n "p" #'doom/toggle-profiler)

   (:desc "git" :prefix "g"
     :desc "Git status"        :n  "s" #'magit-status
     :desc "Git blame"         :n  "b" #'magit-blame
     :desc "Git timemachine branch" :n  "B" #'git-timemachine-switch-branch
     :desc "Git time machine"  :n  "t" #'git-timemachine-toggle
     :desc "Git revert hunk"   :n  "r" #'git-gutter:revert-hunk
     :desc "List gists"        :n  "g" #'+gist:list
     :desc "Next hunk"         :nv "]" #'git-gutter:next-hunk
     :desc "Previous hunk"     :nv "[" #'git-gutter:previous-hunk)

   (:desc "open" :prefix "o"
     :desc "Org Agenda"          :n  "a" #'org-agenda
     :desc "Default browser"     :n  "b" #'browse-url-of-file
     :desc "Debugger"            :n  "d" #'+debug/open
     :desc "REPL"                :n  "r" #'+eval/repl
     :v  "r" #'+eval:repl
     :desc "Neotree"             :n  "n" #'+neotree/toggle
     :desc "Terminal"            :n  "t" #'+term/open-popup
     :desc "Terminal in project" :n  "T" #'+term/open-popup-in-project
     :desc "Org Capture"         :n  "o" #'org-capture
     :desc "imenu"               :n  "m" #'counsel-imenu)

   (:desc "orgmode" :prefix "O"
     :desc "Capture item"        :n  "O" #'org-capture
     :desc "Show all todos"      :n  "t" #'org-todo-list)

   (:desc "insert" :prefix "i"
     :desc "From kill-ring" :nv "p" #'counsel-yank-pop
     :desc "From snippet"   :nv "s" #'yas-insert-snippet)

   (:desc "workspace" :prefix "TAB"
     :desc "Display tab bar"          :n "TAB" #'+workspace/display
     :desc "New workspace"            :n "n"   #'+workspace/new
     :desc "Load workspace from file" :n "l"   #'+workspace/load
     :desc "Load last session"        :n "L"   (λ! (+workspace/load-session))
     :desc "Save workspace to file"   :n "s"   #'+workspace/save
     :desc "Autosave current session" :n "S"   #'+workspace/save-session
     :desc "Switch workspace"         :n "."   #'+workspace/switch-to
     :desc "Kill all buffers"         :n "x"   #'doom/kill-all-buffers
     :desc "Delete session"           :n "X"   #'+workspace/kill-session
     :desc "Delete this workspace"    :n "d"   #'+workspace/delete
     :desc "Load session"             :n "L"   #'+workspace/load-session
     :desc "Next workspace"           :n "]"   #'+workspace/switch-right
     :desc "Previous workspace"       :n "["   #'+workspace/switch-left
     :desc "Rename workspace"         :n "r"   #'+workspace:rename
     :desc "Switch to 1st workspace"  :n "0"   (λ! (+workspace/switch-to 0))
     :desc "Switch to 2nd workspace"  :n "1"   (λ! (+workspace/switch-to 1))
     :desc "Switch to 3rd workspace"  :n "2"   (λ! (+workspace/switch-to 2))
     :desc "Switch to 4th workspace"  :n "3"   (λ! (+workspace/switch-to 3))
     :desc "Switch to 5th workspace"  :n "4"   (λ! (+workspace/switch-to 4))
     :desc "Switch to 6th workspace"  :n "5"   (λ! (+workspace/switch-to 5))
     :desc "Switch to 7th workspace"  :n "6"   (λ! (+workspace/switch-to 6))
     :desc "Switch to 8th workspace"  :n "7"   (λ! (+workspace/switch-to 7))
     :desc "Switch to 9th workspace"  :n "8"   (λ! (+workspace/switch-to 8))))

 ;; swiper
 :desc "Find in file" :g "C-s" #'swiper

 ;; org-mode
 (:after org-mode
   (:map org-mode-map
     :localleader
     :n  "t"  #'org-todo
     :n  "d"  #'org-deadline
     :n  "s"  #'org-schedule)))
