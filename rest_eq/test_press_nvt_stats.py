#
## Python script to analyze equilibration steps for REST MD simulation input
## Written by Korey Reid
## Depends on pandas, numpy and matplotlib for creating data files and figures
import numpy as np
import pandas as pd
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import sys
import scipy.ndimage as ndi

def load_xvg(base_file, cnames, dstart, dend, dstep, skip_rows):
    xvg_data = []
    for i in range(dstart, dend+1, dstep):
        xvg_data.append(pd.read_csv(str(i)+'/'+base_file,names=cnames,sep='\s+',skiprows=skip_rows))
    return xvg_data

def plot_em(xlabel, ylabel, x_values, y_values, data_label, fig_name):
    plt.xlabel(xlabel)
    plt.ylabel(ylabel)
    for a,b,c in zip(x_values,y_values,data_label):
        plt.plot(a, b, label=data_label)
    plt.legend()
    plt.tight_layout()
    plt.savefig('./Pressure_analysis_test_press/'+fig_name+'.tiff', dpi=300)
    plt.clf()

def plot_data(xlabel, ylabel, x_values, y_values, data_label, fig_name, running_mean=False, window_length=10):
    plt.xlabel(xlabel)
    plt.ylabel(ylabel)
    for data in y_values:
        if running_mean==True:
            data = ndi.uniform_filter1d(data, window_length, mode='nearest')
        plt.plot(x_values, data, label=data_label)
    plt.legend()
    plt.tight_layout()
    plt.savefig('./Pressure_analysis_test_press/'+fig_name+'.tiff', dpi=300)
    plt.clf()

def clean_args(args):
    arg_out = []
    for i in range(len(args)):
        if i > 0:
            arg_out.append(int(args[i]))
        else:
            arg_out.append(args[i])
    return arg_out

args = clean_args(sys.argv[1:])

print(args)
if len(args) != 4:
    raise RuntimeError('Requires 4 arguments\n {flag} {first sim} {last sim} {increment}')

if '-eqnpt' in args:
    column_name1 = ['time','PE','KE','TE','Temp','Press']#,r'$T_{Prot}$',r'$T_{NonProt}$']
    column_name2 = ['time',r'$L_{box}$','V','Density','pV','H']
    data1 = load_xvg('test_press.energy1.xvg', column_name1, args[1], args[2], args[3], 30)
    data2 = load_xvg('test_press.energy2.xvg', column_name2, args[1], args[2], args[3], 28)
    x_values = data1[0]['time'].values
    for i in column_name1[1:]:
        data_num = [k for k in range(args[1], args[2]+1, args[3])]
        y_values = []
        for df,j in zip(data1,data_num):
            y_values.append(df[i].values)
        if i in ['Press',r'L_{box}$']:
            plot_data(column_name1[0], i, x_values, y_values, str(j), 'eqnpt_'+i, running_mean=True, window_length=10)
        else:
            plot_data(column_name1[0], i, x_values, y_values, str(j), 'eqnpt_'+i)

    for i in column_name2[1:]:
        data_num = [k for k in range(args[1], args[2]+1, args[3])]
        y_values = []
        for df,j in zip(data2,data_num):
            y_values.append(df[i].values)
        if i in ['Press',r'L_{box}$']:
            plot_data(column_name1[0], i, x_values, y_values, str(j), 'eqnpt_'+i, running_mean=True, window_length=10)
        else:
            plot_data(column_name1[0], i, x_values, y_values, str(j), 'eqnpt_'+i)

        if i == r'$L_{box}$':
            data_L = np.ones((len(data_num)+1, len(x_values)))
            data_L[0] = x_values
            for data,pos in zip(y_values,data_num):
                data_L[pos] = data
            np.save('./Pressure_analysis_test_press/eqnpt.Lbox.npy', data_L)

                                                                                                                                                                                                 88,0-1        Bot

