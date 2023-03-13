import sys


def replace(file_name, keyword_1: str, replacement_1: str, keyword_2: str = "", replacement_2: str = ""):
    f_in = open(file_name, "rt")
    new_file_title = f"{replacement_1}_" + file_name
    if replacement_2 != "":
        new_file_title = f"{replacement_1}-{replacement_2}_" + file_name
    f_out = open(new_file_title, "wt")
    for line in f_in:
        f_out.write(line.replace(keyword_1, replacement_1).replace(keyword_2, replacement_2))
    f_in.close()
    f_out.close()


if __name__ == '__main__':
    if len(sys.argv) < 4 or len(sys.argv) > 6:
        print(f"Incorrect number of arguments: {sys.argv} needed are fileName, keyword, replacement")
        exit(0)
    elif len(sys.argv) == 6:
        replace(sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4], sys.argv[5])
    else:
        replace(sys.argv[1], sys.argv[2], sys.argv[3])
