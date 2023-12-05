# Replace "your_source_directory" with the actual path of the source directory
source_directory <- "path_to_directory_of_images"

# Replace "your_output_directory" with the desired path for the new directories
output_directory <- "path_to_directory_to_processed_images"

# List all directories in the source directory
directories <- list.dirs(source_directory, full.names = TRUE, recursive = FALSE)

# Function to check if a directory contains .tif files
has_tif_files <- function(directory) {
  tif_files <- list.files(directory, pattern = "\\.tif$", full.names = TRUE, recursive = TRUE)
  length(tif_files) > 0
}

# Filter directories that contain .tif files
directories_with_tif <- directories[sapply(directories, has_tif_files)]

# Function to copy directories with .tif files and the associated .tif files to the output directory
copy_directories_with_tif <- function(directory) {
  dest_directory <- file.path(output_directory, basename(directory))
  dir.create(dest_directory, recursive = TRUE, showWarnings = FALSE, mode = "0777")
  
  # Copy the directory
  cat("Copied directory with TIF files:", directory, "to", dest_directory, "\n")
  
  # List all .tif files in the current directory and its subdirectories
  tif_files <- list.files(directory, pattern = "\\.tif$", full.names = TRUE, recursive = TRUE)
  
  # Copy each .tif file to the corresponding directory in the output directory
  for (tif_file_path in tif_files) {
    new_tif_file_path <- file.path(dest_directory, basename(tif_file_path))
    file.copy(tif_file_path, new_tif_file_path)
    
    cat("Copied:", tif_file_path, "to", new_tif_file_path, "\n")
  }
}

# Copy directories with .tif files and the associated .tif files to the output directory
lapply(directories_with_tif, copy_directories_with_tif)

#add an underscore according to ImageBreed file requirements

recursive_rename <- function(directory) {
  # List all files in the directory and its subdirectories
  all_files <- list.files(directory, recursive = TRUE, full.names = TRUE)
  
  # Iterate through each file
  for (file_path in all_files) {
    # Extract the filename and directory from the path
    file_info <- file.path(file_path)
    print(file_info)
    file_name <- basename(file_info)
    file_dir <- dirname(file_info)
    
    # Check if the filename contains underscores
    if (grepl(".tif", file_name)) {
      # Replace underscores with underscores repeated
      new_file_name <- gsub("reflectance_", "reflectance__", file_name)
      new_file_name <- gsub("red edge", "rededge", new_file_name)
      new_file_name <- gsub("_dsm", "_dsm__bw", new_file_name)
      
      # Construct the new file path
      new_file_path <- file.path(file_dir, new_file_name)
      
      # Rename the file
      file.rename(file_info, new_file_path)
      
      cat("Renamed:", file_info, "to", new_file_path, "\n")
    }
  }
}

# Example usage: Replace "your_directory_path" with the actual path of your folder
recursive_rename(output_directory)

# List all directories in the source directory
directories <- list.dirs(output_directory, full.names = TRUE, recursive = FALSE)

# Function to check if a directory contains .tif files
has_tif_files <- function(directory) {
  tif_files <- list.files(directory, pattern = "\\.tif$", full.names = TRUE, recursive = TRUE)
  length(tif_files) > 0
}

# Filter directories that contain .tif files
directories_with_tif <- directories[sapply(directories, has_tif_files)]

# Function to copy directories with .tif files and the associated .tif files to the output directory
copy_and_compress_directory <- function(directory) {
  dest_directory <- file.path(output_directory, basename(directory))
  dir.create(dest_directory, recursive = TRUE, showWarnings = FALSE, mode = "0777")
  
  # List all .tif files in the current directory and its subdirectories
  tif_files <- list.files(directory, pattern = "\\.tif$", full.names = TRUE, recursive = TRUE)
  
  # Copy each .tif file to the corresponding directory in the output directory
  for (tif_file_path in tif_files) {
    new_tif_file_path <- file.path(dest_directory, basename(tif_file_path))
    file.copy(tif_file_path, new_tif_file_path)
    
    cat("Copied:", tif_file_path, "to", new_tif_file_path, "\n")
  }
  
  if (length(tif_files) > 0) {
    # Create a zip file with the contents of the directory
    zip_file_path <- file.path(output_directory, paste0(basename(directory), ".zip"))
    zip(zip_file_path, dest_directory)
    
    cat("Compressed directory:", dest_directory, "to", zip_file_path, "\n")
  } else {
    cat("No TIF files found in directory:", dest_directory, "\n")
  }
}

# Copy and compress directories with .tif files and the associated .tif files to the output directory
lapply(directories_with_tif, copy_and_compress_directory)