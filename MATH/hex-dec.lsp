; (load (strcat #lisppath "MATH\\" "hex-dec.lsp"))
;(hex>dec "80")
(defun hex-dec (str / lst i n)
  ;(setq str "BUS")
  ;(setq str "20(")
  (defun h>d (asciin) (cond ((diap asciin 65 70)(- asciin 55)) ((diap asciin 48 57)(- asciin 48))(T asciin)))
  (setq lst (reverse (mapcar 'h>d (VL-STRING->LIST (strcase str)))))
  (setq i -1 n 0)
  (mapcar '(lambda (x) (setq n (+ n (* x (expt 16 (setq i (1+ i)))))))lst)
  n
  );defun


; не русским буквам - не плюсуем
;'("90""91""92""93""94""95""96""97""98""99""9A""9B""9C""9D""9E""9F""A0""A1""A2""A3""A4""A5""A6""A7""A8""A9""AA""AB""AC""AD""AE""AF")
;'(144 145 146 147 148 149 150 151 152 153 154 155 156 157 158 159 160 161 162 163 164 165 166 167 168 169 170 171 172 173 174 175)
;'(192 193 194 195 196 197 198 199 200 201 202 203 204 205 206 207 208 209 210 211 212 213 214 215 216 217 218 219 220 221 222 223) +48
;'("А" "Б" "В" "Г" "Д" "Е" "Ж" "З" "И" "Й" "К" "Л" "М" "Н" "О" "П" "Р" "С" "Т" "У" "Ф" "Х" "Ц" "Ч" "Ш" "Щ" "Ъ" "Ы" "Ь" "Э" "Ю" "Я")
;'(192 193 194 195 196 197 198 199 200 201 202 203 204 205 206 207 208 209 210 211 212 213 214 215 216 217 218 219 220 221 222 223)

;'("B0""B1""B2""B3""B4""B5""B6""B7""B8""B9""BA""BB""BC""BD""BE""BF"|	 "80""81""82""83""84""85""86""87""88""89""8A""8B""8C""8D""8E""8F")
;'(176 177 178 179 180 181 182 183 184 185 186 187 188 189 190 191 | 	128 129 130 131 132 133 134 135 136 137 138 139 140 141 142 143)
;'(224 225 226 227 228 229 230 231 232 233 234 235 236 237 238 239 |+48 	176 177 178 179 180 181 182 183 184 185 186 187 188 189 190 191) +112
;'("а" "б" "в" "г" "д" "е" "ж" "з" "и" "й" "к" "л" "м" "н" "о" "п" | 	"р" "с" "т" "у" "ф" "х" "ц" "ч" "ш" "щ" "ъ" "ы" "ь" "э" "ю" "я")
;'(224 225 226 227 228 229 230 231 232 233 234 235 236 237 238 239 | 	240 241 242 243 244 245 246 247 248 249 250 251 252 253 254 255)




;;;(defun hex2dec (s / r l n)
;;;  (setq	r 0 l (vl-string->list (strcase s)))
;;;  (while
;;;    (setq n (car l))
;;;    (setq l (cdr l)
;;;	  r (+
;;;	      (* r 16)
;;;	      (- n
;;;		 (if
;;;		   (<= n 57)
;;;		   48
;;;		   55))
;;;	      )
;;;	  )
;;;    )
;;;  )
;;;
;;;(setq str (vl-princ-to-string ename))
;;;"<Entity name: 7e9d7098>"
;;;(setq str (substr (vl-string-right-trim ">" str) (+ 3 (vl-string-search ":" str))))
;;;"7e9d7098"








(defun dec>hex (int / power neg int result div remain posval)
  (setq
    power 1
    neg (minusp int)
    int (abs int)
    result ""
  )
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
          )
          result
        )
      power (1+ power)
    )
  )
  (strcat
    (if neg "-" "")
    (if (= result "") "0" result)
  )
);defun



(defun hex>dec (hndl / result neg power tmp)
  (if (/= (type hndl) 'STR)
    (progn
      (alert "Requires string argument.")
      (quit)
    ); end progn
  ); end if
  (setq
    hndl (strcase hndl)
    result 0
  ); end setq
  (if (= (substr hndl 1 1) "-")
    (setq neg T hndl (substr hndl 2))
  ); end if
  (if (/= (vl-string-trim "0123456789ABCDEF" hndl) "")
    (progn
      (alert "Invalid hexadecimal string.")
      (quit)
    ); end progn
  ); end if
  (repeat (setq power (strlen hndl))
    (setq result
      (+
        result
        (*
          (-
            (setq tmp (ascii (substr hndl 1 1)))
            (if (> tmp 64) 55 48)
          ); end -
          (expt 16 (setq power (1- power)))
        ); end *
      ); end +
      hndl (substr hndl 2)
    ); end setq
  ); end while
  (if neg (- result) result)
); end defun - hex2int