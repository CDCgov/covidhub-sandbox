
hub_path <- "."
output_path <- "src/code/"

yml_files <- list.files(file.path(hub_path, "model-metadata"),
  pattern = "\\.ya?ml$", full.names = TRUE
)

extract_metadata <- function(file) {
  yml_data <- yaml::yaml.load_file(file)
  team_abbr <- ifelse("team_abbr" %in% names(yml_data), yml_data$team_abbr, NA)
  model_abbr <- ifelse(
    "model_abbr" %in% names(yml_data), yml_data$model_abbr, NA
  )
  designated_user <- ifelse(
    "designated_github_user" %in% names(yml_data),
    yml_data$designated_github_user, NA
  )

  return(c(team_abbr, model_abbr, designated_user))
}

metadata_list <- purrr::map(yml_files, extract_metadata)
metadata_df <- do.call(rbind, metadata_list)
colnames(metadata_df) <- c("team_name", "model_name", "designated_users")

team_model <- paste(
  metadata_df[, "team_name"],
  metadata_df[, "model_name"],
  sep = "-"
)

out <- paste(
  team_model,
  metadata_df[, "designated_users"],
  sep = " "
)

writeLines(out, file.path(output_path, "authorized_users.txt"))
