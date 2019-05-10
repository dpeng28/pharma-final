library(ggplot2)
library(reshape2)
library(R.matlab)

# load Matlab data from path
age <- as.data.frame(readMat('age.mat'))
missed_young <- as.data.frame(readMat('1young.mat'))
missed_mid <- as.data.frame(readMat('2middle.mat'))
missed_old <- as.data.frame(readMat('3old.mat'))
# create new matrix to store data
missed_young_forplot <- as.data.frame(matrix(nrow=2,ncol=3))
missed_mid_forplot <- as.data.frame(matrix(nrow=2,ncol=3))
missed_old_forplot <- as.data.frame(matrix(nrow=2,ncol=3))

# calculate mean and standard deviation to plot barplot and store in matrix

# calculate mean
missed_young_forplot[1,] <- c(mean(missed_young[,1]),mean(missed_young[,2]),mean(missed_young[,3])) 
missed_mid_forplot[1,] <- c(mean(missed_mid[,1]),mean(missed_mid[,2]),mean(missed_mid[,3])) 
missed_old_forplot[1,] <- c(mean(missed_old[,1]),mean(missed_old[,2]),mean(missed_old[,3])) 

# calculate SD
missed_young_forplot[2,] <- c(sd(missed_young[,1]),sd(missed_young[,2]),sd(missed_young[,3])) 
missed_mid_forplot[2,] <- c(sd(missed_mid[,1]),sd(missed_mid[,2]),sd(missed_mid[,3])) 
missed_old_forplot[2,] <- c(sd(missed_old[,1]),sd(missed_old[,2]),sd(missed_old[,3]))

# format the data frame
age = t(age)
missed_young_forplot = t(missed_young_forplot)
missed_mid_forplot = t(missed_mid_forplot)
missed_old_forplot = t(missed_old_forplot)

age = data.frame(age)
missed_young_forplot = data.frame(missed_young_forplot)
missed_mid_forplot = data.frame(missed_mid_forplot)
missed_old_forplot = data.frame(missed_old_forplot)

header <- c('1','2','3','4','5','6')
header_1 <-c('Young','Mid','Old')
header_2 <-c('Value','sd')

colnames(age) <- header_1
colnames(missed_young_forplot) <- header_2
colnames(missed_mid_forplot) <- header_2
colnames(missed_old_forplot) <- header_2

age$label <-c('Drug_AUC(mg/dL•t)','Drug_Ctrough(mg/dL)','Glu_Ctrough(mg/dL)')


missed_young_forplot$cate <-c('Drug_AUC(mg/dL•t)','Drug_Ctrough(mg/dL)','Glu_Ctrough(mg/dL)')
missed_mid_forplot$cate <-c('Drug_AUC(mg/dL•t)','Drug_Ctrough(mg/dL)','Glu_Ctrough(mg/dL)')
missed_old_forplot$cate <-c('Drug_AUC(mg/dL•t)','Drug_Ctrough(mg/dL)','Glu_Ctrough(mg/dL)')


missed_young_forplot$Population <-c('Young','Young','Young')
missed_mid_forplot$Population <-c('Mid','Mid','Mid')
missed_old_forplot$Population <-c('Old','Old','Old')

age <- melt(age, id.vars = 'label')

header_3 <- c('Categories','Scenarios','Value')
header_4 <- c('Categories','Populations','Value')

colnames(age) <- header_4

# merge dataframe for easy plot
final <- merge( missed_young_forplot, missed_mid_forplot, all = TRUE)
final <- merge( final, missed_old_forplot, all = TRUE)

# plot missed dose
ggplot(data=dose, aes(x=Scenarios, y=Value,fill = Scenarios)) +
  geom_bar(stat="identity", colour="black",position="dodge") + 
  facet_wrap(~Categories) + theme_bw() + 
  facet_wrap(~Categories, scale = 'free')+
  scale_fill_brewer(palette = 'Spectral')+
  theme(axis.text.x = element_text(size = 14))+
  theme(axis.text.y = element_text(size = 14))+
  theme(legend.title = element_text(size = 14))+
  theme(legend.text  = element_text(size = 14))+
  theme(strip.text  = element_text(size = 14))+
  theme(strip.text.x = element_text(size = 14))+
  theme(axis.title  = element_text(size = 14))+
  
  labs(x ="Group")

# plot age related output 

final$Population <- factor(final$Population, levels = c("Young", "Mid", "Old"))

ggplot(final, aes(x=Population, y=Value,fill = Population)) +
  geom_bar(stat="identity", colour="black",position="dodge") + 
  facet_wrap(~cate) + theme_bw() + 
  geom_errorbar(aes(ymin=Value-sd, ymax=Value+sd), size=0.5,   
                       width=.25,position=position_dodge(.9)) +
  facet_wrap(~cate, scale = 'free')+
  theme(axis.title = element_text(size = 14))+
  theme(legend.title = element_text(size = 14))+
  theme(legend.text  = element_text(size = 14))+
  theme(strip.text  = element_text(size = 14))+
  theme(axis.text = element_text(size  = 14))+
  labs(x ="Group")



