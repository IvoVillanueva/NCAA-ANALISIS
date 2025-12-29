# Fix nested quotes in strings
# Problem: "Basketball Club "Bashkimi"" should be "Basketball Club Bashkimi"

# Example string with nested quotes
original <- 'Basketball Club "Bashkimi"'

# Solution 1: Using gsub to remove all quotes
fixed_1 <- gsub('"', '', original)
cat("Solution 1 (remove all quotes):\n", fixed_1, "\n\n")

# Solution 2: Using gsub to remove quotes only around specific words
# This is useful if you want to keep quotes elsewhere
fixed_2 <- gsub('"([^"]+)"', '\\1', original)
cat("Solution 2 (regex pattern):\n", fixed_2, "\n\n")

# Example with a data frame
df <- data.frame(
  team = c('Basketball Club "Bashkimi"', 'Team "Alpha"', 'Regular Team'),
  stringsAsFactors = FALSE
)

cat("Original data frame:\n")
print(df)

# Apply fix to the column
df$team <- gsub('"', '', df$team)

cat("\nFixed data frame:\n")
print(df)

# If you have a CSV file with this issue:
# df <- read.csv("your_file.csv", stringsAsFactors = FALSE)
# df$team_column <- gsub('"', '', df$team_column)
# write.csv(df, "fixed_file.csv", row.names = FALSE)
