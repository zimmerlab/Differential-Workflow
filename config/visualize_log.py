#!/usr/bin/python3
##https://stackoverflow.com/questions/43531543/get-memory-usage-per-process-with-sar-sysstat/59182595#59182595
import pandas as pd
import matplotlib.pyplot as plt
import sys


def read_columns(filename):
    with open(filename) as f:
        for l in f:
            if l[0] != '#':
                continue
            else:
                return l.strip('#').split()
        else:
            raise LookupError

def get_lines(filename, colnum):
    with open(filename) as f:
        for l in f:
            if l[0] == '1':
                yield l.split(maxsplit=colnum - 1)        

filename = sys.argv[1]
columns = read_columns(filename)

print(columns)

exclude = 'CPU', 'UID', '%wait'
df = pd.DataFrame.from_records(
    get_lines(filename, len(columns)), columns=columns, exclude=exclude
)
df.info()

numcols = df.columns.drop('Command')
df[numcols] = df[numcols].apply(pd.to_numeric, errors='coerce')
df['RSS'] = df.RSS / 1024  # Make MiB
df['Time'] = pd.to_datetime(df['Time'], unit='s', utc=True)

df = df.set_index('Time')
df.info()

print("starting init subplots")
print(len(df.PID.unique()))
fig, axes = plt.subplots(len(df.PID.unique()), 2, figsize=(12, 8))
x_range = [df.index.min(), df.index.max()]
for i, pid in enumerate(df.PID.unique()):
    subdf = df[df.PID == pid]
    title = ', '.join([f'PID {pid}', str(subdf.index.max() - subdf.index.min())])
    for j, col in enumerate(('%CPU', 'RSS')):
        ax = subdf.plot(
            y=col, title=title if j == 0 else None, ax=axes[i][j], sharex=True
       )
        ax.legend(loc='upper right')
        ax.set_xlim(x_range)

plt.tight_layout()

out = sys.argv[2] or "plot.pdf"
plt.savefig(out)
