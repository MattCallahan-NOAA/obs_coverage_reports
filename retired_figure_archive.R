## old code removed from the obs report

```{r fig2, warning=FALSE, message=FALSE, echo=FALSE, fig.width=6, fig.cap=paste0("Figure ", params$chapter, ".", params$appendix, ".2. Proportion of fixed gear ", params$name," catch in pots in the Gulf of Alaska (dashed line), the Bering Sea and Aleutian Islands (dotted line), and both combined (solid line). Jig gear is excluded.")}
#process data
fig2dat<-casdat%>%
  #filter to fixed gear
  filter(gear %in% c("HAL", "POT")) %>%
  #calculate total for all fixed gear
  group_by(year, fmp_area) %>%
  summarize(fixed_gear_catch=sum(catch_mt)) %>%
  #add column for pot gear only
  left_join(casdat%>%
              #filter to pot
              filter(gear == "POT") %>%
              #calculate total for pot
              group_by(year, fmp_area) %>%
              summarize(pot_catch=sum(catch_mt)),
            by=c("year"="year", "fmp_area"="fmp_area")) %>%
  mutate(prop_pot=pot_catch/fixed_gear_catch)


fig2<-ggplot()+
  geom_line(data=fig2dat%>%filter(fmp_area=="BSAI"), aes(x=as.numeric(year), y=prop_pot), size=1, lty=3)+
  geom_line(data=fig2dat%>%filter(fmp_area=="GOA"), aes(x=as.numeric(year), y=prop_pot), size=1, lty=2)+
  geom_line(data=fig2dat%>%group_by(year) %>%
              summarize(fixed_gear_catch=sum(fixed_gear_catch),
                        pot_catch=sum(pot_catch)) %>%
              mutate(prop_pot=pot_catch/fixed_gear_catch),
            aes(x=as.numeric(year), y=prop_pot), size=1, lty=1)+
  #facet_wrap(~fmp_area)+
  scale_x_continuous(breaks = seq(startyear, endyear, by = 1))+
  ylim(c(0,1))+
  xlab("Year")+ ylab("Pot proportion")+
  ggtitle("Proportion of Fixed Gear Catch in Pots")+
  theme_doc()+
  theme(plot.title = element_text(hjust = 0.5))
suppressWarnings(fig2)
```

```{r fig10old, eval=FALSE, warning=FALSE, message=FALSE, echo=FALSE, fig.asp=1.2, fig.width=6, fig.cap=paste0("Figure ", params$chapter, ".", params$appendix, ".10. The proportion of ",  params$name," fixed gear catch with electronic monitoring (black) and the rate of length sampling (lengths per metric ton; red). Values are scaled to a mean of zero for comparison. Areas include the Aleutian Islands (AI), Bering Sea (BS), Western Gulf of Alaska (WGOA), Central Gulf of Alaska (CGOA), West Yakutat (WY), and East Yakutat (EY)")}

#https://finchstudio.io/blog/ggplot-dual-y-axes/
#for two y axes

fig10propEM <- casdat %>%
  filter(gear %in% c("POT", "HAL") &
           obs_coverage == "EM Partial") %>%
  group_by(mgmt_area, year) %>%
  summarize(em_catch=sum(catch_mt)) %>%
  left_join(casdat %>%
              filter(gear %in% c("POT", "HAL")) %>%
              group_by(mgmt_area, year) %>%
              summarize(total_catch=sum(catch_mt)),
            by=c("year"="year", "mgmt_area"="mgmt_area")) %>%
  mutate(prop_em=em_catch/total_catch,
         year=as.numeric(year)) %>%
  group_by(mgmt_area) %>%
  mutate(prop_em_scaled=scale(prop_em)) %>%
  ungroup()

fig10lnmt <- norln%>%
  filter(gear %in% c("POT","HAL") ) %>%
  group_by(year, mgmt_area) %>%
  summarize(n_length=sum(n_length)) %>%
  left_join(casdat%>%
              filter(gear %in% c("POT","HAL")) %>%
              mutate(year=as.numeric(year))%>%
              group_by(year, mgmt_area) %>%
              summarize(catch_mt=sum(catch_mt)),
            by=c("year"="year", "mgmt_area"="mgmt_area"))%>%
  mutate(lratio=n_length/catch_mt)%>%
  group_by(mgmt_area) %>%
  mutate(lratio_scaled=scale(lratio))%>%
  ungroup()

scaleFUN <- function(x) sprintf("%.0f", x)

ggplot()+
  geom_line(data=fig10propEM, aes(x=year, y=prop_em_scaled, color="black"), size=1)+
  geom_line(data=fig10lnmt, aes(x=year, y=lratio_scaled, color="red"), size=1)+
  facet_wrap(~mgmt_area, ncol=1)+
  scale_colour_manual(name="",  values=c('black'='black', 'red'='red'), labels=c("Proportion EM","Lengths/mt"))+
  ylab("Scaled Lengths/mt and Proportion Catch with EM")+
  xlab("")+
  theme_doc()+
  scale_x_continuous(labels=scaleFUN)


#Best attempt to do figure ten with ggplot
scaleFUN <- function(x) sprintf("%.0f", x)

scale=10


suppressWarnings(
  ggplot() +
    geom_line(data=fig10propEM, aes(x=year, y=prop_em, color="Catch with EM/Total Catch (mt)"), size=1)+
    geom_line(data=fig10lnmt, aes(x=year, y=lratio/scale, color="Lengths/mt"), size=1)+
    facet_wrap(~mgmt_area, ncol=1, scales="free_y")+
    scale_y_continuous(sec.axis = sec_axis(~.*scale, name="Lengths/mt")) +
    labs(x = "", y = "Catch with EM/Total Catch (mt)", color = "") +
    scale_color_manual(values = c("black", "red"))+
    scale_x_continuous(labels=scaleFUN, n.breaks=nyears)+
    theme_doc()
)
