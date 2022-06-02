from turtle import speed
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import warnings
from sklearn.cluster import KMeans

vue_sql = pd.read_csv("/FILER/HOME/INFO/amichelo/Math/python/pokemon.csv")

avg_ages = np.average(vue_sql ['ages'])
avg_serie_bac = np.average(vue_sql ['serie_bac'])
avg_mention_bac = np.average(vue_sql ['mention_bac'])
avg_moyenne_generale = np.average(vue_sql ['moyenne_generale'])

std_ages = np.std(vue_sql ['ages'])
std_serie_bac = np.std(vue_sql ['serie_bac'])
std_mention_bac = np.std(vue_sql ['mention_bac'])
std_moyenne_generale = np.std(vue_sql ['moyenne_generale'])


def Centreduire(T):

    data = {'ages': list(), 
        'serie_bac': list(),
        'mention_bac': list(), 
        'moyenne_generale': list()}

    for e in T ['Total']:
        e = (e-avg_atk)/std_atk
        data['Total'].append(e)  
        
    for e in T ['Attack']:
        e = (e-avg_atk)/std_atk
        data['Attack'].append(e)

    for e in T ['Defense']:
        e = (e-avg_def)/std_def
        data['Defense'].append(e)

    for e in T ['Special Attack']:
        e = (e-avg_atk_spe)/std_atk_spe
        data['Special Attack'].append(e)

    for e in T ['Special Defense']:
        e = (e-avg_def_spe)/std_def_spe
        data['Special Defense'].append(e)

    for e in T ['Speed']:
        e = (e-avg_speed)/std_speed
        data['Speed'].append(e)

    for e in T ['HP']:
        e = (e-avg_hp)/std_hp
        data['HP'].append(e)

    df1 = pd.DataFrame(data)

    Res = df1

    return Res