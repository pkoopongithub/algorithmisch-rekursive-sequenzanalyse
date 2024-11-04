;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Paul Koop M.A. - Sequence Analysis of Empirically Validated   ;;
;; Sales Conversations                                           ;;
;;                                                               ;;
;; This program simulates sales conversations by modeling a      ;;
;; context-free grammar (CFG) in Lisp. The goal is to analyze    ;;
;; and generate dialog sequences based on a recursively          ;;
;; structured, weighted grammar.                                 ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Grammar Structure for Sales Conversations (VKG)
;; -------------------------------------------
;; Main node: VKG
;; Transitions and weights reflect the probabilities of sales
;; conversation sequences (e.g., Greeting → Need Assessment).
;;
;; VKG -> Greeting (BG) -> Sales Activity (VT) -> Farewell (AV)
;; The possible patterns are modeled and weighted based on empirical data.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Symbol Definitions for Conversation Components                 ;;
;;                                                               ;;
;; Sales Conversation   := VKG                                   ;;
;; Sales Activity       := VT                                    ;;
;; Greeting             := BG                                    ;;
;; Need                 := B                                     ;;
;; Need Analysis        := BA                                    ;;
;; Objection Handling   := AE                                    ;;
;; Closing              := AA                                    ;;
;; Farewell             := AV                                    ;;
;; Customer             := K (prefix for customer statements)    ;;
;; Seller               := V (prefix for seller statements)      ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Main Structure of the Sales Conversation as CFG Rules         ;;
;; VKG starts with a greeting and ends with a farewell           ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq vkg
  '(((bg) 100 (vt))                ;; Greeting → Sales Activity
    ((vt) 50 (vt))                 ;; Repeated Sales Activity
    ((vt) 100 (av))))              ;; Sales Activity → Farewell

;; Greeting Rule - Customer and Seller exchange greetings
(setq bg
  '((kbg 100 vbg)))

;; Need part of the conversation - Customer states need, Seller acknowledges
(setq bbd
  '((kbbd 100 vbbd)))

;; Need Analysis - Both parties discuss the need
(setq ba
  '((kba 100 vba)))

;; Objection Handling in Closing - Customer and Seller address objections
(setq ae
  '((kae 100 vae)))

;; Closing the conversation - Customer and Seller close the deal
(setq aa
  '((kaa 100 vaa)))

;; Final Farewell - Customer and Seller say goodbye
(setq av
  '((kav 100 vav)))

;; Sales Activity, consisting of need and closing phases
(setq vt
  '(((b) 50 (b))                   ;; Need Part
    ((b) 100 (a))))                ;; Need → Closing

;; Structure of the Need Part in the Sales Conversation
(setq b
  '(((bbd) 100 (ba))))             ;; Need Exchange → Need Analysis

;; Closing Structure - consisting of objections and closing
(setq a
  '(((ae) 50 (ae))                 ;; Repeated Objections
    ((ae) 100 (aa))))              ;; Objections → Closing

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Sequence Generation Based on Rules                            ;;
;;                                                               ;;
;; The following function generates dialog sequences according   ;;
;; to the defined rules and weights. It simulates the dialogue   ;;
;; flow according to the CFG.                                    ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Main function to generate the sequence
(defun generate-sequence (state rules)
  "Generates a sequence based on the current state and the rules."
  (cond
    ;; Sequence end reached, return nil
    ((equal state nil) nil)

    ;; If state is terminal, return it directly and move to the next
    ((atom state) (cons state (generate-sequence (next-state state rules (random 101)) rules)))

    ;; Otherwise, expand the non-terminal state and proceed recursively
    (t (cons (eval state) (generate-sequence (next-state state rules (random 101)) rules)))))

;; Function to select the next state
(defun next-state (state rules probability)
  "Selects the next state based on rules and a random probability."
  (cond
    ;; If no more rules, return nil
    ((equal rules nil) nil)

    ;; Checks if the rule matches the probability and returns the successor
    ((and (<= probability (car (cdr (car rules))))
          (equal state (car (car rules))))
     (car (reverse (car rules))))

    ;; Otherwise, continue searching the remaining rules
    (t (next-state state (cdr rules) probability))))

;; Helper function to select the first sequence rule
(defun initial-rule (rules)
  "Selects the first rule from the rule set."
  (car (car rules)))

;; Starts the simulation for the scenario structure
(defun simulate (rules)
  "Starts sequence generation based on the initial rules."
  (generate-sequence (initial-rule rules) rules))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Start Simulation and Generate Sequences                       ;;
;;                                                               ;;
;; (simulate vkg) calls the simulation for the sales conversation;;
;; and returns the generated sequence.                           ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; The simulation is started for World 3 (sales conversation structure)
(simulate vkg)
