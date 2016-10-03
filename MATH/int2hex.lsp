;; int2hex.lsp
;; Base-10 Integer to Hexadecimal converter.
;; Accepts positive or negative integer argument, including 0.
;; Rejects non-integer argument with Alert.
;; Kent Cooper, January 2011

(defun int2hex (int / power neg int result div remain posval)
  (if (/= (type int) 'INT)
    (progn
      (alert "Requires integer argument.")
      (quit)
    ); end progn
  ); end if
  (setq
    power 1
    neg (minusp int)
    int (abs int)
    result ""
  ); end setq
  (while (> int 0)
    (setq
      div (expt 16 power)
      remain (rem int div)
      posval (/ remain (expt 16 (1- power))); POSition VALue
      int (- int remain)
      result
        (strcat
          (if (< posval 10)
            (itoa posval)
            (chr (+ 55 posval))
          ); end if
          result
        ); end strcat & result
      power (1+ power)
    ); end setq
  ); end while
  (strcat
    (if neg "-" "")
    (if (= result "") "0" result)
  ); end strcat
); end defun - int2hex
