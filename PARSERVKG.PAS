PROGRAM parser (INPUT,OUTPUT);
USES CRT;
(***************************************************************************)
(* Paul Koop Chart Parser VKG                                              *)
(*                                                                         *)
(***************************************************************************)

  (*-----------------------------------------------------------------------*)
  (* Vereinbarungsteil                                                     *)
  (*-----------------------------------------------------------------------*)

  CONST
    c0               =     0;
    c1               =     1;
    c2               =     2;
    c3               =     3;
    c4               =     4;
    c5               =     5;
   c10               =    10;
   c11               =    11;
   cmax              =    80;
   cwort             =    20;
   CText             :    STRING(.cmax.) = '';
   datei             =    'LEXIKONVKG.ASC';
   blank             =    ' ';

   CopyRight
   =    'Demo-Parser Chart-Parser Version 1.0(c)1992 by Paul Koop';

  TYPE
   TKategorien       = ( Leer, VKG, BG, VT, AV, B, A, BBD, BA, AE, AA,
                          KBG, VBG, KBBD, VBBD, KBA, VBA, KAE, VAE,
                          KAA, VAA, KAV, VAV);


   PTKategorienListe = ^TKategorienListe;
   TKategorienListe  = RECORD
                        Kategorie :TKategorien;
                        weiter    :PTKategorienListe;
                       END;

   PTKante           = ^TKante;
   PTKantenListe     = ^TKantenListe;

   TKantenListe      = RECORD
                        kante:PTKante;
                        next :PTKantenListe;
                       END;

   TKante            = RECORD
                        Kategorie :TKategorien;
                        vor,
                        nach,
                        zeigt     :PTKante;
                        gefunden  :PTKantenListe;
                        aktiv     :BOOLEAN;
                        nummer    :INTEGER;
                        nachkomme :BOOLEAN;
                        CASE  Wort:BOOLEAN OF
                         TRUE :
                             (inhalt:STRING(.cwort.););
                         FALSE:
                             (gesucht :PTKategorienListe;);
                        END;


   TWurzel    = RECORD
                  spalte,
                  zeigt     :PTKante;
                 END;

   TEintrag    = RECORD
                 A,I   :PTKante;
                 END;

   PTAgenda    = ^TAgenda;
   TAgenda     = RECORD
                  A,I  :PTKante;
                  next,
                  back : PTAgenda;
                 END;

   PTLexElem   = ^TLexElem;
   TLexElem    = RECORD
                  Kategorie: TKategorien;
                  Terminal : STRING(.cwort.);
                  naechstes: PTLexElem;
                 END;

   TGrammatik  = ARRAY (.c1..c10.)
                 OF
                 ARRAY (.c1..c4.)
                 OF TKategorien;
  CONST
   Grammatik :      TGrammatik =
               (
                (VKG, BG,      VT,    AV),
                (BG,  KBG,     VBG,   Leer),
                (VT,  B,       A,     Leer),
                (AV,  KAV,     VAV,   Leer),
                (B,   BBd,     BA,    Leer),
                (A,   AE,      AA,    Leer),
                (BBd, KBBd,    VBBd,  Leer),
                (BA,  KBA,     VBA,   Leer),
                (AE,  KAE,     VAE,   Leer),
                (AA,  KAA,     VAA,   Leer)
               );

  nummer :INTEGER = c0;

  (*-----------------------------------------------------------------------*)
  (* Variablen                                                             *)
  (*-----------------------------------------------------------------------*)


  VAR
   Wurzel,
   Pziel       : TWurzel;
   Pneu        : PTKante;

   Agenda,
   PAgenda,
   Paar        : PTAgenda;

   LexWurzel,
   LexAktuell,
   LexEintrag  : PTLexElem;
   Lexikon     : Text;


(***************************************************************************)
(* FUNKTIONEN                                                              *)
(***************************************************************************)


  (*-----------------------------------------------------------------------*)
  (* KantenZaehler                                                         *)
  (*-----------------------------------------------------------------------*)

  FUNCTION NimmNummer:INTEGER;
   BEGIN
    Nummer := Nummer + c1;
    NimmNummer := Nummer
   END;



