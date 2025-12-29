# Fix nested quotes in strings
# Problem: String contains quotes around words like "Bashkimi"
# Goal: Remove those quotes to get clean text

# Example string with quotes around a word
# In R, we use single quotes to define a string that contains double quotes
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
  team = c('Basketball Club "Bashkimi"', 'Team "Alpha"', 'Regular Team')
)

cat("Original data frame:\n")
print(df)

# Apply fix to the column
df$team <- gsub('"', '', df$team)

cat("\nFixed data frame:\n")
print(df)

# If you have a CSV file with this issue:
# df <- read.csv("your_file.csv")
# df$team_column <- gsub('"', '', df$team_column)
# write.csv(df, "fixed_file.csv", row.names = FALSE)
