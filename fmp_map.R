#area map

library(akmarineareas2)
library(tidyverse)
library(sf)

#pull ak basemap and nmfs areas
nmfs<-nmfs
ak<-ak

#dissolve nmfs by FMP subarea

#define regions
fmp_sub <-nmfs %>%
  #remove Arctic, PWS, and SE inside
  filter(!NMFS_REP_AREA %in% c("400","649", "659")) %>%
  #assign fmp_subarea based on nmfs area
  mutate(nmfs_area = as.numeric(NMFS_REP_AREA),
    fmp_subarea= ifelse(nmfs_area < 540 | nmfs_area==550, "BS",
                        ifelse(nmfs_area %in% c(541, 542, 543), "AI",
                               ifelse(nmfs_area==610, "WGOA",
                                      ifelse(nmfs_area %in% c(620, 630), "CGOA",
                                             ifelse(nmfs_area == 640, "WY",
                                                    ifelse(nmfs_area ==650, "EY", NA)))))))

#dissolve
fmp_sub <- fmp_sub %>%
  group_by(fmp_subarea) %>%
  summarize()

#save map
png("fmp_subarea.png")
ggplot()+
  geom_sf(data=ak)+
  geom_sf(data=fmp_sub, fill=NA)+
  geom_sf_label(data=fmp_sub, aes(label=fmp_subarea))+
  scale_x_continuous(breaks = seq(0, 360, 10))+
  xlab("")+ylab("")+
  theme_bw()
dev.off()

