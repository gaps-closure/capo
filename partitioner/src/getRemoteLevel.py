import argparse
import json
import sys
import ir_reader
def getDesc(fname,taint):
        with open(fname) as f:
            fs = f.read()
            desc1 = json.loads(fs)
        desc = [x for x in desc1
                if 'cle-label' in x and
                'cle-json' in x and
                'level' in x['cle-json']]
        print(desc)

def getRemoteLevel(fname,taint):
        with open(fname) as f:
            fs = f.read()
            desc1 = json.loads(fs)
        for l in desc1:
            if l['cle-label'] == taint:
                for c in l['cle-json']:
                    if ('cdf' in c):
                        for k in l['cle-json']['cdf']:
                            print(k['remotelevel'])

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="get remote level for taint")
    parser.add_argument('cleJsonFile', help="*.cle.json")
    parser.add_argument('taint', help="ORANGE")
    args = parser.parse_args()
    getRemoteLevel(args.cleJsonFile,args.taint)
