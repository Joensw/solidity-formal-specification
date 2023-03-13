import subprocess
from pathlib import Path
from datetime import datetime


def grab_sol_files_in_cwd():
    cwd = Path.cwd()
    solidity_files = cwd.glob('**/*.sol')
    return [Path(x).name for x in solidity_files if "_" in Path(x).name]


def time():
    sol_file_names = grab_sol_files_in_cwd()
    now = datetime.now()
    dt_string = now.strftime("%d_%m_%Y-%H_%M_%S")
    results_file = open("results_" + dt_string + ".txt", "wt")
    time_file = open("time_" + dt_string + ".txt", "wt")
    for file_name in sol_file_names:
        results_file.write(f"___{file_name}___\n")
        time_file.write(f"___{file_name}___\n")
        cmd = f"(time -p solc-verify.py {file_name})"
        proc = subprocess.run(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True)
        results_file.write(proc.stdout.decode("utf-8"))
        time_file.write(proc.stderr.decode("utf-8"))
        results_file.write("\n")  # formatting for output
        time_file.write("\n")  # formatting for output


if __name__ == '__main__':
    time()
