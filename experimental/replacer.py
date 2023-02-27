import sys

def replace(fileName, keyword_1: str, replacement_1: str, keyword_2 : str = "", replacement_2 : str = ""):
    fIn = open(fileName, "rt")
    fOut = open(f"{replacement_1}L{replacement_2}_" + fileName, "wt")
    for line in fIn:
        fOut.write(line.replace(keyword_1, replacement_1).replace(keyword_2, replacement_2))
    fIn.close()
    fOut.close()


if __name__ == '__main__':
    if len(sys.argv) < 4 or len(sys.argv) > 6 :
        print(f"Incorrect number of arguments: {sys.argv} needed are fileName, keyword, replacement")
        exit(0)
    elif len(sys.argv) == 6 :
        replace(sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4], sys.argv[5])
    else :
        replace(sys.argv[1], sys.argv[2], sys.argv[3])
