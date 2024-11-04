;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Paul Koop M.A. GRAMMAR INDUCTION for empirically             ;;
;; validated sales conversations                                 ;;
;;                                                               ;;
;; This simulation was originally developed to verify the        ;;
;; applicability of context-free grammars for Algorithmic        ;;
;; Recursive Sequence Analysis.                                  ;;
;; Only the source code has a model character.                   ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Corpus: Sequence of terminal symbols representing the grammar
(define korpus (list 'KBG 'VBG 'KBBd 'VBBd 'KBA 'VBA 'KAE 'VAE 'KAA 'VAA 'KAV 'VAV))

;; Lexicon: Terminal symbols used in the grammar
(define lexikon (vector 'KBG 'VBG 'KBBd 'VBBd 'KBA 'VBA 'KAE 'VAE 'KAA 'VAA 'KAV 'VAV))

;; transformations matrix is initialized here
(define matrix (make-vector 12 (make-vector 12 0)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Helper function to find the index of a symbol in the lexicon
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define (find-index symbol)
  (let loop ((i 0))
    (cond ((= i (vector-length lexikon)) #f) ;; Symbol not found
          ((equal? (vector-ref lexikon i) symbol) i)
          (else (loop (+ i 1))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Function to count transformations (transitions) between symbols
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define (transformationen-zaehlen korpus)
  ;; Nested function to process pairs of symbols and count transitions
  (define (process-pair a b)
    (let ((i (find-index a))
          (j (find-index b)))
      (when (and i j) ;; If both symbols are found in the lexicon
        (let ((current-value (vector-ref (vector-ref matrix i) j)))
          (vector-set! (vector-ref matrix i) j (+ current-value 1))))))
  ;; Loop through the corpus to process symbol pairs
  (let loop ((rest korpus))
    (if (< (length rest) 2)
        'done
        (begin
          (process-pair (car rest) (cadr rest))
          (loop (cdr rest))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Function to output the matrix for verifying transformations
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define (matrix-ausgeben matrix)
  (for-each
   (lambda (row)
     (for-each (lambda (val) (display val) (display " ")) row)
     (newline))
   (vector->list matrix)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Create grammar rules based on transformations in the matrix
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define (grammatik-erstellen matrix)
  (for-each
   (lambda (i)
     (for-each
      (lambda (j)
        (let ((count (vector-ref (vector-ref matrix i) j)))
          (when (> count 0)
            (display (list (vector-ref lexikon i) '-> (vector-ref lexikon j)))
            (display " : Frequency ") (display count) (newline))))
      (iota (vector-length lexikon))))
   (iota (vector-length lexikon))))

;; Start simulation: count transformations, output matrix, generate grammar
(transformationen-zaehlen korpus)
(display "Transformation Matrix:\n")
(matrix-ausgeben matrix)
(display "\nGenerated Grammar:\n")
(grammatik-erstellen matrix)
