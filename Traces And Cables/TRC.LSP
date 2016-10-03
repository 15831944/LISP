"d:\\_LISP\\Traces And Cables\\"


(setq @TRACE (regapp "PE_TRACES"))

;	TRC|

;(xdsize (car (entsel)))
;(xdroom (car (entsel)))



(defun c:TRC|setTraceNumber ( / obj hls cTraceObj)
  (setq ctraceID (kd-get-textstring (vlax-ename->vla-object (car (entsel)))))
  (setq obj (vlax-ename->vla-object (car (entsel))))
  (TRC|setLdata obj
    (list
      (list "TRACEID" ctraceID)
      )
    )
  (setq hls (vla-get-hyperlinks obj))
  (while (> (vla-get-Count hls) 0) (vla-delete (vla-item hls 0))(setq hls (vla-get-hyperlinks obj)))
  (vla-add hls @TRACE ctraceID)
  (vla-put-layer obj "pln_traces")
  (vlax-put-property obj "Color" acByLayer)
  );defun


(defun TRC|setLdata (obj data) (vlax-ldata-put obj @TRACE data))
(defun TRC|getLdata (obj) (vlax-ldata-get obj @TRACE))



(defun c:TRC|getTraceNumber ( / obj)
  (if (setq obj (entsel))
    (assoc "TRACEID" (vlax-ldata-get (vlax-ename->vla-object (car obj)) @TRACE))
    )
  );defun




(defun c:TRC|removeAll ( / ss)
  (if (setq ss (ssget))
    (mapcar
      '(lambda (o / hls)
	 (vlax-ldata-delete o @TRACE)
	 (setq hls (vla-get-hyperlinks o))
	 (while (> (vla-get-Count hls) 0) (vla-delete (vla-item hls 0))(setq hls (vla-get-hyperlinks o)))
	 )
      (ss->lsto* ss)
      )
    )
  (princ)
  )



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

"d:\\_LISP\\DataBase\\expand.LSP"
"d:\\_AutoCAD\!!!!! заготовки и настройки ACAD&SPDS\\_COM CODing\моя кодировка назначения кабелей"



































































