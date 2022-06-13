import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import warnings
from sklearn import cluster
from sklearn.cluster import KMeans
warnings.filterwarnings("ignore", category=DeprecationWarning)

vue_sql = pd.read_csv("vue.csv")

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
# print("centre-reduit \n", vueArray_CR)


W = vue_sql ['age']
X = vue_sql ['moy_g']
Y = vue_sql ['dept_etablisseme']
Z = vue_sql ['position_a']

age_array = W.to_numpy()
moy_g_array = X.to_numpy()
dept_tablissement_array = Y.to_numpy()
postition_a_array = Z.to_numpy()

"""

plt.scatter(W, X, Y, Z)
plt.title('age, moy_g, dept_etablissement, position_a')
plt.show()

"""


vueArray_tab = vueArray.to_numpy()
vueArray_CR2 = vueArray_CR.to_numpy()


Res1 = KMeans(n_clusters=4).fit(vueArray_CR2[:,(1,2)])

def CoordClusters(X, Y, Res, i):
    tab = []
    for j in Res.labels_:
        if j==i:
            tab.append(X[j])
            tab.append(Y[j])
    return tab




def affiche(list):
    dict = { "age" : "",
             "moyenne générale" : "",
             "département établissement" : "",
             "position_a" : ""}
    for i in range (0, len(list)):
        dict['age'] = []
        dict['age'].append(list[i][0])
    print(dict)

def Renvoie_Cluster(DF, Res, i):
    """
    It takes a dataframe, a clustering result and a cluster number as parameters, and returns the dataframe with the
    cluster number added as a column, and then returns the values of the column we want to look at for
    that cluster
    
    :param DF: The dataframe that you want to cluster
    :param Res: the result of the clustering
    :param i: the cluster number you want to look at
    """
    cluster_map  = DF
    cluster_map['cluster'] = Res.labels_
    restmp = []
    lst_moy_g = []
    lst_dept = []

    for j in range(0, len(cluster_map)):
        if cluster_map['cluster'][j] == i:
            restmp.append(DF.iloc[j])

    for z in range(len(restmp)):
        lst_moy_g.append((restmp[z][3], restmp[z][1]))
        lst_dept.append((restmp[z][3],restmp[z][2]))

    print("liste de couple (position a dans leur nom, département établissement :",lst_dept)

    return restmp



rouge = (CoordClusters(X, Y, Res1, 0))
bleu = (CoordClusters(X, Y, Res1, 1))
vert = (CoordClusters(X, Y, Res1, 2))
orange = (CoordClusters(X, Y, Res1, 3))


'''plt.scatter(rouge[0], rouge[1], c='red')
plt.scatter(bleu[0], bleu[1], c='blue')
plt.scatter(vert[0], vert[1], c='green')
plt.scatter(orange[0], orange[1], c='orange')'''

cc = Res1.cluster_centers_
test = Res1.labels_
Renvoie_Cluster(vue_sql, Res1, 1)
'''plt.scatter(cc[0][0], cc[0][1], c='red', marker='s')
plt.scatter(cc[1][0], cc[1][1], c='blue', marker='s')
plt.scatter(cc[2][0], cc[2][1], c='green', marker='s')
plt.scatter(cc[3][0], cc[3][1], c='orange', marker='s')'''

'''plt.title('age, moy_g, dept_etablissement, position_a')
plt.show()
'''


