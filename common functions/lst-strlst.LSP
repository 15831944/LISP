; ôóíêöèÿ ïğåîáğàçóåò ñïèñîê ÷åì áû îí íè áûë â ñòğîêó
; ñîäåğæàùóş ıòîò ñïèñîê
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun lst->strlst (lst / file hand)
  (setq file (strcat (getenv "temp") "\\lst-strlst.tmp")
	hand (open file "w"))
  (prin1 lst hand)
  (close hand)
  (setq hand (open file "r"))
  (setq file (read-line hand))
  (close hand)
  file
  )
;(lst->strlst '(123 231 asd 433))