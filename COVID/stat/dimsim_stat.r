setwd("C:/OneDrive - UC San Diego/data/immuno/COVID/stat")
require(reshape2); require(ggplot2); require(scales); require(patchwork); require(dplyr); require(RColorBrewer)

d=read.csv("metric",sep=" ",header = F)
d$rep = as.factor(d$V1); d$method = as.factor(d$V3); d$metric = as.factor(d$V4); d$score = as.numeric(d$V5)
levels(d$method) = list("IgPhyML"="igphyml", "IgPhyML*"="igphyml_star", "RAxML"="raxml", "RAxML*"="raxml_star",
                        "Immunitree"="immunitree", "MST"="mst",
                        "Dnapars"="dnapars_greedy", "Dnapars*"="dnapars_consensus",
                        "BEAST"="beast", "BEAST*"="beast_star", "GCtree"="gctree",
                        "control"="permut_1", "control"="permut_2", "control"="permut_3")
levels(d$metric) = list("RF Cluster Distance"="RF_plus", "Patristic Distance"="mrca", "MRCA Discordance"="mrca_abs",
                        "Triplet Edit Distance"="TED", "Triplet Discordance"="TD")
for (i in seq_len(nrow(d))){
  d[i,]$score = d[i,]$V5 / mean(d[d$rep == d[i,]$rep & d$method == "control" & d$metric == d[i,]$metric,]$V5)
}

p1 = ggplot(d[d$method != "control" & d$metric != "Patristic Distance" & !(d$rep %in% c(3, 32)),], aes(x = method, y = score, fill = method)) +
  facet_wrap(.~metric, scales="free_x") + theme_bw() +
  geom_violin() + coord_flip() +
  geom_boxplot(width=0.15) +
  stat_summary(position = position_dodge(width=0.5),shape=4)+
  scale_fill_manual(values=c(brewer.pal(n = 10, name = 'Paired'), "#999900" , "black"),name="")+
  scale_x_discrete(name="", limits = rev(levels(d$method)[levels(d$method) != "control"])) +
  scale_y_continuous(name="") +
  theme(legend.position = "none")+
  theme(plot.tag.position = c(0.012, 0.98),plot.tag = element_text(size=14,face = "bold"),
        legend.margin = margin(0,0,0,0,"pt"),legend.box.margin = margin(0,0,0,0,"pt"))+labs(tag="B"); p1
ggsave("metrics.pdf",width=7,height=5)

d2=read.csv("tpfpfn",sep=" ",header = F)
d2$rep = as.factor(d2$V1); d2$method = as.factor(d2$V3); d2$metric = as.factor(d2$V4)
d2$TP = as.numeric(d2$V5); d2$FP = as.numeric(d2$V6); d2$FN = as.numeric(d2$V7)
d2$FDR = d2$FP / (d2$FP + d2$TP) # 1 - precision
d2$FNR = d2$FN / (d2$FN + d2$TP) # 1 - recall
levels(d2$method) = list("IgPhyML"="igphyml", "IgPhyML*"="igphyml_star", "RAxML"="raxml", "RAxML*"="raxml_star",
                        "Immunitree"="immunitree", "MST"="mst",
                        "Dnapars"="dnapars_greedy", "Dnapars*"="dnapars_consensus", 
                        "BEAST"="beast", "BEAST*"="beast_star", "GCtree"="gctree",
                        "control"="permut_1", "control"="permut_2", "control"="permut_3")
d2 = d2[!(d2$rep %in% c(3, 32)), ]
s2 = d2 %>% group_by(method, metric) %>% summarize(FDR = mean(FDR), FNR = mean(FNR))
p2 = ggplot(s2[s2$metric == "plus",], aes(x = FDR, y = FNR, color = method, shape = method)) +
  theme_bw() + 
  geom_point( aes(x = FDR, y = FNR, color = method), data=d2[d2$metric == "plus",],size=1,alpha=0.5) + 
  geom_point(size=5) + 
  scale_color_manual(name="", values=c(brewer.pal(n = 10, name = 'Paired'), "#999900" , "black")) +
  scale_x_continuous(name="False Discovery Rate") +
  scale_y_continuous(name="False Negative Rate") +
  scale_shape_manual(name="", values=c(19, 19, 17, 17, 43, 88, 15, 15, 18, 18, 79, 42))+
  theme(plot.tag.position = c(0.012, 0.98),plot.tag = element_text(size=14,face = "bold"),
        legend.margin = margin(0,0,0,0,"pt"),legend.box.margin = margin(0,0,0,0,"pt"))+labs(tag="A"); p2
