





(defun c:jte ( / shell scr)
  (setq shell (vlax-get-or-create-object "wscript.shell"))
  (setq scr (strcat "javaw -jar " #lisppath "java\\" "texteditor.jar"))
  (vlax-invoke-method shell "run" scr 1 :vlax-true)
  (vlax-release-object shell) (setq shell nil)
  );defun



(defun OpenFile (FileFullName / ShellApp)
  (vl-load-com)
  (if (setq ShellApp (vla-getInterfaceObject (vlax-get-acad-object) "Shell.Application"))
    (progn
      (if (findfile FileFullName)
	(vlax-invoke-method ShellApp 'ShellExecute FileFullName)
	(princ (strcat "\n** File " FileFullName " not found! **"))
	); end if
      (vlax-release-object ShellApp)
      (setq ShellApp nil)
      ); end progn
    ); end if
  (princ)
  ); end of OpenFile




(setq ShellApp (vla-getInterfaceObject (vlax-get-acad-object) "Shell.Application"))
(vlax-invoke-method ShellApp "ShellExecute" (strcat #lisppath "java\\" "texteditor.jar"))
(vlax-release-object ShellApp)



(startapp "javaw" (strcat "-jar " #lisppath "java\\" "texteditor.jar"))
	  



(startapp "javaw" (strcat "-jar " #lisppath "java\\" "JavaApplication5.jar"))



(defun c:jte ( / shell scr)
  (setq shell (vlax-get-or-create-object "wscript.shell"))
  (setq scr (strcat "javaw -jar " #lisppath "java\\" "JavaApplication5.jar"))
  (vlax-invoke-method shell "run" scr 1 :vlax-true)
  (vlax-release-object shell) (setq shell nil)
  );defun