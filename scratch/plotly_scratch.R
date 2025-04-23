library(tidyverse)
library(plotly)
library(ggplotly)


# high ambition 2045 goal offshore wind
osw_2045_high <- osw |> 
    filter(type == 'direct' &
               occupation %in% c('O&M', 'Construction'))

#plotly(osw_2045_high, x = ~year, y = n_jobs,color = ~occupation, type = "box")


osw_2045_high_plot <- ggplot(osw, aes(x = year, y = total_jobs, group = occupation)) +
    geom_col(aes(fill = occupation)) +
    scale_fill_manual(labels = c("Construction Jobs", "Operations & Maintenance Jobs"),
                      values = c("#4a4e69", "#9a8c98")) +
    scale_y_continuous(limits = c(0, 2000)) +
    labs(title = "Projected direct jobs in CA \nCentral Coast from \nFloating OSW development",
         y = "FTE Jobs") +
    theme_minimal() +
    theme(
        axis.title.x = element_blank(),
        axis.title.y = element_text(size = 10, margin = margin(5,20,0,10)),
        axis.text = element_text(size = 12), 
        plot.title = element_text(size=13),
        legend.title = element_blank(),
        legend.text = element_text(size = 3),
        legend.position = "bottom",
        plot.background = element_rect(fill = "#EFEFEF"),
        panel.grid = element_line(color = "grey85")
    )
plotly::ggplotly(osw_2045_high_plot)




