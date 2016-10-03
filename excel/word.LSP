

(setq #word (vlax-get-or-create-object "Word.Application"))
(do #word)



Documents

(do (vlax-get-property #word "Documents"))

(setq #w:docs (vlax-get-property #word "Documents"))

(setq #w:doc (vla-item #w:docs 1))

(do #w:doc)


(do  (vlax-get-property #w:doc "XMLSchemaViolations"))

(setq #w:words  (vlax-get-property #w:doc "Words"))

(do #w:words)


(setq lst (cont>list #w:words))



(do (nth 13 lst))


(do (vlax-get-property (nth 13 lst) "Paragraphs"))

(do
  (vlax-get-property
  (vla-item (vlax-get-property (nth 123 lst) "Paragraphs") 1)
  "Range")

  )




(do
  (vlax-get-property
    (vla-item (vlax-get-property #w:doc "Words") 1)
    "XML"
    )
  )