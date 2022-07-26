#!/bin/python3

import sys

if __name__ == "__main__":
    classId = sys.argv[1]

    classes = open("dbg_classinfo.csv","r").read().split("\n")

    className = classes[int(classId)-1].split(",")[0].strip()


    print(f"Class Name: {className}")



