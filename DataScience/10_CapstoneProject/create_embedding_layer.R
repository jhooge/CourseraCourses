#' This script loads pre-trained word embeddings (GloVe embeddings) into a
#' frozen Keras Embedding layer, and uses it to train a next word prediction
#' model on the Coursera's Swiftkey dataset.
#' 
#' GloVe embedding data can be found at: 
#' http://nlp.stanford.edu/data/glove.6B.zip (source page:
#' http://nlp.stanford.edu/projects/glove/)
#'
#' Swiftkey data can be found at: 
#' https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip
#' 

#'
#' IMPORTANT NOTE: This example does yet work correctly. The code executes fine and
#' appears to mimic the Python code upon which it is based however it achieves only
#' half the training accuracy that the Python code does so there is clearly a 
#' subtle difference.
#' 
#' We need to investigate this further before formally adding to the list of examples
#'
#'  

library(keras)

TEXT_DATA_DIR <- "./data/derived"
GLOVE_DIR <- "./data/embeddings/glove.6B"
MAX_SEQUENCE_LENGTH <- 1000
MAX_NUM_WORDS <- 20000
EMBEDDING_DIM <- 50

# # download data if necessary
# download_data <- function(data_dir, url_path, data_file) {
#     if (!dir.exists(data_dir)) {
#         dir.create(data_dir, recursive = T)
#         destfile <- file.path(data_dir, data_file)
#         print(destfile)
#         download.file(paste0(url_path, data_file), destfile, mode = "wb")
#         if (tools::file_ext(destfile) == "zip") {
#             print("File exists. Unpacking!")
#             unzip(destfile, exdir = tools::file_path_sans_ext(destfile))
#         } else if(tools::file_ext(destfile) %in% c("tar", "gz")){
#             print("File exists. Unpacking!")
#             untar(destfile)
#         }
#         unlink(data_file)
#     } else {
#       sprintf("[WARNING] %s already exists!", data_dir)
#     }
# }
# 
# download_data(GLOVE_DIR, 'http://nlp.stanford.edu/data/', 'glove.6B.zip')
# download_data(TEXT_DATA_DIR, 
#               'https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/', 'Coursera-SwiftKey.zip')
# download_data("./data/profanity", "http://www.cs.cmu.edu/~biglou/resources/", "bad-words.txt") 

# first, build index mapping words in the embeddings set
# to their embedding vector
# 
# cat('Indexing word vectors.\n')

# #embeddings_index <- new.env(parent = emptyenv())
# lines <- readLines(file.path(GLOVE_DIR, 'glove.6B.50d.txt'))
# 
# embeddings_index <- list()
# i = 0
# for (line in lines) {
#   line <- unlist(strsplit(line, " ", fixed=TRUE))
#   word <- line[1]
#   print(paste(i, word))
#   coefs <- as.numeric(line[2:length(line)])
#   embeddings_index[[word]] <- coefs
#   i=i+1
# }

load("./data/embeddings/glove_embeddings_index")

cat(sprintf('Found %s word vectors.\n', length(embeddings_index)))

# second, prepare text samples and their labels
# cat('Processing text dataset\n')
# 
# texts <- character()  # text samples
# 
# textfiles = list.files(file.path(TEXT_DATA_DIR, "en_US"), full.names = T)
# for (fpath in textfiles) {
#     t <- readLines(fpath, encoding = "utf8")
#     t <- paste(t, collapse = "\n")
#     i <- regexpr(pattern = '\n\n', t, fixed = TRUE)[[1]]
#     if (i != -1L)
#         t <- substring(t, i)
#     texts <- c(texts, t)
# } 
# 
# cat(sprintf('Found %s texts.\n', length(texts)))
# 
# # finally, vectorize the text samples into a 2D integer tensor
# tokenizer <- text_tokenizer(num_words=MAX_NUM_WORDS, char_level = FALSE)
# tokenizer %>% fit_text_tokenizer(as.array(texts))
# 
# # save the tokenizer in case we want to use it again
# # for prediction within another R session, see:
# # https://keras.rstudio.com/reference/save_text_tokenizer.html
# save_text_tokenizer(tokenizer, file.path("data/derived", "tokenizer"))
tokenizer <- load_text_tokenizer(file.path("./data/derived", "tokenizer"))
sequences <- texts_to_sequences(tokenizer, texts)

word_index <- tokenizer$word_index
cat(sprintf('Found %s unique tokens.\n', length(word_index)))

data <- pad_sequences(sequences, maxlen=MAX_SEQUENCE_LENGTH)

cat('Preparing embedding matrix.\n')

# prepare embedding matrix
num_words <- min(MAX_NUM_WORDS, length(word_index) + 1)
prepare_embedding_matrix <- function() {
    embedding_matrix <- matrix(0L, nrow = num_words, ncol = EMBEDDING_DIM)
    for (word in names(word_index)) {
        index <- word_index[[word]]
        if (index >= MAX_NUM_WORDS)
            next
        embedding_vector <- embeddings_index[[word]]
        if (!is.null(embedding_vector)) {
            # words not found in embedding index will be all-zeros.
            embedding_matrix[index,] <- embedding_vector
        }
    }
    embedding_matrix
}

embedding_matrix <- prepare_embedding_matrix()
save(embedding_matrix, file="./data/embeddings/glove_embedding_matrix")