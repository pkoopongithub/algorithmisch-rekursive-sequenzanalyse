;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Paul Koop M.A. GRAMMATIKINDUKTION empirisch                   ;;
;; gesicherter Verkaufsgespraeche                                ;;
;;                                                               ;;
;; Die Simulation wurde ursprunglich entwickelt,                 ;;
;; um die Verwendbarkeit von kontextfreien Grammatiken           ;;
;; fuer die Algorithmisch Rekursive Sequenzanalyse               ;;
;; zu ueberpruefen.                                              ;;
;; Modellcharakter hat allein der Quelltext.                     ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Korpus: Folge von Terminalsymbolen
(define korpus (list 'KBG 'VBG 'KBBd 'VBBd 'KBA 'VBA 'KAE 'VAE 'KAA 'VAA 'KAV 'VAV))

;; Lexikon: Terminalsymbole, die in der Grammatik verwendet werden
(define lexikon (vector 'KBG 'VBG 'KBBd 'VBBd 'KBA 'VBA 'KAE 'VAE 'KAA 'VAA 'KAV 'VAV))

;; transformationsmatrix wird hier initialisiert
(define matrix (make-vector 12 (make-vector 12 0)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Hilfsfunktion zur Indizierung eines Zeichens im Lexikon
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define (find-index symbol)
  (let loop ((i 0))
    (cond ((= i (vector-length lexikon)) #f) ;; Symbol nicht gefunden
          ((equal? (vector-ref lexikon i) symbol) i)
          (else (loop (+ i 1))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Funktion zur Transformation und Zählung von Übergängen
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define (transformationen-zaehlen korpus)
  (define (process-pair a b)
    (let ((i (find-index a))
          (j (find-index b)))
      (when (and i j) ;; Falls beide Symbole gefunden werden
        (let ((current-value (vector-ref (vector-ref matrix i) j)))
          (vector-set! (vector-ref matrix i) j (+ current-value 1))))))
  (let loop ((rest korpus))
    (if (< (length rest) 2)
        'done
        (begin
          (process-pair (car rest) (cadr rest))
          (loop (cdr rest))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Ausgabe der Matrix zur Kontrolle der Transformationen
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define (matrix-ausgeben matrix)
  (for-each
   (lambda (row)
     (for-each (lambda (val) (display val) (display " ")) row)
     (newline))
   (vector->list matrix)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Grammatik erstellen auf Basis der Transformationen
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define (grammatik-erstellen matrix)
  (for-each
   (lambda (i)
     (for-each
      (lambda (j)
        (let ((count (vector-ref (vector-ref matrix i) j)))
          (when (> count 0)
            (display (list (vector-ref lexikon i) '-> (vector-ref lexikon j)))
            (display " : Häufigkeit ") (display count) (newline))))
      (iota (vector-length lexikon))))
   (iota (vector-length lexikon))))

;; Simulation starten: Transformationen zählen, Matrix ausgeben, Grammatik erzeugen
(transformationen-zaehlen korpus)
(display "Transformationsmatrix:\n")
(matrix-ausgeben matrix)
(display "\nErzeugte Grammatik:\n")
(grammatik-erstellen matrix)