ggsave("FDR_FNR_plus_trivial.pdf",width=7,height=5)


d3=read.csv("scale",sep=" ",header = F)
d3$rep = as.factor(d3$V1); d3$size = as.factor(d3$V2); d3$method = as.factor(d3$V3); d3$metric = as.factor(d3$V4); d3$score = as.numeric(d3$V5)
levels(d3$method) = list("IgPhyML"="igphyml", "RAxML"="raxml",
                        "Immunitree"="immunitree", "MST"="mst",
                        "Dnapars"="dnapars_greedy", "BEAST"="beast",
                        "control"="permut_1", "control"="permut_2", "control"="permut_3")
d4=read.csv("time",sep="\t",header = F)
d4$rep = as.factor(d4$V1); d4$size = as.factor(d4$V2); d4$method = as.factor(d4$V3); d4$time = as.numeric(d4$V4);
levels(d4$method) = list("IgPhyML"="igphyml", "RAxML"="raxml",
                         "Immunitree"="immunitree", "MST"="mst",
                         "Dnapars"="dnapars_greedy", "BEAST"="beast",
                         "control"="permut_1", "control"="permut_2", "control"="permut_3")
d4$score = -1
for (i in seq_len(nrow(d3))){
  if (d3[i,]$method != "control") {
    #print(d4[d4$rep == d3[i,]$rep & as.numeric(d4$size) == as.numeric(d3[i,]$size) & d4$method == d3[i,]$method,])
    d4[d4$rep == d3[i,]$rep & as.numeric(d4$size) == as.numeric(d3[i,]$size) & d4$method == d3[i,]$method,]$score = d3[i,]$score / mean(d3[d3$rep == d3[i,]$rep & d3$size == d3[i,]$size & d3$method == "control" & d3$metric == d3[i,]$metric,]$score)
  }
}

s4 = d4[d4$score != -1,] %>% group_by(method, size) %>% summarize(time = mean(time), score = mean(score))
ggplot(s4, aes(y = time, x = score, color = method, shape = method)) +
  facet_grid(.~size, labeller = as_labeller(function(string) paste0(string, " samples"))) + theme_bw() +
  geom_point( aes(y = time, x = score, color = method), data=d4[d4$score != -1,],size=1,alpha=0.5) + 
  geom_point(size=5) + 
  #stat_summary(position = position_dodge(width=0.5),shape=4)+
  scale_y_log10(name="Running time (log scale)", breaks = c(1,60,3600,3600*24), labels=c("sec", "min", "hour", "day"), limits=c(0.2,3600*24)) + 
  scale_x_log10(name="Triplet Edit Distance (TED)") +
  scale_color_brewer(palette = "Dark2",name="") +
  scale_shape_manual(name="", values=c(19, 17, 43, 88, 15, 18)) +
  theme(legend.position = "bottom") + guides(colour = guide_legend(nrow = 1))
ggsave("scale.pdf",width=10,height=4)

( ggplot(d4[d4$score != -1,], aes(y = time, x = as.numeric(as.character(size)), color = method, shape = method)) +
  stat_summary()+stat_summary(geom="line")+
  theme_bw() +
  #geom_point(size=0.5) + 
  #stat_summary(position = position_dodge(width=0.5),shape=4)+
  scale_y_log10(name="Running time (log scale)", breaks = c(1,60,3600,3600*24), labels=c("sec", "min", "hour", "day"), limits=c(0.2,3600*24)) + 
  scale_x_log10(name="# Samples (log scale)", breaks = c(50,100,200,500)) +
  scale_color_brewer(palette = "Dark2",name="") +
  scale_shape_manual(name="", values=c(19, 17, 43, 88, 15, 18)) +
  theme(legend.position = "none")+
  theme(plot.tag.position = c(0.012, 0.98),plot.tag = element_text(size=14,face = "bold"),
        legend.margin = margin(0,0,0,0,"pt"),legend.box.margin = margin(0,0,0,0,"pt"))+labs(tag="A") ) +
