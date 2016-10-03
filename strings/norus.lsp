
(defun c:blktxteng ( / ss atts attobj)
  (setq str "*")
  (if (not (setq ss (ssget "_I" '((0 . "INSERT")))))
    (setq ss (ssget '((0 . "INSERT")))))
  (setq ss (mapcar 'vlax-ename->vla-object (ss->list* ss)))
  (foreach block ss
    (setq atts (getbattswcmatch block str))
    (foreach att atts
      (vla-put-TextString att (norus (kd-get-textstring att)))
      )
    )
  );defun
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun c:txteng (/ ss)
  (if (not (setq ss (ssget "_I" '((0 . "*TEXT")))))
    (setq ss (ssget '((0 . "*TEXT")))))
  (if ss (mapcar '(lambda (txt) (vla-put-TextString txt (norus (kd-get-textstring txt)))) (ss->lsto* ss)))
  );defun

(defun c:txtrus (/ ss)
  (if (not (setq ss (ssget "_I" '((0 . "*TEXT")))))
    (setq ss (ssget '((0 . "*TEXT")))))
  (if ss (mapcar '(lambda (txt) (vla-put-TextString txt (noeng (kd-get-textstring txt)))) (ss->lsto* ss)))
  );defun



(defun g:txteng (/ get)
  (if (setq get (nentsel))
    (progn
      (setq get (vlax-ename->vla-object (car get)))
      (vla-put-TextString get (norus (kd-get-textstring get)))
      )
    )
  );defun

(defun g:txtrus (/ get)
  (if (setq get (nentsel))
    (progn
      (setq get (vlax-ename->vla-object (car get)))
      (vla-put-TextString get (noeng (kd-get-textstring get)))
      )
    )
  );defun




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun norus (str / lstr lstrnew i n)
  (setq i 0 n 0 lstr (vl-string->list str) lstrnew '())
  (foreach ch lstr
    (cond
      ((= 224 ch) (setq lstrnew (append lstrnew (list 97)) n (1+ n)))		;a
      ((= 192 ch) (setq lstrnew (append lstrnew (list 65)) n (1+ n)))		;A
      ((= 194 ch) (setq lstrnew (append lstrnew (list 66)) n (1+ n)))		;B
      ((= 197 ch) (setq lstrnew (append lstrnew (list 69)) n (1+ n)))		;E
      ((= 229 ch) (setq lstrnew (append lstrnew (list 101)) n (1+ n)))		;e
      ((= 210 ch) (setq lstrnew (append lstrnew (list 84)) n (1+ n)))		;T
      ((= 205 ch) (setq lstrnew (append lstrnew (list 72)) n (1+ n)))		;H
      ((= 209 ch) (setq lstrnew (append lstrnew (list 67)) n (1+ n)))		;C
      ((= 241 ch) (setq lstrnew (append lstrnew (list 99)) n (1+ n)))		;c
      ((= 204 ch) (setq lstrnew (append lstrnew (list 77)) n (1+ n)))		;M
      ((= 202 ch) (setq lstrnew (append lstrnew (list 75)) n (1+ n)))		;K
      ((= 208 ch) (setq lstrnew (append lstrnew (list 80)) n (1+ n)))		;P
      ((= 240 ch) (setq lstrnew (append lstrnew (list 112)) n (1+ n)))		;p
      ((= 213 ch) (setq lstrnew (append lstrnew (list 88)) n (1+ n)))		;X
      ((= 245 ch) (setq lstrnew (append lstrnew (list 120)) n (1+ n)))		;x
      (T (setq lstrnew (append lstrnew (list ch))))
      )
    );foreach
  (if (> n 0)
    (princ (strcat "\n " (itoa n) " русских букв в слове " str "\n"))
    )
  (vl-list->string lstrnew)
  );defun

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun noeng (str / lstr lstrnew i n iscode)
  (setq i 0 n 0 lstr (vl-string->list str) lstrnew '() iscode nil)
  (foreach ch lstr
    (cond
      ((= 97 ch) (setq lstrnew (append lstrnew (list 224)) n (1+ n)))		;a
      ((= 65 ch) (setq lstrnew (append lstrnew (list 192)) n (1+ n)))		;A
      ((= 66 ch) (setq lstrnew (append lstrnew (list 194)) n (1+ n)))		;B
      ((= 69 ch) (setq lstrnew (append lstrnew (list 197)) n (1+ n)))		;E
      ((= 101 ch) (setq lstrnew (append lstrnew (list 229)) n (1+ n)))		;e
      ((= 84 ch) (setq lstrnew (append lstrnew (list 210)) n (1+ n)))		;T
      ((= 72 ch) (setq lstrnew (append lstrnew (list 205)) n (1+ n)))		;H
      ((= 67 ch) (setq lstrnew (append lstrnew (list 209)) n (1+ n)))		;C
      ((= 99 ch) (setq lstrnew (append lstrnew (list 241)) n (1+ n)))		;c
      ((= 77 ch) (setq lstrnew (append lstrnew (list 204)) n (1+ n)))		;M
      ((= 75 ch) (setq lstrnew (append lstrnew (list 202)) n (1+ n)))		;K
      ((= 88 ch) (setq lstrnew (append lstrnew (list 213)) n (1+ n)))		;X
      ((= 120 ch) (setq lstrnew (append lstrnew (list 245)) n (1+ n)))		;x
      ((= 112 ch) (setq lstrnew (append lstrnew (list 240)) n (1+ n)))		;p
      ((and (= 80 ch) (null iscode)) (setq lstrnew (append lstrnew (list 208)) n (1+ n)))
      ((and (= 80 ch) iscode) (setq lstrnew (append lstrnew (list 92 80)) iscode nil))
      ((= 92  ch) (setq iscode T))
      (T (setq lstrnew (append lstrnew (list ch))))
      )
    );foreach
  (if (> n 0) (princ (strcat "\nНайдено " (itoa n) " англ букв" "\n")))
  (vl-list->string lstrnew)
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;'((224 97)
;;;  (192 65)
;;;  (197 69)
;;;  (229 101)
;;;  (210 84)
;;;  (205 72)
;;;  (209 67)
;;;  (241 99)
;;;  (204 77)
;;;  (202 75)
;;;  (208 80)
;;;  (240 112)
;;; )
