magma_dir=magma_v1.10_mac

mkdir -p magma_out/step1
${magma_dir}/magma --annotate window=10,10 \
    --snp-loc ${magma_dir}/g1000_eur.bim \
    --gene-loc ${magma_dir}/NCBI38.gene.loc \
    --out magma_out/step1/step1

gene_set_summary_statistics=$1
filename_arr=(${gene_set_summary_statistics//// })

mkdir -p magma_out/step2
${magma_dir}/magma \
    --bfile ${magma_dir}/g1000_eur \
    --pval ${gene_set_summary_statistics} use='MarkerName,p' ncol='N' \
    --gene-annot magma_out/step1/step1.genes.annot \
    --out magma_out/step2/${filename_arr[1]}


python3 parse_magma_out.py --filename "magma_out/step2/${filename_arr[1]}.genes.out" 


mkdir scdrs_out
scdrs munge-gs \
    --out-file "scdrs_out/${filename_arr[1]}.gs" \
    --pval-file "magma_out/step2/${filename_arr[1]}.genes.out.csv" \
    --weight zscore \
    --n-max 1000

python3 scDRS/compute_score.py \
    --h5ad_file scdrs_data/leiden_scanpy_double_injury_50PCA_20neighbors.h5ad \
    --h5ad_species human \
    --gs_file "scdrs_out/${filename_arr[1]}.gs" \
    --gs_species human \
    --flag_filter True \
    --flag_raw_count False \
    --flag_return_ctrl_raw_score False \
    --flag_return_ctrl_norm_score True \
    --out_folder scdrs_out

