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
Install the following R packages if you haven't already: tidytext, text2vec, dplyr, ggplot2, tm, tokenizers, stringr, rvest, httr, jsonlite, shiny, reticulate.

### Clone the Repository
To clone the repository, use the following commands: git clone <repository-url> and cd <repository-directory>.

## Usage
### Running the Shiny App
To start the Shiny app, run the command to launch it in your R environment.

This will launch the app in your web browser where you can upload text files and generate summaries.

### Configuration
Replace your_openai_api_key_here in the R script with your actual OpenAI API key.

## Project Structure
1. ui.R: Defines the user interface for the Shiny app.
2. server.R: Handles the server-side logic for processing and summarizing the text.
3. clean_file.R: A utility function for cleaning text files before processing.
4. gpt3_summarizer.R: The main script for text summarization using GPT-3.

## Example
### Input
Upload a .txt file with content about GPT-3 or any other text data.

### Output
The app will generate a summary based on the input text.
