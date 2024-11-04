;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Chart-Parser für Verkaufsgespräch CFG
;; Der Parser prüft, ob eine gegebene Folge von Terminalzeichen
;; gemäß den CFG-Regeln des Verkaufsgesprächs analysierbar ist.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Die gegebenen CFG-Regeln als Listenstrukturen:
(setq vkg
  '(((bg) 100 (vt))
    ((vt) 50 (vt))
    ((vt) 100 (av))))

(setq bg
  '((kbg 100 vbg)))

(setq bbd
  '((kbbd 100 vbbd)))

(setq ba
  '((kba 100 vba)))

(setq ae
  '((kae 100 vae)))

(setq aa
  '((kaa 100 vaa)))

(setq av
  '((kav 100 vav)))

(setq vt
  '(((b) 50 (b))
    ((b) 100 (a))))

(setq b
  '(((bbd) 100 (ba))))

(setq a
  '(((ae) 50 (ae))
    ((ae) 100 (aa))))

;; Funktion zur Regelauflösung basierend auf einem Symbol
(defun resolve-rule (symbol)
  "Gibt die Regel für das Symbol zurück, wenn sie definiert ist."
  (cond ((eq symbol 'vkg) vkg)
        ((eq symbol 'bg) bg)
        ((eq symbol 'bbd) bbd)
        ((eq symbol 'ba) ba)
        ((eq symbol 'ae) ae)
        ((eq symbol 'aa) aa)
        ((eq symbol 'av) av)
        ((eq symbol 'vt) vt)
        ((eq symbol 'b) b)
        ((eq symbol 'a) a)
        (t nil)))  ; Wenn keine Regel existiert, gib NIL zurück

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Chart-Parser Funktionen
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Struktur eines Chart-Eintrags: (position symbol start end)
(defun make-chart-entry (position symbol start end)
  "Erzeugt einen neuen Chart-Eintrag."
  (list position symbol start end))

(defun add-to-chart (chart entry)
  "Fügt einen Eintrag dem Chart hinzu, wenn er noch nicht existiert."
  (unless (member entry chart :test #'equal)
    (push entry chart))
  chart)

(defun expand (chart position symbol start end)
  "Erzeugt Einträge für die expandierten Symbole im Chart."
  (let ((rules (resolve-rule symbol)))
    (when rules
      (dolist (rule rules)
        (let ((lhs (car rule))
              (rhs (cddr rule)))
          (add-to-chart chart (make-chart-entry position lhs start end))
          (dolist (sub-symbol rhs)
            (add-to-chart chart (make-chart-entry position sub-symbol end end))))))))

(defun scan (chart input position start end)
  "Scannt das nächste Terminalsymbol und überprüft, ob es passt."
  (when (and (< end (length input))
             (equal (nth end input) (nth position input)))
    (add-to-chart chart (make-chart-entry position (nth end input) start (1+ end)))))

(defun complete (chart entry)
  "Schließt eine vollständige Ableitung ab, falls möglich."
  (dolist (other chart)
    (when (and (= (cadddr other) (cadr entry))
               (equal (caddr other) (car entry)))
      (add-to-chart chart (make-chart-entry (car entry)
                                            (cadr other)
                                            (caddr other)
                                            (cadddr entry))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Hauptfunktion des Chart-Parsers
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun chart-parse (input)
  "Parst die Eingabe basierend auf der CFG und gibt den Chart zurück."
  (let ((chart nil))
    (expand chart 0 'vkg 0 0)  ; Starte mit dem Startsymbol
    (loop for pos from 0 below (length input)
          do (dolist (entry chart)
               (if (equal (caddr entry) pos)
                   (progn
                     (expand chart (car entry) (cadr entry) pos (cadddr entry))
                     (scan chart input (car entry) pos (cadddr entry))
                     (complete chart entry)))))
    chart))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Beispielaufruf mit Terminalsequenz
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Beispiel Eingabesequenz aus Terminalzeichen
(setq example-sequence '(kbg vbg kbbd vbbd kba vba kae vae kaa vaa kav vav))

;; Parse die Eingabesequenz und gib den Chart zurück
(print (chart-parse example-sequence))
