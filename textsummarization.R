# Install required packages
install.packages("tidytext")
install.packages("text2vec")
install.packages("dplyr")
install.packages("ggplot2")
install.packages("tm")
install.packages("tokenizers")
install.packages("stringr")
install.packages("rvest")
install.packages("httr")
install.packages("jsonlite")
install.packages("shiny")
install.packages("reticulate")

# Load required libraries
library(tidytext)
library(text2vec)
library(dplyr)
library(ggplot2)
library(tm)
library(tokenizers)
library(stringr)
library(rvest)
library(httr)
library(jsonlite)
library(shiny)
library(reticulate)

# Step 1: Web Scraping and Cleaning
url <- "https://jamesclear.com/kasparov-confidence"
webpage <- read_html(url)
text_data <- webpage %>% html_nodes("p") %>% html_text()

# Clean the scraped text
text_data_clean <- gsub("\n", " ", text_data)  # Replace newlines with spaces

# Optional: Convert the cleaned text into a data frame
text_data_df <- data.frame(text = text_data_clean, stringsAsFactors = FALSE)

# Step 2: Text Preprocessing
# Split text into sentences
text_sentences <- unlist(strsplit(text_data_clean, "\\.\\s+"))

# Tokenize and clean the text
tidy_text <- text_data_df %>%
  unnest_tokens(word, text)

# Remove stop words
data("stop_words")
tidy_text <- tidy_text %>%
  anti_join(stop_words, by = "word")

# Step 3: Term Frequency and TF-IDF
# Create a text corpus and a document-term matrix
corpus <- Corpus(VectorSource(text_sentences))
dtm <- DocumentTermMatrix(corpus)

# Apply TF-IDF weighting
dtm_tfidf <- weightTfIdf(dtm)

# Convert the DTM to a matrix
dtm_matrix <- as.matrix(dtm_tfidf)

# Step 4: Sentence Scoring and Ranking
# Score sentences based on the TF-IDF matrix
sentence_scores <- rowSums(dtm_matrix)

# Rank sentences by their score
ranked_sentences <- order(sentence_scores, decreasing = TRUE)

# Extract the top 5 sentences as the summary
summary_sentences <- text_sentences[ranked_sentences[1:5]]
summary <- paste(summary_sentences, collapse = " ")

# Step 5: Summarization with GPT-3
# Define a function to call the OpenAI API for summarization
summarize_text <- function(text) {
  openai_api_key <- "your_openai_api_key_here"  # Replace with your actual API key
  response <- POST(
    url = "https://api.openai.com/v1/completions",
    add_headers(Authorization = paste("Bearer", openai_api_key)),
    body = list(
      model = "text-davinci-003",  # Use the appropriate GPT-3 model
      prompt = paste0("Summarize the following text: ", text),
      max_tokens = 150
    ),
    encode = "json"
  )
  
  # Parse the response and extract the summary
  content_response <- content(response, as = "parsed", type = "application/json")
  summary_text <- content_response$choices[[1]]$text
  return(summary_text)
}

# Example of using the summarize_text function
gpt3_summary <- summarize_text(text_data_clean)

# Step 6: Shiny App Interface
# Define the UI for the Shiny app
ui <- fluidPage(
  titlePanel("Text Summarization using GPT-3"),
  sidebarLayout(
    sidebarPanel(
      fileInput("file1", "Choose Text File", accept = c("text/csv", "text/comma-separated-values,text/plain", ".csv")),
      actionButton("summarize", "Summarize")
    ),
    mainPanel(
      h3("Summary"),
      verbatimTextOutput("summary")
    )
  )
)

# Define the server logic for the Shiny app
server <- function(input, output) {
  # Clean the file if needed (remove incomplete lines)
  clean_file <- function(file_path) {
    lines <- readLines(file_path, warn = FALSE)
    
    # Check if the last line is incomplete and append a newline if necessary
    if (length(lines) > 0 && nchar(lines[length(lines)]) > 0) {
      lines <- c(lines, "")  # Add an empty line if the last line isn't complete
    }
    
    # Write the cleaned lines back to a temporary file
    temp_file <- tempfile()
    writeLines(lines, temp_file)
    
    # Read the cleaned file into a data frame
    df <- read.table(temp_file, header = TRUE, sep = ",", stringsAsFactors = FALSE)
    return(df)
  }
  
  observeEvent(input$summarize, {
    req(input$file1)
    df <- clean_file(input$file1$datapath)
    text_data <- paste(df$text, collapse = " ")
    
    # Use GPT-3 to summarize the text
    summary <- summarize_text(text_data)
    output$summary <- renderText({ summary })
  })
}

# Run the Shiny app
shinyApp(ui = ui, server = server)

# Step 7: Text Analytics - ROUGE Score Calculation
# Calculate ROUGE-1 (unigram) score
generated_summary <- "The cat sat on the mat."
reference_summary <- "A cat is sitting on a mat."

generated_tokens <- unlist(tokenize_words(generated_summary))
reference_tokens <- unlist(tokenize_words(reference_summary))

intersect_tokens <- intersect(generated_tokens, reference_tokens)
rouge_1_recall <- length(intersect_tokens) / length(reference_tokens)
rouge_1_precision <- length(intersect_tokens) / length(generated_tokens)

# Calculate the F1 score
rouge_1_f1 <- if ((rouge_1_recall + rouge_1_precision) > 0) {
  2 * ((rouge_1_recall * rouge_1_precision) / (rouge_1_recall + rouge_1_precision))
} else {
  0
}

print(paste("ROUGE-1 Recall: ", rouge_1_recall))
print(paste("ROUGE-1 Precision: ", rouge_1_precision))
print(paste("ROUGE-1 F1 Score: ", rouge_1_f1))

# Calculate ROUGE-L score
lcs <- function(x, y) {
  m <- nchar(x)
  n <- nchar(y)
  l <- matrix(0, m + 1, n + 1)
  
  for (i in 1:m) {
    for (j in 1:n) {
      if (substr(x, i, i) == substr(y, j, j)) {
        l[i + 1, j + 1] <- l[i, j] + 1
      } else {
        l[i + 1, j + 1] <- max(l[i + 1, j], l[i, j + 1])
      }
    }
  }
  return(l[m + 1, n + 1])
}

rouge_l_recall <- lcs(generated_summary, reference_summary) / nchar(reference_summary)
rouge_l_precision <- lcs(generated_summary, reference_summary) / nchar(generated_summary)

rouge_l_f1 <- if ((rouge_l_recall + rouge_l_precision) > 0) {
  2 * ((rouge_l_recall * rouge_l_precision) / (rouge_l_recall + rouge_l_precision))
} else {
  0
}

print(paste("ROUGE-L Recall: ", rouge_l_recall))
print(paste("ROUGE-L Precision: ", rouge_l_precision))
print(paste("ROUGE-L F1 Score: ", rouge_l_f1))

# Step 8: Word Frequency Analysis
# Calculate word frequencies
word_freq <- colSums(dtm_matrix)
word_freq_df <- data.frame(word = names(word_freq), freq = word_freq)

# Select top 20 most frequent words
top_n <- 20
word_freq_top_n <- word_freq_df %>%
  arrange(desc(freq)) %>%
  head(top_n)

# Plot the top 20 words
ggplot(word_freq_top_n, aes(x = reorder(word, -freq), y = freq)) +
  geom_bar(stat = "identity") +
  coord_flip() +
  labs(title = "Top 20 Word Frequency in Text Data", x = "Words", y = "Frequency") +
  theme(axis.text.y = element_text(size = 10))  # Adjust text size
