import numpy as np
from scipy.stats import pearsonr

# Neue empirische Terminalzeichenketten
empirical_chains = [
    ['KBG', 'VBG', 'KBBd', 'VBBd', 'KBA', 'VBA', 'KBBd', 'VBBd', 'KBA', 'VAA', 'KAA', 'VAV', 'KAV'],
    ['VBG', 'KBBd', 'VBBd', 'VAA', 'KAA', 'VBG', 'KBBd', 'VAA', 'KAA'],
    ['KBBd', 'VBBd', 'VAA', 'KAA'],
    ['KBBd', 'VBBd', 'KBA', 'VBA', 'KBBd', 'VBA', 'KAE', 'VAE', 'KAA', 'VAV', 'KAV'],
    ['KAV', 'KBBd', 'VBBd', 'KBBd', 'VAA', 'KAV'],
    ['KBG', 'VBG', 'KBBd', 'VBBd', 'KAA'],
    ['KBBd', 'VBBd', 'KBA', 'VAA', 'KAA'],
    ['KBG', 'VBBd', 'KBBd', 'VBA', 'VAA', 'KAA', 'VAV', 'KAV']
]

# Übergangszählung initialisieren
transitions = {}
for chain in empirical_chains:
    for i in range(len(chain) - 1):
        start, end = chain[i], chain[i + 1]
        if start not in transitions:
            transitions[start] = {}
        if end not in transitions[start]:
            transitions[start][end] = 0
        transitions[start][end] += 1

# Normalisierung: Übergangswahrscheinlichkeiten berechnen
probabilities = {}
for start in transitions:
    total = sum(transitions[start].values())
    probabilities[start] = {end: count / total for end, count in transitions[start].items()}

# Terminalzeichen und Startzeichen definieren
terminal_symbols = list(set([item for sublist in empirical_chains for item in sublist]))
start_symbol = empirical_chains[0][0]

# Funktion zur Generierung von Ketten basierend auf der Grammatik
def generate_chain(max_length=10):
    chain = [start_symbol]
    while len(chain) < max_length:
        current = chain[-1]
        if current not in probabilities:
            break
        next_symbol = np.random.choice(list(probabilities[current].keys()), p=list(probabilities[current].values()))
        chain.append(next_symbol)
        if next_symbol not in probabilities:
            break
    return chain

# Funktion zur Berechnung relativer Häufigkeiten
def compute_frequencies(chains, terminals):
    frequency_array = np.zeros(len(terminals))
    terminal_index = {term: i for i, term in enumerate(terminals)}
    
    for chain in chains:
        for symbol in chain:
            if symbol in terminal_index:
                frequency_array[terminal_index[symbol]] += 1

    total = frequency_array.sum()
    if total > 0:
        frequency_array /= total  # Normierung der Häufigkeiten
    
    return frequency_array

# Iterative Optimierung
max_iterations = 1000
tolerance = 0.01  # Toleranz für Standardmessfehler
best_correlation = 0
best_significance = 1

# Relativ Häufigkeiten der empirischen Ketten berechnen
empirical_frequencies = compute_frequencies(empirical_chains, terminal_symbols)

for iteration in range(max_iterations):
    # Generiere 8 künstliche Ketten
    generated_chains = [generate_chain() for _ in range(8)]
    
    # Relativ Häufigkeiten der generierten Ketten berechnen
    generated_frequencies = compute_frequencies(generated_chains, terminal_symbols)
    
    # Berechne die Korrelation
    correlation, p_value = pearsonr(empirical_frequencies, generated_frequencies)
    
    print(f"Iteration {iteration + 1}, Korrelation: {correlation:.3f}, Signifikanz: {p_value:.3f}")
    
    # Überprüfen, ob Korrelation und Signifikanz akzeptabel sind
    if correlation >= 0.9 and p_value < 0.05:
        best_correlation = correlation
        best_significance = p_value
        break
    
    # Anpassung der Wahrscheinlichkeiten basierend auf Standardmessfehler
    for start in probabilities:
        for end in probabilities[start]:
            # Fehlerabschätzung basierend auf Differenz der Häufigkeiten
            empirical_prob = empirical_frequencies[terminal_symbols.index(end)]
            generated_prob = generated_frequencies[terminal_symbols.index(end)]
            error = empirical_prob - generated_prob
            
            # Anpassung der Wahrscheinlichkeit
            probabilities[start][end] += error * tolerance
            probabilities[start][end] = max(0, min(1, probabilities[start][end]))  # Begrenzen auf [0,1]
    
    # Normalisierung
    for start in probabilities:
        total = sum(probabilities[start].values())
        if total > 0:
            probabilities[start] = {end: prob / total for end, prob in probabilities[start].items()}

# Ergebnis ausgeben
print("\nOptimierte probabilistische Grammatik:")
for start, transitions in probabilities.items():
    print(f"{start} → {transitions}")

print(f"\nBeste Korrelation: {best_correlation:.3f}, Signifikanz: {best_significance:.3f}")
#Iteration 1, Korrelation: 0.925, Signifikanz: 0.000
#
#Optimierte probabilistische Grammatik:
#KBG → {'VBG': 0.6666666666666666, 'VBBd': 0.3333333333333333}
#VBG → {'KBBd': 1.0}
#KBBd → {'VBBd': 0.6666666666666666, 'VAA': 0.16666666666666666, 'VBA': 0.16666666666666666}
#VBBd → {'KBA': 0.4444444444444444, 'VAA': 0.2222222222222222, 'KBBd': 0.2222222222222222, 'KAA': 0.1111111111111111}
#KBA → {'VBA': 0.5, 'VAA': 0.5}
#VBA → {'KBBd': 0.5, 'KAE': 0.25, 'VAA': 0.25}
#VAA → {'KAA': 0.8571428571428571, 'KAV': 0.14285714285714285}
#KAA → {'VAV': 0.75, 'VBG': 0.25}
#VAV → {'KAV': 1.0}
#KAE → {'VAE': 1.0}
#VAE → {'KAA': 1.0}
#KAV → {'KBBd': 1.0}
#
#Beste Korrelation: 0.925, Signifikanz: 0.000