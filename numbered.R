setwd("Desktop/sandboxSQL")
point_adult = read.table("pointadult.csv", header=T, sep=',')
pointadult=point_adult[2:1820,2:7]

data=pointadult[,c(1,3,5)]
library('reshape2')
library('stringr')
library('plyr')
?melt
?dcast
castdata = dcast(data, species~character, mean)
write.table(castdata, file="castpointadult.csv", sep=',', eol='\n', na='NA')

plot(castdata$`Heteroneme length (um)`,castdata$`Heteroneme width (um)`)

mean_adult = read.table("meanadult.tsv", header=T, sep='\t')
meandata=mean_adult[,c(2,4,6)]
castmeandata=dcast(meandata, species~character, mean)

plot(castmeandata$`Gastrozooid length (mm)`,castmeandata$`Gastrozooid mastigophore length (um)`)

library('dplyr')
joindata=full_join(castdata, castmeandata)[c(1:85,87:123),]
meltjoindata = melt(joindata)
mjd_pruned = meltjoindata[which(!is.na(meltjoindata$value)),]

combinedata = dcast(mjd_pruned, species~variable, mean)

plot(combinedata$`Haploneme.number`,combinedata$`Haploneme.length.(um)`)

write.table(combinedata, file="castmeanpointadult.tsv", sep='\t',na='?', row.names = F)

log.data = log(combinedata[which(!is.na(combinedata$`Haploneme number`)),c(31:33)])
rownames(log.data) = combinedata[which(!is.na(combinedata$`Haploneme number`)),1]
Pgroups = combinedata[,1]
data.pca <- prcomp(log.data, center = TRUE, scale. = TRUE)
print(data.pca)
plot(data.pca, type = "l")
summary(data.pca)
#library('ggbiplot')
#PCAplot <- ggbiplot(data.pca, obs.scale = 1, var.scale = 1, ellipse = TRUE, circle = TRUE, var.axes = TRUE, alpha = 0.1, groups = Pgroups) + scale_color_discrete(name = '') + theme(legend.direction = 'horizontal', legend.position = 'top')
#print(PCAplot)
