;;; функция проверки, входит ли значение в диапазон start end
(defun diap (val start end)
  (and
    (> end start)
    (<= val end)
    (>= val start)
    )
  )