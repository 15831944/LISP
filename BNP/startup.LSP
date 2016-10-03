

 ;"SPDS"
(setq #spdstextstyle (vla-add (vla-get-TextStyles #actdoc) "SPDS"))
(vla-put-fontFile #spdstextstyle "SPDS.shx")
(vla-put-Height #spdstextstyle 0)
(vla-put-LastHeight #spdstextstyle 5)