( ggplot(d4[d4$score != -1,], aes(y = score, x = as.numeric(as.character(size)), color = method, shape = method)) +
  stat_summary()+stat_summary(geom="line")+
  theme_bw() +
  #geom_point(size=0.5) + 
  #stat_summary(position = position_dodge(width=0.5),shape=4)+r
  scale_y_continuous(name="Triplet Edit Distance (TED)", breaks = c(0.1,0.2,0.3,0.4,0.5,0.6,0.7)) + 
  scale_x_log10(name="# Samples (log scale)", breaks = c(50,100,200,500)) +
  scale_color_brewer(palette = "Dark2",name="") +
  scale_shape_manual(name="", values=c(19, 17, 43, 88, 15, 18)) +
  theme(plot.tag.position = c(0.012, 0.98),plot.tag = element_text(size=14,face = "bold"),
        legend.margin = margin(0,0,0,0,"pt"),legend.box.margin = margin(0,0,0,0,"pt"))+labs(tag="B") )
ggsave("scale2.pdf",width=10,height=4)


lm(log(time)~log(as.numeric(as.character(size))), d4[d4$score != -1 & d4$method == "IgPhyML",])
lm(log(time)~log(as.numeric(as.character(size))), d4[d4$score != -1 & d4$method == "RAxML",])
lm(log(time)~log(as.numeric(as.character(size))), d4[d4$score != -1 & d4$method == "Immunitree",])
lm(log(time)~log(as.numeric(as.character(size))), d4[d4$score != -1 & d4$method == "MST",])
lm(log(time)~log(as.numeric(as.character(size))), d4[d4$score != -1 & d4$method == "Dnapars",])
lm(log(time)~log(as.numeric(as.character(size))), d4[d4$score != -1 & d4$method == "BEAST",])

d4$size2 = as.numeric(as.character(d4$size))
summary(aov(score~size2,data=d4[d4$score != -1 & d4$method == "IgPhyML",]))
summary(aov(score~size2,data=d4[d4$score != -1 & d4$method == "RAxML",]))
summary(aov(score~size2,data=d4[d4$score != -1 & d4$method == "Immunitree",]))
summary(aov(score~size2,data=d4[d4$score != -1 & d4$method == "MST",]))
summary(aov(score~size2,data=d4[d4$score != -1 & d4$method == "Dnapars",]))
summary(aov(score~size2,data=d4[d4$score != -1 & d4$method == "BEAST",]))


d3=read.csv("scale2",sep=" ",header = F)
d3$rep = as.factor(d3$V1); d3$size = as.factor(d3$V2); d3$method = as.factor(d3$V3); d3$metric = as.factor(d3$V4); d3$score = as.numeric(d3$V5)
levels(d3$method) = list("IgPhyML*"="igphyml_star", "RAxML*"="raxml_star",
                         "Immunitree"="immunitree", "MST"="mst",
                         "Dnapars*"="dnapars_consensus", "BEAST*"="beast_star",
                         "control"="permut_1", "control"="permut_2", "control"="permut_3")
d4=read.csv("time2",sep="\t",header = F)
d4$rep = as.factor(d4$V1); d4$size = as.factor(d4$V2); d4$method = as.factor(d4$V3); d4$time = as.numeric(d4$V4);
levels(d4$method) = list("IgPhyML*"="igphyml_star", "RAxML*"="raxml_star",
                         "Immunitree"="immunitree", "MST"="mst",
                         "Dnapars*"="dnapars_consensus", "BEAST*"="beast_star",
                         "control"="permut_1", "control"="permut_2", "control"="permut_3")
d4$score = -1
for (i in seq_len(nrow(d3))){
  if (d3[i,]$method != "control") {
    #print(d4[d4$rep == d3[i,]$rep & as.numeric(d4$size) == as.numeric(d3[i,]$size) & d4$method == d3[i,]$method,])
    d4[d4$rep == d3[i,]$rep & as.numeric(d4$size) == as.numeric(d3[i,]$size) & d4$method == d3[i,]$method,]$score = d3[i,]$score / mean(d3[d3$rep == d3[i,]$rep & d3$size == d3[i,]$size & d3$method == "control" & d3$metric == d3[i,]$metric,]$score)
  }
}

s4 = d4[d4$score != -1,] %>% group_by(method, size) %>% summarize(time = mean(time), score = mean(score))
ggplot(s4, aes(y = time, x = score, color = method, shape = method)) +
  facet_grid(.~size, labeller = as_labeller(function(string) paste0(string, " samples"))) + theme_bw() +
  geom_point( aes(y = time, x = score, color = method), data=d4[d4$score != -1,],size=1,alpha=0.5) + 
  geom_point(size=5) + 
  #stat_summary(position = position_dodge(width=0.5),shape=4)+
  scale_y_log10(name="Running time (log scale)", breaks = c(1,60,3600,3600*24), labels=c("sec", "min", "hour", "day"), limits=c(0.2,3600*24)) + 
  scale_x_log10(name="Triplet Edit Distance (TED)") +
  scale_color_brewer(palette = "Dark2",name="") +
  scale_shape_manual(name="", values=c(19, 17, 43, 88, 15, 18)) +
  theme(legend.position = "bottom") + guides(colour = guide_legend(nrow = 1))
