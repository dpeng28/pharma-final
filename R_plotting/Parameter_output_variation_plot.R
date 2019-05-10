library(ggplot2)
library(reshape2)
library(R.matlab)
# load Matlab file from path
young_pop <- as.data.frame(readMat('young_pop_data.mat'))[,-c(2)]
mid_pop <- as.data.frame(readMat('mid_pop_data.mat'))[,-c(2)]
old_pop <- as.data.frame(readMat('old_pop_data.mat'))[,-c(2)]

# reformat data frame
header <- c('(a) weight_var','(b) kgo_var','(c) kgg_var','(d) kgl_var','(e) klp_var','(f) kpl_var','(g) kpg_var','(h) kpo_var','(i) kin_var','(j) Ctrough_metformin(blood)_var','(k) Drug_AUC_var','(l) Ctrough_glucose(blood)_var')
colnames(young_pop) <- header
colnames(mid_pop) <- header
colnames(old_pop) <- header
young_pop$label <- 'young'
mid_pop$label <- 'mid'
old_pop$label <- 'old'
pop_all <- rbind(young_pop,mid_pop,old_pop)
pop_all<-melt(pop_all, id = "label")

pop_all$label <- factor(pop_all$label, levels = c("young", "mid", "old"))

# plot a bunch of boxplots (parameter, output variation visualization)
  p <- ggplot(data = pop_all, aes(x=variable, y=value)) + 
  geom_boxplot(aes(fill=label))+
  theme_bw()+  theme(axis.title = element_text(size = 20))+
  theme(axis.text.x  = element_blank())+
  theme(legend.text = element_text(size = 20))+
  theme(legend.title = element_text(size = 20))+
  theme(strip.text.x = element_text(size = 14))+
  theme(axis.text.y  = element_text(size = 14))
    
  
p + facet_wrap( ~ variable, scales="free")

