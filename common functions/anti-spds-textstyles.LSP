


 ;"SPDS"
(setq #spdstextstyle (vla-add (vla-get-TextStyles #actdoc) "SPDS"))
(vla-put-fontFile #spdstextstyle "SPDS.shx")
(vla-put-Height #spdstextstyle 0)
(vla-put-LastHeight #spdstextstyle 5)



 ;"GOST 2.304"
(setq #gosttextstyle (vla-add (vla-get-TextStyles #actdoc) "GOST 2.304"))
(vla-put-fontFile #gosttextstyle "CS_Gost2304.shx")
(vla-put-Height #gosttextstyle 0)
(vla-put-LastHeight #gosttextstyle 2.5)

(setq #spdstextstyle nil #gosttextstyle nil)
;(vla-put-ActiveTextStyle #actdoc #gosttextstyle)