ggsave("scale_star.pdf",width=10,height=4)

( ggplot(d4[d4$score != -1,], aes(y = time, x = as.numeric(as.character(size)), color = method, shape = method)) +
    stat_summary()+stat_summary(geom="line")+
    theme_bw() +
    #geom_point(size=0.5) + 
    #stat_summary(position = position_dodge(width=0.5),shape=4)+
    scale_y_log10(name="Running time (log scale)", breaks = c(1,60,3600,3600*24), labels=c("sec", "min", "hour", "day"), limits=c(0.2,3600*24)) + 
    scale_x_log10(name="# Samples (log scale)", breaks = c(50,100,200,500)) +
    scale_color_brewer(palette = "Dark2",name="") +
    scale_shape_manual(name="", values=c(19, 17, 43, 88, 15, 18)) +
    theme(legend.position = "none")+
    theme(plot.tag.position = c(0.012, 0.98),plot.tag = element_text(size=14,face = "bold"),
          legend.margin = margin(0,0,0,0,"pt"),legend.box.margin = margin(0,0,0,0,"pt"))+labs(tag="A") ) +
  ( ggplot(d4[d4$score != -1,], aes(y = score, x = as.numeric(as.character(size)), color = method, shape = method)) +
      stat_summary()+stat_summary(geom="line")+
      theme_bw() +
      #geom_point(size=0.5) + 
      #stat_summary(position = position_dodge(width=0.5),shape=4)+r
      scale_y_continuous(name="Triplet Edit Distance (TED)", breaks = c(0.1,0.2,0.3,0.4,0.5,0.6,0.7)) + 
      scale_x_log10(name="# Samples (log scale)", breaks = c(50,100,200,500)) +
      scale_color_brewer(palette = "Dark2",name="") +
      scale_shape_manual(name="", values=c(19, 17, 43, 88, 15, 18)) +
      theme(plot.tag.position = c(0.012, 0.98),plot.tag = element_text(size=14,face = "bold"),
            legend.margin = margin(0,0,0,0,"pt"),legend.box.margin = margin(0,0,0,0,"pt"))+labs(tag="B") )
ggsave("scale_star2.pdf",width=10,height=4)

d4$size2 = as.numeric(as.character(d4$size))
summary(aov(score~size2,data=d4[d4$score != -1 & d4$method == "IgPhyML*",]))
summary(aov(score~size2,data=d4[d4$score != -1 & d4$method == "RAxML*",]))
summary(aov(score~size2,data=d4[d4$score != -1 & d4$method == "Immunitree",]))
summary(aov(score~size2,data=d4[d4$score != -1 & d4$method == "MST",]))
summary(aov(score~size2,data=d4[d4$score != -1 & d4$method == "Dnapars*",]))
summary(aov(score~size2,data=d4[d4$score != -1 & d4$method == "BEAST*",]))



d5=read.csv("property",sep=" ",header = F)
colnames(d5) = c("rep", "size", "method", "Balance (Cherry)", "Internal Sample (%)", "Bifurcation Index", "Depth of Samples (mean)")
d6=melt(d5, id=c("rep", "size", "method"))
d6$method = as.factor(d6$method)
d6$diff = -1
levels(d6$method) = list("IgPhyML"="igphyml", "IgPhyML*"="igphyml_star", "RAxML"="raxml", "RAxML*"="raxml_star",
                         "Immunitree"="immunitree", "MST"="mst",
                         "Dnapars"="dnapars_greedy", "Dnapars*"="dnapars_consensus",
                         "BEAST"="beast", "BEAST*"="beast_star", "GCtree"="gctree",
                         "Truth"="truth")
