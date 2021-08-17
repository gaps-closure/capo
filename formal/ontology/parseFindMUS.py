#!/usr/bin/python3

import json
import csv


def main():
    output = []
    csvfile = open('pdg_data.csv')
    pdg_data = csv.reader(csvfile)
    edges = []
    for row in pdg_data:
        if len(row) > 0:
            if row[0] == 'Edge':
                edges.append((row[6],row[7]))
    print(edges)
    with open("findmus.txt","r") as fileMus:
        node2LineNumFile = open("node2lineNumber.txt")
        nodeIdx2LineNum = node2LineNumFile.readlines()
        data = json.loads("".join(fileMus.readlines()[1:-2]))
        # print (data)
        constraints = data["constraints"]
        for constraint in constraints:
            if constraint["constraint_name"] != "":
                # print(constraint["assigns"])
                reason = constraint["constraint_name"]
                id = constraint["assigns"][2:]
                if "e=" in constraint["assigns"]:
                    line1 = nodeIdx2LineNum[int(edges[int(id)-1][0])-1].split(",")
                    line2 = nodeIdx2LineNum[int(edges[int(id)-1][1])-1].split(",")
                    print(f"edge: {id} with nodes: {edges[int(id)-1]} failed: {reason}")
                    print(f"Line 1: {line1} Line 2: {line2}")
                    output.append((line1[-2].strip(),line1[-1].strip(),reason))
                    output.append((line2[-2].strip(),line2[-1].strip(),reason))
                else:
                    print(f"node: {id} failed: {reason}")
                    line = nodeIdx2LineNum[int(id)-1].split(",")
                    output.append((line[-2].strip(),line[-1].strip(),reason))
    
    for error in output:
        print(f"In file {error[0]} on line {error[1]}: {error[2]} conflict found ")
    




  


if __name__ == '__main__':
  main()
