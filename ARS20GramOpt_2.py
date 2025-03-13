import numpy as np
import random
from collections import defaultdict
from scipy.stats import pearsonr
from math import sqrt

# Beispielhafte empirische Daten
terminal_strings = [
    "KBG VBG KBBd VBBd KBA VBA KBBd VBBd KBA VAA KAA VAV KAV",
    "VBG KBBd VBBd VAA KAA VBG KBBd VAA KAA",
    "KBBd VBBd VAA KAA",
    "KBBd VBBd KBA VBA KBBd VBA KAE VAE KAA VAV KAV",
    "KAV KBBd VBBd KBBd VAA KAV",
    "KBG VBG KBBd VBBd KAA",
    "KBBd VBBd KBA VAA KAA",
    "KBG VBBd KBBd VBA VAA KAA VAV KAV"
]

# Zähle Häufigkeiten der Terminalzeichen
def count_terminal_frequencies(strings):
    terminal_frequencies = defaultdict(int)
    total_count = 0
    
    for line in strings:
        terms = line.split()
        for term in terms:
            terminal_frequencies[term] += 1
            total_count += 1
    
    # Normalisieren (relative Häufigkeit)
    for term in terminal_frequencies:
        terminal_frequencies[term] /= total_count
    
    return terminal_frequencies

# Zähle Übergänge und berechne Übergangswahrscheinlichkeiten
def count_transitions(strings):
    transition_counts = defaultdict(lambda: defaultdict(int))

    for line in strings:
        terms = line.split()
        for i in range(len(terms) - 1):
            from_term = terms[i]
            to_term = terms[i + 1]
            transition_counts[from_term][to_term] += 1
    
    # Normalisiere die Übergänge zu Wahrscheinlichkeiten
    normalized_matrix = {}
    for from_term, transitions in transition_counts.items():
        total = sum(transitions.values())
        normalized_matrix[from_term] = {to_term: count / total for to_term, count in transitions.items()}
    
    return normalized_matrix

# Erzeuge eine Terminalzeichenkette basierend auf den Übergangswahrscheinlichkeiten
def generate_from_cfg(grammar, start_symbol='KBG', max_depth=10):
    current_symbol = start_symbol
    generated_chain = []
    
    for _ in range(max_depth):
        if current_symbol not in grammar:
            break
        rules = grammar[current_symbol]
        rule = random.choices(rules, weights=[float(r.split('P=')[-1][:-1]) for r in rules])[0]
        rhs = rule.split('->')[-1].strip()
        generated_chain.append(rhs)
        current_symbol = rhs.split()[-1]  # Wähle das letzte Symbol der rechten Seite der Regel
    
    return " ".join(generated_chain)

# Berechne die Korrelation zwischen den empirischen Häufigkeiten und den generierten Häufigkeiten
def calculate_correlation(empirical_freqs, generated_freqs):
    common_terms = set(empirical_freqs.keys()).intersection(generated_freqs.keys())
    
    empirical_values = [empirical_freqs[term] for term in common_terms]
    generated_values = [generated_freqs[term] for term in common_terms]
    
    if len(empirical_values) > 1:
        corr, p_value = pearsonr(empirical_values, generated_values)
        return corr, p_value
    return 0, 1  # Rückgabe der Korrelation und des p-Werts (1 für keine Korrelation)

# Berechne den Standardfehler der Korrelation
def standard_error(correlation, n):
    return sqrt((1 - correlation**2) / (n - 2))

# Optimierung der Übergangswahrscheinlichkeiten
def optimize_grammar(terminal_strings, num_iterations=100, max_depth=10, tolerance=0.95):
    # Initialisiere die Häufigkeiten und Übergangswahrscheinlichkeiten
    empirical_freqs = count_terminal_frequencies(terminal_strings)
    transition_counts = count_transitions(terminal_strings)
    
    # Erstelle die Grammatik aus den Übergangszählungen
    grammar = {}
    for from_term, transitions in transition_counts.items():
        rules = [f"{from_term} -> {to_term} [P={prob:.4f}]" for to_term, prob in transitions.items()]
        grammar[from_term] = rules

    # Iterative Optimierung
    correlations = []
    p_values = []
    for iteration in range(num_iterations):
        # Generiere eine Kette basierend auf der aktuellen Grammatik
        generated_chain = generate_from_cfg(grammar, start_symbol="KBG", max_depth=max_depth)
        generated_freqs = count_terminal_frequencies(generated_chain.split())
        
        # Berechne die Korrelation zwischen den Häufigkeiten
        correlation, p_value = calculate_correlation(empirical_freqs, generated_freqs)
        correlations.append(correlation)
        p_values.append(p_value)
        
        # Berechne den Standardfehler der Korrelation
        se = standard_error(correlation, len(empirical_freqs))
        
        # Wenn die Korrelation die Toleranz erreicht und der p-Wert signifikant ist, abbrechen
        if correlation > tolerance and p_value < 0.05:
            break
        
        # Optimiere die Übergangswahrscheinlichkeiten basierend auf der Korrelation
        for from_term, transitions in transition_counts.items():
            total_transitions = sum(transitions.values())
            for to_term in transitions:
                # Ändere die Übergangswahrscheinlichkeit basierend auf der Korrelation
                transition_counts[from_term][to_term] *= 1 + 0.1 * (correlation - 0.5)  # stärkere Anpassung

        # Normalisiere die Übergangswahrscheinlichkeiten nach jeder Iteration
        transition_counts = count_transitions(terminal_strings)  # Normalisieren

    # Berechne die finale Korrelation und den p-Wert
    final_corr, final_p_value = calculate_correlation(empirical_freqs, generated_freqs)

    return grammar, final_corr, final_p_value

# Optimierung durchführen
grammar, correlation, p_value = optimize_grammar(terminal_strings)

# Ausgabe der optimierten Grammatik, Korrelation und p-Wert
print("Optimierte Grammatik:")
for non_terminal, rules in grammar.items():
    print(f"{non_terminal}:")
    for rule in rules:
        print(f"  {rule}")

print("\nKorrelationskoeffizient:", correlation)
print("p-Wert:", p_value)

Optimierte Grammatik:
#KBG:
#  KBG -> VBG [P=0.6667]
#  KBG -> VBBd [P=0.3333]
#VBG:
#  VBG -> KBBd [P=1.0000]
#KBBd:
#  KBBd -> VBBd [P=0.6667]
#  KBBd -> VAA [P=0.1667]
#  KBBd -> VBA [P=0.1667]
#VBBd:
#  VBBd -> KBA [P=0.4444]
#  VBBd -> VAA [P=0.2222]
#  VBBd -> KBBd [P=0.2222]
#  VBBd -> KAA [P=0.1111]
#KBA:
#  KBA -> VBA [P=0.5000]
#  KBA -> VAA [P=0.5000]
#VBA:
#  VBA -> KBBd [P=0.5000]
#  VBA -> KAE [P=0.2500]
#  VBA -> VAA [P=0.2500]
#VAA:
#  VAA -> KAA [P=0.8571]
#  VAA -> KAV [P=0.1429]
#KAA:
#  KAA -> VAV [P=0.7500]
#  KAA -> VBG [P=0.2500]
#VAV:
#  VAV -> KAV [P=1.0000]
#KAE:
#  KAE -> VAE [P=1.0000]
#VAE:
#  VAE -> KAA [P=1.0000]
#KAV:
#  KAV -> KBBd [P=1.0000]
#
#Korrelationskoeffizient: 0
#p-Wert: 1
