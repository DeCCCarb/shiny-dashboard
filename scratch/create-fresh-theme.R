library(fresh)


create_theme(
    
    adminlte_color(
        light_blue = '#DCE1E5'
        
        
    ),
    
    adminlte_global(
        
        content_bg = '#FFFFFF',
        
    ),
    
    
    adminlte_sidebar(
        dark_bg = '#DCE1E5',
        dark_hover_bg = '#09847A',
        dark_color = '#09847A',
        width = '400px'
        
    ),
    
    
    
    output_file = here::here('app', 'www', 'dashboard-fresh-theme.css')
    
)