p6a = ggplot(d6[d6$size == 100,], aes(x = method, y = value, fill = method)) +
  facet_grid(.~variable, scales="free_x") + theme_bw() +
  geom_violin() + coord_flip() +
  geom_boxplot(width=0.15) +
  stat_summary(position = position_dodge(width=0.5),shape=4)+
  scale_fill_manual(name="", values=c(brewer.pal(n = 10, name = 'Paired'), "#999900" , "white")) +
  scale_x_discrete(name="", limits = rev(levels(d6$method))) +
  scale_y_continuous(name="") +
  theme(legend.position = "none")+
  theme(plot.tag.position = c(0.012, 0.98),plot.tag = element_text(size=14,face = "bold"),
        legend.margin = margin(0,0,0,0,"pt"),legend.box.margin = margin(0,0,0,0,"pt"))+labs(tag="C"); p6a
ggsave("property_covid.pdf",width=14,height=2.7)

ggplot(d6[d6$method != "GCtree",], aes(x = size, y = value, color = method, shape = method, linetype = method)) +
  facet_wrap(.~variable, scales="free") + theme_bw() +
  stat_summary()+stat_summary(geom="line")+
  scale_y_continuous(name="Tree property") + 
  scale_x_log10(name="# samples", breaks = c(50,100,200,500)) +
  scale_color_manual(name="", values=c(brewer.pal(n = 10, name = 'Paired'), "black")) +
  scale_shape_manual(name="", values=c(19, 19, 17, 17, 43, 88, 15, 15, 18, 18, 42)) +
  scale_linetype_manual(name="", values=c(replicate(10, "dashed"), "solid")) +
  theme(legend.position = "right")
ggsave("property_covid_size.pdf",width=7,height=6)

for (i in seq_len(nrow(d6))){
  d6[i,]$diff = d6[i,]$value - mean(d6[d6$rep == d6[i,]$rep & d6$size == d6[i,]$size & d6$method == "Truth" & d6$variable == d6[i,]$variable,]$value)
}

ggplot(d6[d6$size == 100,], aes(x = method, y = diff, fill = method)) +
  facet_wrap(.~variable, scales="free_x") + theme_bw() +
  geom_violin() + coord_flip() +
  geom_boxplot(width=0.15) +
  stat_summary(position = position_dodge(width=0.5),shape=4)+
  scale_fill_manual(name="", values=c(brewer.pal(n = 10, name = 'Paired'), "#999900" , "white")) +
  scale_x_discrete(name="", limits = rev(levels(d6$method))) +
  scale_y_continuous(name="") +
  theme(legend.position = "none")+
  theme(plot.tag.position = c(0.012, 0.98),plot.tag = element_text(size=14,face = "bold"),
        legend.margin = margin(0,0,0,0,"pt"),legend.box.margin = margin(0,0,0,0,"pt"))
ggsave("property_covid_diff.pdf",width=7,height=5.5)

d7=read.csv("yaari",sep=" ",header = F)
colnames(d7) = c("rep", "size", "method", "Balance (Cherry)", "Internal Sample (%)", "Bifurcation Index", "Depth of Samples (mean)")
d8=melt(d7, id=c("rep", "size", "method"))
d8$method = as.factor(d8$method)
d8$size = as.factor(d8$size)
levels(d8$method) = list("Yaari"="yaari", "K5"="truth")
ggplot(d8, aes(x = size, y = value, fill = method)) +
  facet_wrap(.~variable, scales="free") + theme_bw() +
  geom_violin() +
  #geom_boxplot(width=0.15) +
  #stat_summary(position = position_dodge(width=0.5),shape=4)+
  scale_fill_brewer(palette = "Dark2",name="")
ggsave("property_yaari.pdf",width=7,height=6)

p2+ p1
ggsave("metric_plus.pdf", width=14, height=5)

d9=read.csv("sim",sep="\t",header = F)
colnames(d9)=c("condition", "Memory", "Activated", "Affinity", "Total infection time (day)")
( ggplot(d9, aes(x = `Total infection time (day)`, y = Affinity, color = as.factor(condition))) +
    theme_bw() + geom_line() + scale_x_continuous(name="") + 
    scale_y_log10(breaks = trans_breaks("log10", function(x) 10^x), labels = trans_format("log10", math_format(10^.x))) +
    theme(legend.position = "none")
) / (
  ggplot(d9, aes(x = `Total infection time (day)`, y = Activated, color = as.factor(condition))) +
    theme_bw() + geom_line() + scale_x_continuous(name="") + scale_y_continuous() + theme(legend.position = "none")
) / (
  ggplot(d9, aes(x = `Total infection time (day)`, y = Memory, color = as.factor(condition))) +
    theme_bw() + geom_line() + scale_x_continuous() + scale_y_continuous() + theme(legend.position = "none")
)
ggsave("simulation_covid.pdf", width=5, height=5)