(***************************************************************************)
(* PROZEDUREN                                                              *)
(***************************************************************************)




  (*-----------------------------------------------------------------------*)
  (* LexikonLesen                                                          *)
  (*-----------------------------------------------------------------------*)

  PROCEDURE LiesDasLexikon (VAR f:Text;
                             G:TGrammatik;
                             l:PTLexElem);
    VAR
     zaehler :INTEGER;
     z11     : 1..c11;
     z4      : 1.. c4;
     ch      :   CHAR;
     st5     : STRING(.c5.);

   BEGIN
    ASSIGN(f,datei);
    LexWurzel := NIL;
    RESET(f);
    WHILE NOT EOF(f)
     DO
      BEGIN
       NEW(LexEintrag);
       IF LexWurzel = NIL
        THEN
         BEGIN
          LexWurzel := LexEintrag;
          LexAktuell:= LexWurzel;
          LexEintrag^.naechstes := NIL;
         END
        ELSE
         BEGIN
          LexAktuell^.naechstes := LexEintrag;
          LexEIntrag^.naechstes := NIL;
          LexAktuell            := LexAktuell^.naechstes;
         END;
       LexEintrag^.Terminal := '';
       st5 := '';
       FOR Zaehler := c1 to c5
        DO
         BEGIN
          READ(f,ch);
          st5 := st5 + UPCASE(ch)
         END;
       REPEAT
        READ(f,ch);
        LexEintrag^.terminal := LexEintrag^.Terminal + UPCASE(ch);
       UNTIL EOLN(f);
       READLN(f);
       IF st5 = 'KBG**' THEN  LexEintrag^.Kategorie := KBG    ELSE
       IF st5 = 'VBG**' THEN  LexEintrag^.Kategorie := VBG    ELSE
       IF st5 = 'KBBD*' THEN  LexEintrag^.Kategorie := KBBD   ELSE
       IF st5 = 'VBBD*' THEN  LexEintrag^.Kategorie := VBBD   ELSE
       IF st5 = 'KBA**' THEN  LexEintrag^.Kategorie := KBA    ELSE
       IF st5 = 'VBA**' THEN  LexEintrag^.Kategorie := VBA    ELSE
       IF st5 = 'KAE**' THEN  LexEintrag^.Kategorie := KAE    ELSE
       IF st5 = 'VAE**' THEN  LexEintrag^.Kategorie := VAE    ELSE
       IF st5 = 'KAA**' THEN  LexEintrag^.Kategorie := KAA    ELSE
       IF st5 = 'VAA**' THEN  LexEintrag^.Kategorie := VAA    ELSE
       IF st5 = 'KAV**' THEN  LexEintrag^.Kategorie := KAV    ELSE
       IF st5 = 'VAV**' THEN  LexEintrag^.Kategorie := VAV
      END;
   END;


  (*-----------------------------------------------------------------------*)
  (* SatzLesen                                                             *)
  (*-----------------------------------------------------------------------*)

  PROCEDURE LiesDenSatz;
   VAR
    satz:        STRING(.cmax.);
    zaehler:     INTEGER;
   BEGIN
    CLRSCR;
    WRITELN(CopyRight);
    WRITE('-----> ');
    Wurzel.spalte := NIL;
    Wurzel.zeigt  := NIL;
    READLN(satz);
    FOR zaehler := c1 to LENGTH(satz)
     DO satz(.zaehler.) := UPCASE(satz(.zaehler.));
    Satz := Satz + blank;
    Writeln('-----> ',satz);
    WHILE satz <> ''
    DO
    BEGIN
       NEW(Pneu);
       Pneu^.nummer   :=NimmNummer;
       Pneu^.wort     := TRUE;
       NEW(Pneu^.gefunden);
       Pneu^.gefunden^.kante := Pneu;
       pneu^.gefunden^.next  := NIL;
       Pneu^.gesucht         := NIL;
       Pneu^.nachkomme       :=FALSE;
       IF Wurzel.zeigt = NIL
        THEN
         BEGIN
           Wurzel.zeigt := pneu;
           Wurzel.spalte:= pneu;
           PZiel.spalte := pneu;
           PZiel.zeigt  := Pneu;
           pneu^.vor    := NIL;
           Pneu^.zeigt  := NIL;
           Pneu^.nach   := NIL;
         END
        ELSE
         BEGIN
          Wurzel.zeigt^.zeigt := Pneu;
          Pneu^.vor           := Wurzel.zeigt;
          Pneu^.nach          := NIL;
          Pneu^.zeigt         := NIL;
          Wurzel.zeigt        := Wurzel.zeigt^.zeigt;
         END;
       pneu^.aktiv   := false;
       pneu^.inhalt  := COPY(satz,c1,POS(blank,satz)-c1);
       LexAktuell    := LexWurzel;
       WHILE LexAktuell <> NIL
        DO
         BEGIN
          IF LexAktuell^.Terminal = pneu^.inhalt
           Then
            BEGIN
             pneu^.Kategorie := LexAktuell^.Kategorie;
            END;
          LexAktuell := LexAktuell^.naechstes;
         END;
       DELETE(satz,c1,POS(blank,satz));
      END;
   END;




  (*-----------------------------------------------------------------------*)
  (* Regel3KanteInAgendaEintragen                                          *)
  (*-----------------------------------------------------------------------*)

  PROCEDURE Regel3KanteInAgendaEintragen (Kante:PTKante);
   VAR
    Wurzel,
    PZiel  :TWurzel;
   PROCEDURE NeuesAgendaPaarAnlegen;
    BEGIN
     NEW(paar);
     IF Agenda = NIL
      THEN
       BEGIN
        Agenda := Paar;
        Pagenda:= Paar;
        Paar^.next := NIL;
        Paar^.back := NIL;
       END
      ELSE
       BEGIN
        PAgenda^.next := Paar;
        Paar^.next    := NIL;
        Paar^.back    := Pagenda;
        Pagenda       := Pagenda^.next;
      END;
    END;

   BEGIN
    IF Kante^.aktiv
     THEN
      BEGIN
       Wurzel.zeigt := Kante^.zeigt;
       WHILE wurzel.zeigt <> NIL
        DO
        BEGIN
         IF NOT(wurzel.zeigt^.aktiv)
          THEN
           BEGIN
            NeuesAgendaPaarAnlegen;
            paar^.A := kante;
            paar^.I := wurzel.zeigt;
           END;
        Wurzel.zeigt  := Wurzel.zeigt^.nach
        END
      END
     ELSE
     BEGIN
       PZiel.zeigt  := Kante;
       WHILE NOT(PZiel.zeigt^.Wort)
        DO PZiel.Zeigt := PZiel.Zeigt^.Vor;
       Wurzel.Zeigt    := PZiel.Zeigt;
       Wurzel.Spalte   := PZiel.Zeigt;
       PZiel.Spalte    := Pziel.zeigt;
       WHILE wurzel.spalte <> NIL
        DO
        BEGIN
         WHILE wurzel.zeigt <> NIL
         DO
         BEGIN
          IF wurzel.zeigt^.aktiv
           AND (Wurzel.zeigt^.zeigt = PZiel.spalte)
           THEN
            BEGIN
             NeuesAGendaPaarAnlegen;
             paar^.I := kante;
             paar^.A := wurzel.zeigt;
            END;
          Wurzel.zeigt  := Wurzel.zeigt^.nach
         END;
         wurzel.spalte  := wurzel.spalte^.vor;
         wurzel.zeigt   := wurzel.spalte;
        END
       END
      END;

  (*-----------------------------------------------------------------------*)
  (* AgendaAusgabe                                                         *)
  (*-----------------------------------------------------------------------*)

  PROCEDURE NimmAgendaEintrag(VAR PEintrag:PTAgenda);
   BEGIN
      IF PAgenda = Agenda
      THEN
       BEGIN
        PEintrag := Agenda;
        PAgenda  := NIL;
        Agenda   := NIL;
       END
      ELSE
       BEGIN
        PAGENDA       := PAGENDA^.back;
        PEintrag      := PAgenda^.next;
        PAGENDA^.next := NIL;
       END;
   END;




  (*-----------------------------------------------------------------------*)
  (* Regel2EineNeueKanteAnlegen                                            *)
  (*-----------------------------------------------------------------------*)

  PROCEDURE Regel2EineNeueKanteAnlegen( Kante     :PTKante;
                                        Kategorie :TKategorien;
                                        Gram      :TGrammatik );
   VAR
     Wurzel             :TWurzel;
     PHilfe,
     PGesuchteKategorie :PTKategorienListe;
     zaehler,
     zaehler2           :INTEGER;

   BEGIN
   Wurzel.zeigt := Kante;
   Wurzel.spalte:= Kante;
   WHILE Wurzel.zeigt^.nach <> NIL
    DO Wurzel.zeigt := Wurzel.zeigt^.nach;
    FOR zaehler := c1 To c11
     DO
      IF  (kategorie = Gram(.zaehler,c1.))
      AND (kategorie <> Leer)
       THEN
       BEGIN
        Gram(.zaehler,c1.) := Leer;
        NEW(pneu);
        Wurzel.zeigt^.nach := pneu;
        pneu^.nummer       := NimmNummer;
        pneu^.vor          := Wurzel.zeigt;
        Pneu^.nach         := NIL;
        Pneu^.zeigt        := wurzel.spalte;
        Wurzel.zeigt       := Wurzel.zeigt^.nach;
        pneu^.aktiv        := true;
        pneu^.kategorie    := kategorie;
        Pneu^.Wort         := false;
        Pneu^.gesucht      := NIL;
        Pneu^.gefunden     := NIL;
        Pneu^.nachkomme    := FALSE;
        FOR zaehler2 := c2 TO c4
         DO
         BEGIN
          IF Gram(.zaehler,zaehler2.) <> Leer
           THEN
            BEGIN
             NEW(PGesuchteKategorie);
             PGesuchteKategorie^.weiter:= NIL;
             PGesuchteKategorie^.Kategorie := Gram(.zaehler,zaehler2.);
             IF Pneu^.gesucht = NIL
              THEN
               BEGIN
                PHilfe        := PGesuchteKategorie;
                Pneu^.gesucht := PHilfe;
               END
              ELSE
               BEGIN
                PHilfe^.weiter := PGesuchteKategorie;
                PHilfe         := PHilfe^.weiter;
               END
            END
         END;
        Regel3KanteInAgendaEintragen (pneu);
        Regel2EineNeueKanteAnlegen(Wurzel.spalte,
                                   pneu^.gesucht^.kategorie,gram);
      END;
   END;



  (*-----------------------------------------------------------------------*)
  (* Regel1EineKanteErweiternen                                            *)
  (*-----------------------------------------------------------------------*)

  PROCEDURE Regel1EineKanteErweitern(paar:PTAgenda);
   VAR
    PneuHilf,Pneugefneu,AHilf :PTKantenListe;
   BEGIN

   IF paar^.I^.kategorie = paar^.A^.gesucht^.kategorie
    THEN
     BEGIN
      NEW(pneu);
      pneu^.nummer      := NimmNummer;
      pneu^.kategorie   := Paar^.A^.kategorie;
