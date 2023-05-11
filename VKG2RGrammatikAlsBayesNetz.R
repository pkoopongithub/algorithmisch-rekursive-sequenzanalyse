#Hier wird die VKG Grammatik genutzt, um ein Bayes-Netzwerk 
#aus der probabilistischen kontextfreien Grammatik zu erstellen. 
#Die Grammatik wird in R als eine Sammlung von Listen definiert, 
#wobei jede Liste eine Variable in der Grammatik darstellt. 
#Jede Variable hat eine Liste von möglichen Zuständen und 
#Wahrscheinlichkeiten, sowie eine Liste von Elternknoten und 
#deren Wahrscheinlichkeiten.

#Das Bayes-Netzwerk wird durch Erstellung eines 
#leeren Graphen mit der Funktion empty.graph() erstellt, 
#gefolgt von der Hinzufügung von Kanten mit der Funktion set.arc(). 
#Anschließend wird die Netzwerkstruktur aus der probabilistischen kont





library(bnlearn)

w3 <- list(
  anfang = c(s = "vkg", prob = 100),
  vkg = c(s = "ende", prob = 100)
)

bbd <- list(
  kbbd = c(vbbd = 100)
)

ba <- list(
  kba = c(vba = 100)
)

ae <- list(
  kae = c(vae = 100)
)

aa <- list(
  kaa = c(vaa = 100)
)

b <- list(
  list(s = "ba", prob = 100, parent = list(s = "bbd", prob = 100))
)

a <- list(
  list(s = "aa", prob = 100, parent = list(s = "ae", prob = 100)),
  list(s = "aa", prob = 50, parent = list(s = "ae", prob = 100))
)

vt <- list(
  list(s = "a", prob = 100, parent = list(s = "b", prob = 100)),
  list(s = "a", prob = 50, parent = list(s = "b", prob = 100))
)

bg <- list(
  kbg = c(vbg = 100)
)

av <- list(
  kav = c(vav = 100)
)

vkg <- list(
  list(s = "vt", prob = 100, parent = list(s = "bg", prob = 100)),
  list(s = "av", prob = 100, parent = list(s = "vt", prob = 100)),
  list(s = "vt", prob = 50, parent = list(s = "vt", prob = 100))
)

bn <- empty.graph()
bn <- set.arc(bn, from = "anfang", to = "vkg")
bn <- set.arc(bn, from = "vkg", to = "ende")
bn <- learn.structure(bn, w3)
bn <- learn.structure(bn, bbd)
bn <- learn.structure(bn, ba)
bn <- learn.structure(bn, ae)
bn <- learn.structure(bn, aa)
bn <- learn.structure(bn, b)
bn <- learn.structure(bn, a)
bn <- learn.structure(bn, vt)
bn <- learn.structure(bn, bg)
bn <- learn.structure(bn, av)
bn <- learn.structure(bn, vkg)
bn.fit <- bn.fit(bn, data = matrix(NA, nrow = 1, ncol = 0))
