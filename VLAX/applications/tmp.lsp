(vlax-get-object "")
(vl-load-com)
(vlax-dump-object (vlax-get-object "InternetExplorer.Application"))
(setq ie (vlax-get-object "InternetExplorer.Application"))
(vlax-dump-object ie)
(vlax-put-string )
(vlax-put-property ie 'AddressBar (vlax-make-variant "mail.ru"))





