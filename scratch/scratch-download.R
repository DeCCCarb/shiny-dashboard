# Install necessary libraries if not already installed
if (!requireNamespace("leaflet", quietly = TRUE)) install.packages("leaflet")
if (!requireNamespace("here", quietly = TRUE)) install.packages("here")
if (!requireNamespace("magick", quietly = TRUE)) install.packages("magick")
if (!requireNamespace("webshot", quietly = TRUE)) install.packages("webshot")
if (!requireNamespace("leaflet.extras", quietly = TRUE)) install.packages("leaflet.extras")

library(leaflet)
library(here)
library(magick)

# Ensure the directory for temp files exists
my_temp_dir <- here('app', 'temp_files')
if (!dir.exists(my_temp_dir)) {
    dir.create(my_temp_dir, recursive = TRUE)
}

# Create a temporary file path for the map image
tmpfile <- file.path(my_temp_dir, "leaflet_map.png")
print(paste("Temporary file path:", tmpfile))

# Dummy map object to use in place of an actual map (just for testing)
leaflet_map <- leaflet() %>%
    addProviderTiles(providers$Stamen.Toner) %>%
    addMarkers(lng = -119.698189, lat = 34.420830, popup = "Test Marker")

library(leaflet)
library(mapview)

# Create a Leaflet map
leaflet_map <- leaflet() %>%
    addProviderTiles(providers$Stamen.Toner) %>%
    addMarkers(lng = -119.698189, lat = 34.420830, popup = "Test Marker")

# Specify the temporary folder to save the map
tmpfile <- tempfile(pattern = "leaflet_map_", fileext = ".png")

# Save the map to the temporary file
mapshot(leaflet_map, file = tmpfile)

# Print the temporary file path
print(tmpfile)


leaflet_map

# Try saving the map as a PNG file
tryCatch({
    mapshot(leaflet_map, file = tmpfile)
    print("Map saved successfully!")
}, error = function(e) {
    print(paste("Error in saving map:", e$message))
})

# Optionally, check if the file exists
if (file.exists(tmpfile)) {
    print("Map file exists and was saved successfully.")
} else {
    print("Failed to save the map.")
}

# Create a simple table for PDF export
test_table <- data.frame(
    County = c("Santa Barbara", "Ventura"),
    Jobs = c(120, 150)
)

# Write table to a temporary text file to ensure table creation works
table_tmpfile <- file.path(my_temp_dir, "test_table.txt")
write.table(test_table, file = table_tmpfile, row.names = FALSE)

# Verify that the table was saved
if (file.exists(table_tmpfile)) {
    print("Test table saved successfully.")
} else {
    print("Failed to save the table.")
}

# Create a PDF with the map and table (you can adjust this as needed)
pdf_file <- file.path(my_temp_dir, "output.pdf")
pdf(pdf_file, onefile = TRUE)

# If map and table were successfully saved, load them into the PDF
if (file.exists(tmpfile)) {
    map_image <- magick::image_read(tmpfile)
    map_grob <- grid::rasterGrob(map_image, interpolate = TRUE)
    
    table_grob <- gridExtra::tableGrob(test_table)
    
    gridExtra::grid.arrange(
        top = "Test PDF with Map and Table",
        grobs = list(map_grob, table_grob),
        ncol = 1, heights = c(2, 1)
    )
} else {
    print("Map image not found, skipping map in PDF.")
}

dev.off()

# Check if the PDF was created
if (file.exists(pdf_file)) {
    print("PDF was created successfully.")
} else {
    print("Failed to create the PDF.")
}

