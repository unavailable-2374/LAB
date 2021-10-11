setwd("~/BSA_project/R_analysis")#更改为用户目录
#devtools::install_github("bmansfeld/QTLseqr")
library("QTLseqr")
library(vcfR)
vcf <- read.vcfR("BSA_filter_merged_SNP_INDEL.vcf")#更改为输入文件名
#Cf-long    Cf-short        Col     mutant #前两个分别是两个池，后边的是野生型和突变体
chrom <- getCHROM(vcf)
pos <- getPOS(vcf)
ref <- getREF(vcf)
alt <- getALT(vcf)
 
ad <- extract.gt(vcf, "AD")
ref_split <- masplit(ad, record = 1, sort = 0)
alt_split <- masplit(ad, record = 2, sort = 0)
gt <- extract.gt(vcf, "GT")
head(gt)
df <- data.frame(CHROM = chrom,
                 POS = pos,
                 REF = ref,
                 ALT = alt,
                 AD_REF.long= ref_split[,1],
                 AD_ALT.long= alt_split[,1],
                 AD_REF.short = ref_split[,2],
                 AD_ALT.short = alt_split[,2]
)
mask <- which(gt[,"Col"] != "0/1" &  gt[,"mutant"] != "0/1") # 选择亲本纯合的标记
df_mask <- df[mask,]
write.table(df_mask, file = "BSA_right2.tsv", sep = "\t", row.names = F, quote = F)
df_cal <- importFromTable("BSA_right2.tsv",
                      highBulk = "long",
                      lowBulk = "short",
                      sep = "\t")
df_clean <- subset(df_cal, !is.na(SNPindex.LOW) & !is.na(SNPindex.HIGH))
df_result <- runGprimeAnalysis(SNPset = df_clean,
                        windowSize = 1e6,
                        outlierFilter = "Gprime")
plotQTLStats(
  SNPset = df_result,
  var = "Gprime",
  plotThreshold = TRUE,
  q = 0.01
)