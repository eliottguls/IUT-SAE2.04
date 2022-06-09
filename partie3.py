import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import warnings
from sklearn.cluster import KMeans

vue_sql = pd.read_csv("/FILER/HOME/INFO/amichelo/SAE2.04/partie3/vue.csv")

df = pd.DataFrame(vue_sql._get_numeric_data())

my_array = df.to_numpy()

vue_sql._get_numeric_data()

vueArray = df

avg_age = np.average(vue_sql ['age'])
avg_moyenne_generale = np.average(vue_sql ['moy_g'])
avg_dept = np.average(vue_sql ['dept_etablisseme'])
avg_position_a = np.average(vue_sql ['position_a'])

std_age = np.std(vue_sql ['age'])
std_moyenne_generale = np.std(vue_sql ['moy_g'])
std_dept = np.std(vue_sql ['dept_etablisseme'])
std_position_a = np.std(vue_sql ['position_a'])



def Centreduire(T):

    data = {'age': list(), 
        'moy_g': list(),
        'dept_etablisseme': list(), 
        'position_a': list()}

    for e in T ['age']:
        e = (e-avg_age)/std_age
        data['age'].append(e)  
        
    for e in T ['moy_g']:
        e = (e-avg_moyenne_generale)/std_moyenne_generale
        data['moy_g'].append(e)

    for e in T ['dept_etablisseme']:
        e = (e-avg_dept)/std_dept
        data['dept_etablisseme'].append(e) 

    for e in T ['position_a']:
        e = (e-avg_position_a)/std_position_a
        data['position_a'].append(e)

    df1 = pd.DataFrame(data)

    Res = df1

    return Res

vueArray_CR = Centreduire(vueArray)

print("centre-reduit", vueArray_CR)

W = vue_sql ['age']
X = vue_sql ['moy_g']
Y = vue_sql ['dept_etablisseme']
Z = vue_sql ['position_a']

age_array = W.to_numpy()
age_array = X.to_numpy()
age_array = Y.to_numpy()
age_array = Z.to_numpy()

"""

plt.scatter(W, X, Y, Z)
plt.title('age, moy_g, dept_etablissement, position_a')
plt.show()

"""

warnings.filterwarnings("ignore", category=DeprecationWarning)

vueArray_tab = vueArray.to_numpy()
vueArray_CR2 = vueArray_CR.to_numpy()

print(vueArray_CR2)

Res1 = KMeans(n_clusters=4).fit(vueArray_CR2[:,(1,2)])

def CoordClusters(W, X, Y, Z, Res, i):
    Wi = []
    Xi = []
    Yi = []
    Zi = []

    index = 0
    for x in Res.labels_:
        print(index)

        if (x == i):
            Wi.append(X[index])
            Xi.append(X[index])
            Yi.append(Y[index])
            Zi.append(Y[index])

        index = index + 1

    return Wi, Xi, Yi, Zi

rouge = (CoordClusters(W, X, Y, Z, Res1, 0))
bleu = (CoordClusters(W, X, Y, Z, Res1, 1))
vert = (CoordClusters(W, X, Y, Z, Res1, 2))
orange = (CoordClusters(W, X, Y, Z, Res1, 3))

plt.scatter(rouge[0], rouge[1], c='red')
plt.scatter(bleu[0], bleu[1], c='blue')
plt.scatter(vert[0], vert[1], c='green')
plt.scatter(orange[0], orange[1], c='orange')

plt.title('age, moy_g, dept_etablissement, position_a')
plt.show()

