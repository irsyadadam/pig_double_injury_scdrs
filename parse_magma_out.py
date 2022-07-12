import pandas as pd
import mygene

import os
import argparse


if __name__ == '__main__':

    parser = argparse.ArgumentParser(description="parse the *.genes.out file from entrez ids to gene names")
    parser.add_argument("--filename", type=str, help="file name of the .genes.out file", default="")
    args = parser.parse_args()

    df = pd.read_csv(args.filename, header=[0], delimiter="\t")
    data = pd.DataFrame()

    gene_id = []
    p = []

    for i in range(len(df)):
        row = list(filter(None, df[df.columns[0]][i].split(" ")))
        gene_id.append(row[0])
        p.append(row[-1])

    data["GENE"] = gene_id
    data[args.filename.split(".")[0].split("/")[-1]] = p

    mg = mygene.MyGeneInfo()
    data["GENE"] = mg.getgenes(data["GENE"], fields='symbol', as_dataframe=True)["symbol"].tolist()
    data = data.dropna(axis=0)
    data.to_csv(args.filename + ".csv", index=False, sep= "\t")