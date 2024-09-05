# GPT-3 Text Summarizer using AI

## Overview

GPT-3 Text Summarizer using AI is an AI-powered tool that leverages OpenAI's GPT-3 model to summarize text. The project includes web scraping, text preprocessing, TF-IDF scoring, and a Shiny app interface for users to upload text files and receive summarized outputs.

## Features
1. Web Scraping: Automatically scrapes and processes text data from web sources.
2. Text Preprocessing: Cleans and prepares text data by removing stop words and applying TF-IDF.
3. AI Summarization: Uses OpenAI's GPT-3 API to generate summaries of the provided text.
4. Shiny App Interface: User-friendly interface to upload text files and get real-time summaries.
5. Word Frequency Analysis: Visualizes the most frequent words in the text data.

## Installation

### Prerequisites
1. R (version 4.0 or higher)
2. RStudio (optional but recommended)
3. An OpenAI API key (for GPT-3 access)

### Required R Packages
Install the following R packages if you haven't already:
```r
install.packages(c("tidytext", "text2vec", "dplyr", "ggplot2", "tm", "tokenizers", "stringr", "rvest", "httr", "jsonlite", "shiny", "reticulate"))

### Clone the Repository
bash
Copy code
git clone https://github.com/violapatrao22/GPT-3-Text-Summarizer-using-AI.git
cd GPT-3-Text-Summarizer-using-AI
Usage
Running the Shiny App
To start the Shiny app, run the following command in your R environment:

r
Copy code
shiny::runApp()
This will launch the app in your web browser where you can upload text files and generate summaries.

Configuration
Replace "your_openai_api_key_here" in the R script with your actual OpenAI API key:

r
Copy code
openai_api_key <- "your_openai_api_key_here"
Project Structure
ui.R: Defines the user interface for the Shiny app.
server.R: Handles the server-side logic for processing and summarizing the text.
clean_file.R: A utility function for cleaning text files before processing.
gpt3_summarizer.R: The main script for text summarization using GPT-3.
Example
Input
Upload a .txt file with the following content:

csharp
Copy code
GPT-3, or Generative Pre-trained Transformer 3, is a state-of-the-art language model developed by OpenAI...
Output
The app will generate a summary like:

csharp
Copy code
GPT-3 is a state-of-the-art language model developed by OpenAI...
