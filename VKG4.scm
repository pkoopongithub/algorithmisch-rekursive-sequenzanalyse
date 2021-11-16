;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Paul Koop M.A. GRAMMATIKINDUKTION empirisch                    ;;
;; gesicherter Verkaufsgespraeche                                 ;;
;;                                                                ;;
;; Die Simulation wurde ursprunglich entwickelt,                  ;;
;; um die Verwendbarkeit von kontextfreien Grammatiken            ;;
;; fuer die Algorithmisch Rekursive Sequanzanalyse                ;;
;; zu ueberpruefen					          ;;
;; Modellcharakter hat allein der Quelltext.                      ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;  __|__   ___|__    __|__   __|__   __|__   __|__               ;;
;;  |   |   |    |    |   |   |   |   |   |   |   |               ;;
;; KBG->VBGKBBd->VBBdKBA->VBAKAE->VAEKAA->VAAKAV-> VAV            ;;
;;                                                                ;;
;; Die Produktionen --> sind entsprechend ihrer                   ;;
;; emp. Auftrittswahrscheinlichkeit gewichtet                     ;;
;; DIE GRAMMATIK WIRD AUS DEM KORPUS INDUZIERT                    ;;
;; ein Left-to-the-Right-Modell                                   ;;                                                               
;;                                                                ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Transformationsmatrix                                      ;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;a	b c	d e	f c	d	e	f	g	h	i	j	g	h	i	j	k	l ;;
;;0	1 2	3 4	5 2	3	4	5	6	7	8	9	6	7	8	9	10	11;;
;;                                                                ;;
;;	0	1	2	3	4	5	6	7	8	9	10	11	12	13	      ;;
;;0	-	1														  ;;																		
;;1	-		2													  ;;																		
;;2	-		-	2												  ;;																		
;;3	-		-		2											  ;;																		
;;4	-	-	-	-	-	2										  ;;																		
;;5	-		1				2									  ;;																		
;;6	-		-				-	2								  ;;																		
;;7	-		-				-		2							  ;;																		
;;8	-		-	-	-	-	-	-	-	2						  ;;																		
;;9	-						1				1					  ;;																		
;;10	-	-	-	-	-	-	-	-	-	-	-	1			  ;;																			
;;11															  ;;																			
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                                ;;
;; Begruessung           := BG                                    ;;
;; Bedarf                := Bd                                    ;;
;; Bedarfsargumentation  := BA                                    ;;
;; Abschlusseinwaende    := AE                                    ;;
;; Verkaufsabschluss     := AA                                    ;;
;; Verabscheidung        := AV                                    ;;
;; Kunde                 := vorangestelltes K                     ;;
;; Verkaeufer            := vorangestelltes V                     ;;
;;                                                                ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Korpus 
   (define korpus (list 'KBG 'VBG 'KBBd 'VBBd 'KBA 'VBA 'KBBd 'VBBd 'KBA 'VBA 'KAE 'VAE 'KAE 'VAE 'KAA 'VAA 'KAV 'VAV));; 0 - 17
   
   

   ;; Korpus durchlaufen  
    (define (lesen korpus)
     ;; car ausgeben
    (display (car korpus))
     ;; mit cdr weitermachen
     (if(not(null? (cdr korpus)))
       (lesen (cdr korpus))
       ;;(else)
     )
   )
   
;; Lexikon 
   (define lexikon (vector 'KBG 'VBG 'KBBd 'VBBd 'KBA 'VBA 'KAE 'VAE 'KAA 'VAA 'KAV 'VAV)) ;; 0 - 12 
   


   ;; Index fuer Zeichen ausgeben 
    (define (izeichen zeichen)
     (define wertizeichen 0)
     (do ((i 0 (+ i 1)))
      ( (equal? (vector-ref lexikon i) zeichen)) 
      (set! wertizeichen (+ 1 i))
     )
     ;;index zurueckgeben
     wertizeichen
   )
   
;; transformationsmatrix 
   (define zeile0 (vector 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0))
   (define zeile1 (vector 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0))
   (define zeile2 (vector 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0))
   (define zeile3 (vector 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0))
   (define zeile4 (vector 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0))
   (define zeile5 (vector 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0))
   (define zeile6 (vector 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0))
   (define zeile7 (vector 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0))
   (define zeile8 (vector 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0))
   (define zeile9 (vector 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0))
   (define zeile10 (vector 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0))
   (define zeile11 (vector 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0))
   (define zeile12 (vector 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0))
   (define zeile13 (vector 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0))
   (define zeile14 (vector 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0))
   (define zeile15 (vector 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0))
   (define zeile16 (vector 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0))
   (define zeile17 (vector 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0))
   
   (define matrix (vector zeile0 zeile1 zeile2 zeile3 zeile4 zeile5 zeile6 zeile7 zeile8 zeile9 zeile10 zeile11 zeile12 zeile13 zeile14 zeile15 zeile16 zeile17))
   
 
   ;; Transformationen zaehlen 
      ;; Korpus durchlaufen  
   (define (transformationenZaehlen korpus)
     ;; car zaehlen
      (vector-set! (vector-ref matrix (izeichen (car korpus))) (izeichen (car(cdr korpus))) (+ 1 (vector-ref  (vector-ref matrix (izeichen (car korpus))) (izeichen (car(cdr korpus))))))
     ;; mit cdr weitermachen
      (if(not(null? (cdr (cdr korpus))))
       (transformationenZaehlen (cdr korpus))
       ;;(else)
      )
   )

   
   ;; Transformation aufaddieren
   
   ;; Zeilensummen bilden und Prozentwerte bilden
  

;; Grammatik
   (define grammatik (list '- ))
   
   ;; aus matrix regeln bilden und regeln in grammatik einfügene 
   (define (grammatikerstellen matrix)
    (do ((a 0 (+ a 1)))
        ((= a 12) )(newline)
      (do ((b 0 (+ b 1)))
          ((= b 12))
        (if (< 0 (vector-ref  (vector-ref matrix a) b) )  
         (display (cons (vector-ref lexikon a) (cons '-> (vector-ref lexikon b))))
         )
      )
    )
   )   
   

  ;; matrix ausgeben 
   (define (matrixausgeben matrix)
    (do ((a 0 (+ a 1)))
        ((= a 12) ) (newline)
      (do ((b 0 (+ b 1)))
          ((= b 12))
        (display (vector-ref  (vector-ref matrix a) b)) 
      )
    )
   )   
 
 