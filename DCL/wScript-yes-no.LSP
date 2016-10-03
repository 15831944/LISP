
(defun ws|yes-no (title message / WScript res)
  (setq WScript (vlax-get-or-create-object "WScript.Shell"))
  (setq	res (vlax-invoke-method WScript "Popup" message "0" title (+ 4 48)))
  (vlax-release-object WScript)
  (= res 6)
  );defun

;(ws|yes-no "tit" "sure&")