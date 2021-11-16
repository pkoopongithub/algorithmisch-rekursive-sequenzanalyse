;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Paul Koop M.A. 1994 Sequenzanalyse empirisch                   ;;
;; gesicherter Verkaufsgespraeche                                 ;;
;;                                                                ;;
;; Die Simulation wurde ursprunglich entwickelt,                  ;;
;; um die Verwendbarkeit von kontextfreien Grammatiken            ;;
;; fuer die Algorithmisch Rekursive Sequanzanalyse                ;;
;; zu ueberpruefen					          ;;
;; Modellcharakter hat allein der Quelltext.                      ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                                ;;
;;                        VKG                                     ;;
;;    _____________________|_____________________                 ;;
;;    |                    |                    |                 ;;
;;    BG------------------>VT------------------>AV                ;;
;;    |             _______|________            |                 ;;
;;    |             |              |            |                 ;;
;;    |             B------------->A            |                 ;;
;;    |        _____|____       ___|_____       |                 ;;
;;    |        |        |       |       |       |                 ;;
;;    |       BBd----->BA      AE----->AA       |                 ;;
;;  __|__   ___|__    __|__   __|__   __|__   __|__               ;;
;;  |   |   |    |    |   |   |   |   |   |   |   |               ;;
;; KBG->VBGKBBd->VBBdKBA->VBAKAE->VAEKAA->VAAKAV-> VAV            ;;
;;                                                                ;;
;; Die Produktionen --> sind entsprechend ihrer                   ;;
;; emp. Auftrittswahrscheinlichkeit gewichtet                     ;;
;; Waehrend die Kanten des Strukturbaumes ein Top-down-Modell     ;;
;; wiedergeben, bilden die Produktionen                           ;;
;; des Kategoriensystem-Systems (K-System)                        ;;
;; ein Left-to-the-Right-Modell                                   ;;                                                               
;;                                                                ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                                ;;
;; Verkaufsgespraech     := VKG                                   ;;
;; Verkaufstaetigkeit    := VT                                    ;;
;; Bedarfsteil           := B                                     ;;
;; Abschlussteil         := A                                     ;;
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                                ;;
;; - Die Fallstruktur wird rein physikalisch protokolliert        ;;
;;   mechanisch, magnetisch, optisch oder digital D/A-Wandler     ;;
;;   (interpretationsfreies physikalisches Protokoll)             ;;
;;   z.B. Mikrophonierung, Kinematographie,                       ;;
;;   Optik, Akustik, mechanische, analoge, digitale Technik       ;;
;; - Das Protokoll wird transkribiert                             ;;
;;   (Vertextung, diskrete Ereigniskette,                         ;;
;;    Plausibilitaet, Augenscheinvalidität)                       ;;
;;   Searle, Austin: Sprechakte, Paraphrase, moegl.               ;;
;;   Intentionen, konstitutive, konventionelle Regeln             ;;
;; - Durch Lesartenproduktion und Lesartenfalsifikation           ;;                      
;;   wird Sequenzstelle fuer Sequenzstelle informell              ;;
;;   das Regelsystem erzeugt                                      ;;
;;   Searle, Austin: Sprechakte, Paraphrase, moegl.               ;;
;;   Intentionen, konstitutive, konventionelle Regeln             ;;
;;   (bei jeder Sequenzstelle werden extensiv Lesarten erzeugt,   ;;
;;    die Lesarten jeder nachfolgenden Sequenzstelle              ;;
;;    falsifizieren die Lesarten der vorausgehenden Sequenzstelle,;;
;;    Oevermann: Sequenzanalyse                                   ;;
;;    das Regelsystem bildet ein kontextfreies Chomskysystem,     ;;
;;    die Ersetzungsregeln sind nach Auftrittswahrscheinlichkeit  ;;
;;    gewichtet, die Interkodierreliabilitaet wird bestimmt,      ;;
;;    z.B. Mayring R, Signifikanz z.B. Chi-Quadrat)               ;;
;; - Die Regeln werden in ein K-System uebersetzt                 ;;
;;   dabei werden die Auftrittshaeufigkeiten kumuliert            ;;
;;   um den Rechenaufwand zur Laufzeit zu minimieren              ;;
;;   Chomsky: formale Sprachen                                    ;;               
;; - Auf einem Computer wird unter LISP eine Simulation gefahren  ;;
;;   McCarthy, Papert, Solomon, Bobrow, Feuerzeig               
;; - Das Resultat der Simulation, eine terminale Zeichenkette,    ;;
;;   wird in ein Protokoll uebersetzt                             ;;
;; - Das künstlich erzeugte Protokoll wird auf seine Korrelation  ;;               
;;   mit empirischen Protokollen ueberprueft                      ;;                 
;; - Bei Bedarf werden Korrekturen am K-System vorgenommen        ;;
;;   und die Simulation wird wiederholt                           ;;
;;                                                                ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                                ;;
;; Welt 3 Popper                                                  ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(setq w3
'(
 (anfang 100 (s vkg)) ;; hier nur Fallstruktur Verkaufsgespraeche
 ((s vkg) 100 ende) 
 )
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                                ;;
;; Kunde teilt Bedarf mit, Verkaeufer spiegelt Bedarf Kunde       ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(setq bbd
'(
 (kbbd 100 vbbd)
 )
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                                ;;
;; wechselseitige Bedarfsargumentation nach Bedarfsmitteilung     ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(setq ba
'(
 (kba 100 vba)
 )
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                                ;;
;; wechselseitige Einwandsabklaerung                              ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(setq ae
'(
(kae 100 vae)
 )
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                                ;;
;; Verkaufsabschluss                                              ;;
;; des Abschlussteils nach den Abschlusseinwaenden                ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(setq aa
'(
 (kaa 100 vaa)
 )
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                                ;;
;; Bedarfsteils                                                   ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq b
'(
 ((s bbd) 100 (s ba))
 )
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                                ;;
;; Abschlussteil                                                  ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(setq a
'(
 ((s ae)50(s ae))
 ((s ae)100(s aa))
 )
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                                ;;
;; Verkaufsteil                                                   ;;
;; im Anschluss an Begruessung                                    ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq vt
'(
 ((s b)50(s b))
 ((s b)100(s a))
 )
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                                ;;
;; Begruessung                                                    ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq bg
'(
 (kbg 100 vbg)
 )
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                                ;;
;; Verabschiedung                                                 ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(setq av
'(
 (kav 100 vav)
 )
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                                ;;
;; Verkaufsgespraech                                              ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(setq vkg
'(
 ((s bg)100(s vt))
 ((s vt)50(s vt))
 ((s vt)100(s av))
 )
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                                ;;
;; Algorithmus ueber generativer Struktur                         ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; Generiert die Sequenz
(defun gs (st r);; Uebergabe Sequenzstelle und Regelliste 
(cond

  ;; gibt nil zurück, wenn das Sequenzende ereicht ist
  ((equal st nil) nil)

  ;; gibt terminale Sequenzstelle mit Nachfolgern zurueck 
  ((atom st)(cons st(gs(next st r(random 101))r)))
      
  ;; gibt expand. nichtterm. Sequenzstelle mit Nachfolger zurueck
  (t (cons(eval st)(gs(next st r(random 101))r)))       
)
)

;; Generiert nachfolgende Sequenzstelle
(defun next (st r z);; Sequenzstelle, Regeln und Haeufigkeitsmass 
(cond

  ;; gibt nil zurueck, wenn das Sequenzende erreicht ist
  ((equal r nil)nil)

  ;; waehlt Nachfolger mit Auftrittsmass h                                 
  (
    (
       and(<= z(car(cdr(car r))))
       (equal st(car(car r)))
    )
   (car(reverse(car r)))
  )

  ;; in jedem anderen Fall wird Regelliste weiter durchsucht
  (t(next st (cdr r)z))                
)
)

;; waehlt erste Sequenzstelle aus Regelliste
;;vordefinierte funktion first wird ueberschrieben, alternative umbenennen
(defun first (list)
(car(car list))
)

;; startet Simulation fuer eine Fallstruktur
(defun s (list) ;; die Liste mit dem K-System wird uebergeben     
(gs(first list)list)
) 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                                ;;
;; Ruft den Algorithmus auf / Welt 3 Popper /alt. jew. Fallstrukt.;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; alternativ (s vkg) / von der Konsole aus (s w3) oder (s vkg)
(s w3) 
 
