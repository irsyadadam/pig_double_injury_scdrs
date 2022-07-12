# Double Injury scDRS Pipeline

Multiomics integration pipeline for relating transcriptomics genomics. The goal is the integrate genomics into the double injury model.

**Project Goals**
TODO

**MAGMA Remarks:**
- Files: https://ctg.cncr.nl/software/magma
- MAGMA_v1.10_mac (g++) is used for data analysis, change magma version accordingly
- "European Gene Locations Build 38", "NCBI38" are used for gene location

**scDRS Remarks:**
- https://martinjzhang.github.io/scDRS/index.html#installation

## Setup
**MAGMA Setup**
1) Download MAGMA_mac > v1.10 (https://ctg.cncr.nl/software/magma) and place the folder in this directory.
    - NOTE: MacOS may restrict the running of MAGMA, so ensure that you enable permissions in system preferences accordingly
2) Download Gene Location Build 38 Auxilary File (https://ctg.cncr.nl/software/magma) and move it into the MAGMA folder
3) Download all European reference data (https://ctg.cncr.nl/software/magma) and move all <code>g1000_eur.(bed|bim|fam)</code> files into the MAGMA folder

**GWAS Summary Statistics Setup**
1) Make sure that the gwas summary statistics have the following columns before downloading:
```
CHR     BP      SNP             P           N
1       717587  rs144155419     0.453345    279949
1       740284  rs61770167      0.921906    282079
1       769223  rs60320384      0.059349    281744
```
2) Put the downloaded summary statistics into the <code> gwas_data</code> folder.
3) If the gwas summary statistics are in a .gz file, unzip it.

**scDRS Setup**
1) Go into the root folder (<code>/double_injury_scdrs</code>) and type the following in the command line (preferably one by one):
```
conda create -n [ENV_NAME]
conda activate [ENV_NAME]
git clone https://github.com/martinjzhang/scDRS.git
cd scDRS
git checkout -b rv1 v1.0.0
pip install -e .
```
2) There should be a <code>/scDRS</code> folder present in the folder. Type the following in the command line to check if scDRS is properly installed.
```
python -m pytest tests/test_CLI.py -p no:warnings
```
3) If all 3 tests pass, then scDRS is properly installed. If not, then idk LMAO

## Folder Hierarchy
The folder <code>/double_injury_scdrs</code> should look like the following:
```
/double_injury_scdrs
|
|- /gwas_data
|       |- all existing summary statistics data
|
|- /magma_v1.10
|       |- magma
|       |- g1000_eur(.bed|.bim|.fam|.synonyms)
|       |- NCBI38.gene.loc
|
|- /scDRS
|- magma_setup.sh
|- README.md
|- misc files
```

## Step 1: Running GWAS Catalog Wrapper

1) Create a new folder inside <code> /gwas-catalog-wrapper</code> and shove the query of summary statistics into it. 

2) run the GWAS Catalog wrapper using <code>python3 main.py --folder [FOLDER]</code>

## Step 2: Running MAGMA-scDRS Pipeline

1) Choose GWAS studies such that their summary statistics data contain the following columns:
```
CHR     BP      SNP             P           N
1       717587  rs144155419     0.453345    279949
1       740284  rs61770167      0.921906    282079
1       769223  rs60320384      0.059349    281744
```
2) Put the downloaded summary statistics into the <code> gwas_data</code> folder.
    - If the gwas summary statistics are in a .gz file, unzip it.
2) Go to the <code> /double_injury_scdrs/</code> folder (root folder) and enter the following command in the terminal for MAGMA setup, replacing <code> [summary statistics filename] </code> with the corresponding summary statistics
```
bash run_scdrs.sh gwas_data/[summary_statistics_filename]
```
4) The output of this command should be a folder named <code>/magma_out</code> with the following data:
```
/magma_out
|
|- /step1
|       |- empty
|
|- /step2
|       |- [gwas].genes.out
|       |- other files
|
|- step1.log
|- step1.genes.annot
```
