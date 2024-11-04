;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Paul Koop M.A. - Sequenzanalyse empirisch gesicherter         ;;
;; Verkaufsgespräche                                              ;;
;;                                                                ;;
;; Dieses Programm simuliert Verkaufsgespräche durch die          ;;
;; Modellierung einer kontextfreien Grammatik (CFG) in Lisp.      ;;
;; Ziel ist die Analyse und Generierung dialogischer Sequenzen    ;;
;; anhand einer rekursiv strukturierten, gewichteten Grammatik.   ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Grammatikstruktur für Verkaufsgespräche (VKG)
;; -------------------------------------------
;; Hauptknoten: VKG
;; Übergänge und Gewichtungen spiegeln die Wahrscheinlichkeiten
;; von Verkaufsgesprächsabläufen wider (z.B., Begrüßung → Bedarf).
;;
;; VKG -> Begrüßung (BG) -> Verkaufstaetigkeit (VT) -> Verabschiedung (AV)
;; Die möglichen Ablaufmuster werden anhand empirischer Daten
;; gewichtet und modelliert.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Symbol-Definitionen für die Bestandteile des Gesprächs         ;;
;;                                                                ;;
;; Verkaufsgespräch    := VKG                                     ;;
;; Verkaufstaetigkeit  := VT                                      ;;
;; Begrüßung           := BG                                      ;;
;; Bedarf              := B                                       ;;
;; Bedarfsteilanalyse  := BA                                      ;;
;; Abschlusseinwände   := AE                                      ;;
;; Abschluss           := AA                                      ;;
;; Verabschiedung      := AV                                      ;;
;; Kunde               := K (präfix für Kundenaussagen)           ;;
;; Verkäufer           := V (präfix für Verkäueraussagen)         ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Hauptstruktur des Verkaufsgesprächs als CFG-Regeln             ;;
;; VKG leitet Begrüßung ein und endet mit Verabschiedung          ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq vkg
  '(((bg) 100 (vt))                ;; Begrüßung → Verkaufstaetigkeit
    ((vt) 50 (vt))                 ;; Wiederholte Verkaufstaetigkeit
    ((vt) 100 (av))))              ;; Verkaufstaetigkeit → Verabschiedung

;; Begrüßungsregel - Kunde und Verkäufer wechseln Begrüßung aus
(setq bg
  '((kbg 100 vbg)))

;; Bedarfsteil des Gesprächs - Kunde äußert Bedarf, Verkäufer bestätigt
(setq bbd
  '((kbbd 100 vbbd)))

;; Bedarfsteilanalyse - Beide Seiten diskutieren über Bedarf
(setq ba
  '((kba 100 vba)))

;; Einwandsbehandlung im Abschluss - Kunde und Verkäufer klären Einwände
(setq ae
  '((kae 100 vae)))

;; Abschluss des Gesprächs - Kunde und Verkäufer schließen ab
(setq aa
  '((kaa 100 vaa)))

;; Abschließende Verabschiedung - Kunde und Verkäufer verabschieden sich
(setq av
  '((kav 100 vav)))

;; Verkaufsaktivität, bestehend aus Bedarf und Abschlussphasen
(setq vt
  '(((b) 50 (b))                   ;; Bedarfsteil
    ((b) 100 (a))))                ;; Abschluss

;; Struktur des Bedarfsteils im Verkaufsgespräch
(setq b
  '(((bbd) 100 (ba))))             ;; Bedarfsaustausch → Bedarfsanalyse

;; Abschlussstruktur - bestehend aus Einwänden und Abschluss
(setq a
  '(((ae) 50 (ae))                 ;; Einwände wiederholt
    ((ae) 100 (aa))))              ;; Einwände → Abschluss


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Generierung von Sequenzen basierend auf Regeln                 ;;
;;                                                                ;;
;; Die folgende Funktion generiert dialogische Sequenzen gemäß    ;;
;; der definierten Regeln und Gewichtungen. Sie simuliert den     ;;
;; Dialogverlauf gemäß der CFG.                                   ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Hauptfunktion zur Generierung der Sequenz
(defun generate-sequence (state rules)
  "Generiert eine Sequenz basierend auf dem aktuellen Zustand und den Regeln."
  (cond
    ;; Sequenzende erreicht, gib nil zurück
    ((equal state nil) nil)

    ;; Wenn der Zustand terminal ist, gib ihn direkt zurück und gehe zur nächsten
    ((atom state) (cons state (generate-sequence (next-state state rules (random 101)) rules)))

    ;; Andernfalls erweitere den nicht-terminalen Zustand und fahre rekursiv fort
    (t (cons (eval state) (generate-sequence (next-state state rules (random 101)) rules)))))

;; Funktion zur Auswahl des nächsten Zustands
(defun next-state (state rules probability)
  "Wählt den nächsten Zustand basierend auf Regeln und einer Zufallswahrscheinlichkeit."
  (cond
    ;; Falls keine Regeln mehr vorhanden, gib nil zurück
    ((equal rules nil) nil)

    ;; Prüft, ob die Regel für die Wahrscheinlichkeit zutrifft und gibt den Nachfolger zurück
    ((and (<= probability (car (cdr (car rules))))
          (equal state (car (car rules))))
     (car (reverse (car rules))))

    ;; Andernfalls durchsuche die restlichen Regeln weiter
    (t (next-state state (cdr rules) probability))))

;; Hilfsfunktion zur Auswahl der ersten Sequenzregel
(defun initial-rule (rules)
  "Wählt die erste Regel der Regelmenge."
  (car (car rules)))

;; Startet die Simulation für die Fallstruktur
(defun simulate (rules)
  "Startet die Sequenzgenerierung basierend auf den initialen Regeln."
  (generate-sequence (initial-rule rules) rules))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Simulation starten und Sequenzen generieren                    ;;
;;                                                                ;;
;; (simulate vkg) ruft die Simulation für das Verkaufsgespräch    ;;
;; auf und gibt die erzeugte Sequenz zurück.                      ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Die Simulation wird für Welt 3 (Verkaufsgesprächsstruktur) gestartet
(simulate vkg)
