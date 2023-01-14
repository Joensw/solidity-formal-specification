import sys


def replace(fileName, keyword: str, replacement: str):
    fIn = open(fileName, "rt")
    fOut = open(f"<{replacement}>_" + fileName, "wt")
    for line in fIn:
        fOut.write(line.replace(keyword, replacement))
    fIn.close()
    fOut.close()


if __name__ == '__main__':
    if len(sys.argv) != 4:
        print(f"Incorrect number of arguments: {sys.argv} needed are fileName, keyword, replacement")
        exit(0)
    replace(sys.argv[1], sys.argv[2], sys.argv[3])
