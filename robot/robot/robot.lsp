(module "crypto.lsp")

(change-dir "c:/election")

; Запросить файл из Интернета или из кэша. 
(define (cache-url url)
  (let (file-name (append "cache/" (crypto:md5 url)))
    (if (file? file-name)
      (read-file file-name)
      (begin
        (set 'text (get-url url))
        (write-file file-name text)
        text))))

; Выгрызает из html-файла выборов двумерный список, содержащий
; номера УИК и данные выборов.
(define (parse-html text)
  (map 
    (fn (x) (find-all "(?si)(<td)(.*?)(</td>)" x (cut-data $it)))
    (find-all 
      "(?si)(<tr)(.*?)(</tr>)"
      ((regex {(?si)(0" align="left">)(.*?)(</table>)} text) 0))))

; Извлекает из ячейки нужные нам данные или название избирательной комиссии
(define (cut-data line)
  (if (find "УИК" line)
    (set 'tag "nobr>")
    (set 'tag "b>"))
  (if (find (append "(?si)(?<=<" tag ")(.*)(?=</" tag ")") line 1)
    $it
    nil))

; Выбирает ссылки на другие файлы голосований
(define (extract-links url)
  (find-all {http://.*?379(?=")} (cache-url url)))

(set 'start-page "http://www.moscow_city.vybory.izbirkom.ru/region/region/moscow_city?action=show&root=1&tvd=2772000268687&vrn=2772000268682&region=77&global=&sub_region=77&prver=0&pronetvd=0&vibid=2772000268687&type=379")

(dolist (x (flat (map extract-links (extract-links start-page))))
  (dolist (y (transpose (parse-html (cache-url x))))
    (println (join (map string y) ","))))

(exit)