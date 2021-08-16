#!/usr/bin/python3
import csv
import pandas as pd
INFILE='testdata/example2-20210816-handcrafted/pdg_data.csv'

fn=['NodeOrEdge','Index','Type','PDGID','LLVM', 'Function', 'From', 'To', 'File', 'Line', 'Param']
df = pd.read_csv (INFILE, delimiter=',', skipinitialspace=True, quoting=csv.QUOTE_MINIMAL, names=fn)
dat = df.to_dict()

edges = [k for k in dat['NodeOrEdge'] if dat['NodeOrEdge'][k]=='Edge']
nodes = [k for k in dat['NodeOrEdge'] if dat['NodeOrEdge'][k]=='Node']
idx2row = {dat['Index'][k] : k for k in nodes}

for k in edges:
  si = int(dat['From'][k])
  sr = idx2row[si]
  di = int(dat['To'][k])
  dr = idx2row[di]
  print(str(dat['Index'][k]) + '[' + str(dat['Type'][k])  + ']' + ' : '  +
        str(si) + '(' + str(dat['Function'][sr]) + ')' + '[' + str(dat['Type'][sr]) + ']' + ' -> ' +
        str(di) + '(' + str(dat['Function'][dr]) + ')' + '[' + str(dat['Type'][dr]) + ']')