(*---------------------------------------------------*)
      Pneu^.gefunden := NIL;
      AHilf := Paar^.A^.gefunden;

      WHILE AHilf <> NIL
       DO
       BEGIN
        NEW(Pneugefneu);
        IF Pneu^.gefunden = NIL
         THEN
          BEGIN
           Pneu^.gefunden := Pneugefneu;
           PneuHilf       := Pneu^.gefunden;
           PneuHilf^.next := NIL;
          END
         ELSE
          BEGIN
           PneuHilf^.next   := Pneugefneu;
           PneuHilf         := PneuHilf^.next;
           PneuHilf^.next   := NIL;
          END;

        Pneugefneu^.kante     := AHilf^.kante;
        AHilf                 := AHilf^.next;
       END;

       NEW(Pneugefneu);
       IF Pneu^.gefunden = NIL
        THEN
         BEGIN
          Pneu^.gefunden := Pneugefneu;
          Pneugefneu^.next := NIL;
         END
        ELSE
         BEGIN
           PneuHilf^.next   := Pneugefneu;
           PneuHilf         := PneuHilf^.next;
           PneuHilf^.next   := NIL;
         END;
       Pneugefneu^.kante    := Paar^.I;
    (*--------------------------------------------*)
       Pneu^.wort             := FALSE;
       IF Paar^.A^.gesucht^.weiter = NIL
        THEN Pneu^.gesucht   := NIL
        ELSE Pneu^.gesucht   := Paar^.A^.gesucht^.weiter;
       Pneu^.nachkomme := TRUE;

      IF pneu^.gesucht   = NIL
       THEN Pneu^.aktiv := false
       ELSE Pneu^.aktiv := true;

      WHILE Paar^.A^.nach <> NIL
       DO Paar^.A       := Paar^.A^.nach;

      Paar^.A^.nach     := pneu;
      pneu^.vor         := Paar^.A;
      pneu^.zeigt       := Paar^.I^.zeigt;
      pneu^.nach        := NIL;

      Regel3KanteInAgendaEintragen (pneu);
      IF Pneu^.aktiv
       THEN Regel2EineNeueKanteAnlegen(Pneu^.zeigt,
                                     pneu^.gesucht^.kategorie,Grammatik);
     END;


   END;
  (*-----------------------------------------------------------------------*)
  (* SatzAnalyse                                                           *)
  (*-----------------------------------------------------------------------*)

   PROCEDURE SatzAnalyse;
    BEGIN
    WHILE Agenda <> NIL
    DO
     BEGIN
      NimmAgendaEintrag(Paar);
      Regel1EineKanteErweitern(Paar);
     END;

    END;
  (*-----------------------------------------------------------------------*)
  (* SatzAusgabe                                                           *)
  (*-----------------------------------------------------------------------*)

   PROCEDURE GibAlleSatzalternativenAus;
    CONST
     BlankAnz:INTEGER = c2;
    VAR
     PHilf   :PTkantenListe;

    PROCEDURE SatzAusgabe(Kante:PTKante;BlankAnz:INTEGER);
     VAR

     Zaehler:INTEGER;
     PHilf  :PTKantenListe;
     BEGIN
      FOR Zaehler := c1 TO BlankAnz DO WRITE(blank);

      IF Kante^.kategorie = VKG     THEN WRITELN ('VKG ') ELSE
      IF Kante^.kategorie = BG      THEN WRITELN ('BG  ') ELSE
      IF Kante^.kategorie = VT      THEN WRITELN ('VT  ') ELSE
      IF Kante^.kategorie = AV      THEN WRITE   ('AV  ') ELSE
      IF Kante^.kategorie = B       THEN WRITELN ('B   ') ELSE
      IF Kante^.kategorie = A       THEN WRITE   ('A   ') ELSE
      IF Kante^.kategorie = BBD     THEN WRITE   ('BBD ') ELSE
      IF Kante^.kategorie = BA      THEN WRITELN ('BA  ') ELSE
      IF Kante^.kategorie = AE      THEN WRITE   ('AE  ') ELSE
      IF Kante^.kategorie = AA      THEN WRITE   ('AA  ') ELSE
      IF Kante^.kategorie = KBG     THEN WRITELN ('KBG ') ELSE
      IF Kante^.kategorie = VBG     THEN WRITELN ('VBG ') ELSE
      IF Kante^.kategorie = KBBD    THEN WRITELN ('KBBD') ELSE
      IF Kante^.kategorie = VBBD    THEN WRITE   ('VBBD') ELSE
      IF Kante^.kategorie = KBA     THEN WRITELN ('KBA ') ELSE
      IF Kante^.kategorie = VBA     THEN WRITE   ('VBA ') ELSE
      IF Kante^.kategorie = KAE     THEN WRITE   ('KAE ') ELSE
      IF Kante^.kategorie = VAE     THEN WRITELN ('VAE ') ELSE
      IF Kante^.kategorie = KAA     THEN WRITE   ('KAA ') ELSE
      IF Kante^.kategorie = VAA     THEN WRITE   ('VAA ') ELSE
      IF Kante^.kategorie = KAV     THEN WRITE   ('KAV ') ELSE
      IF Kante^.kategorie = VAV     THEN WRITE   ('VAV ');

      IF Kante^.wort
       THEN
        WRITELN('----> ',Kante^.inhalt)
       ELSE
        BEGIN
        PHilf := Kante^.gefunden;
        WHILE PHilf <> NIL
         DO
          BEGIN
           Satzausgabe(PHilf^.kante,Blankanz+c1);
           PHilf := Philf^.next;
          END
        END
    END;

    BEGIN
      WHILE Wurzel.zeigt^.vor <> NIL
       DO Wurzel.zeigt := Wurzel.zeigt^.vor;

      WHILE Wurzel.zeigt <> NIL
      DO
      BEGIN
       IF (Wurzel.zeigt^.kategorie = VKG)
         AND ((NOT(Wurzel.zeigt^.aktiv))
         AND (wurzel.zeigt^.zeigt = NIL))
         THEN
          BEGIN
           WRITELN('VKG');
           PHilf := Wurzel.zeigt^.gefunden;
           WHILE PHilf <> NIL
            DO
             BEGIN
              Satzausgabe(PHilf^.kante,Blankanz+c1);
              PHilf := Philf^.next;
             END
          END;
      Wurzel.zeigt := Wurzel.zeigt^.nach;
      END;

    END;

  (*-----------------------------------------------------------------------*)
  (* FreigabeDesBenutztenSpeicherplatzes                                   *)
  (*-----------------------------------------------------------------------*)

  PROCEDURE LoescheDieListe;
   PROCEDURE LoescheWort(kante :PTKante);
    PROCEDURE LoescheSpalte(kante:PTKante);
     VAR
      Pgefunden :PTKantenListe;
      Pgesucht  :PTKategorienListe;
     PROCEDURE LoescheGesucht(p:PTKategorienListe);
      BEGIN
       IF p^.weiter <> NIL
        THEN LoescheGesucht(p^.weiter);
       IF P <> NIL THEN DISPOSE(P);
      END;
     PROCEDURE LoescheGefunden(Kante:PTKante;p:PTKantenListe);
      BEGIN
       IF p^.next <> NIL
        THEN LoescheGefunden(Kante,p^.next);
       DISPOSE(P);
      END;
     BEGIN(*LoescheSpalte*)
      IF Kante^.nach <> NIL
       THEN LoescheSpalte(kante^.nach);
      IF (NOT Kante^.nachkomme) AND ((Kante^.gesucht <> NIL)
       AND (NOT Kante^.wort))
       THEN LoescheGesucht(Kante^.gesucht);
      IF Kante^.gefunden <> NIL
       THEN LoescheGefunden(Kante,Kante^.gefunden);
      DISPOSE(Kante)
     END;(*LoescheSpalte*)
    BEGIN(*LoescheWort*)
     IF Kante^.zeigt <> NIL
      THEN LoescheWort(Kante^.zeigt);
    LoescheSpalte(Kante);
    END;(*LoescheWort*)
   BEGIN(*LoescheDieListe*)
    WHILE Wurzel.spalte^.vor <> NIL
     DO Wurzel.spalte := Wurzel.spalte^.vor;
    LoescheWort(Wurzel.spalte);
   END;(*LoescheDieListe*)
(***************************************************************************)
(* HAUPTPROGRAMM DES CHART PARSERS                                         *)
(***************************************************************************)

  BEGIN
   Agenda := NIL;
   PAgenda := Agenda;
   LiesDasLexikon(Lexikon,Grammatik,LexWurzel);
   LiesDenSatz;
   WHILE Wurzel.spalte^.vor <> NIL
    DO Wurzel.spalte := Wurzel.spalte^.vor;
   Regel2EineNeueKanteAnlegen(Wurzel.spalte,VKG,Grammatik);
   SatzAnalyse;
   GibAlleSatzalternativenAus;
   LoescheDieListe;
(***************************************************************************)
(* ENDE DES HAUPTPROGRAMMS DES CHART PARSERS                               *)
(***************************************************************************)

  END.                                                                                
