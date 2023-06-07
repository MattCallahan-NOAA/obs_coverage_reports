---
title: "sablefish_obs_coverage_draft"
author: "Matt Callahan"
date: '2023-06-06'
output: 
  word_document:
    keep_md: yes
params: 
  data: "sablefish"

---



![](sablefish_obs_coverage_draft_files/figure-docx/unnamed-chunk-1-1.png)<!-- -->


This is a report of `sablefish` catch.


```r
#plot ``r params$data``
ggplot()+geom_sf(data=nmfs)+
  ggtitle(paste0(params$data, " catch areas"))
```

![](sablefish_obs_coverage_draft_files/figure-docx/unnamed-chunk-2-1.png)<!-- -->
