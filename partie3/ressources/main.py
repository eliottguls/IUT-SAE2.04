from xml.etree.ElementInclude import XINCLUDE
import matplotlib.pyplot as plt
from sklearn.cluster import KMeans
import pandas as pd
import warnings 
import numpy as np

    

warnings.filterwarnings("ignore", category=DeprecationWarning)

def Centreduire(T):
    Tmoy = np.mean(T, axis=0)
    TEcart = np.std(T, axis=0)
    (n,p) =  T.shape
    res = np.zeros((n,p))

    for j in range(p):
        res[:,j] = (T[:,j]-Tmoy[j])/TEcart[j]
    return res



pokemons = pd.read_csv("pokemon.csv")


df = pd.DataFrame(pokemons)
PokArray = np.array(pokemons._get_numeric_data())
PokArrayCR = Centreduire(PokArray)
print(PokArrayCR)
X = pokemons['Defense'].to_numpy()
print("X :", X)
Y = pokemons['Speed'].to_numpy()
print("Y :", Y)




Res = KMeans(n_clusters=8).fit(PokArrayCR[:,(2,4)]) # 2 et 4 en partant de la fin
Res1=KMeans(n_clusters=4).fit(PokArrayCR[:,(3,0)])

print("Labels Res1: ",Res1.labels_)
print("Clusters Res1: ",Res1.cluster_centers_) # Et cette commande permet de connaitre la moyenne des points d’Attack et de Special Attack de chaque cluster


def CoordCluster(X, Y, Res, i):
    tab = []
    for j in Res.labels_:
        if j==i:
            tab.append(X[j])
            tab.append(Y[j])

    return tab

print("CoordCluster 2 : ", CoordCluster(X, Y, Res, 2))

rouge = CoordCluster(X, Y, Res, 0)
bleu = CoordCluster(X, Y, Res, 1)
violet = CoordCluster(X, Y, Res, 2)
vert = CoordCluster(X, Y, Res, 3)

cc = Res1.cluster_centers_
tab1X = []
tab1Y = []
tab2X = []
tab2Y = []
tab3X = []
tab3Y = []
tab4X = []
tab4Y = []



print(tab1X)
tab1Y.append(cc[0][1])
tab2X.append(cc[1][0])
tab2Y.append(cc[1][1])
tab3X.append(cc[2][0])
tab3Y.append(cc[2][1])
tab4X.append(cc[3][0])
tab4Y.append(cc[3][1])


plt.scatter(tab1X, tab1Y, c='red')
plt.scatter(tab2X, tab2Y, c='blue')
plt.scatter(tab3X, tab3Y, c='purple')
plt.scatter(tab4X, tab4Y, c='green')
plt.xlabel("Défense")
plt.ylabel("Speed")
'''plt.savefig("Q2.png", format="png")
'''
plt.show()