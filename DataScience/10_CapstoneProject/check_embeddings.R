library(keras)
source("helpers.R")

MAX_SEQUENCE_LENGTH <- 1000
MAX_NUM_WORDS <- 20000
EMBEDDING_DIM <- 50

load("data/embeddings/glove_embedding_matrix")
load("data/embeddings/glove_embeddings_index")
tokenizer <- load_text_tokenizer("data/derived/tokenizer")

word_index <-  tokenizer$word_index[1:MAX_NUM_WORDS]
vocab_size <- dim(embedding_matrix)[1]

embeddings = word_to_vec(c("idk", "woman", "father", "mother",
                           "by"), 
                         word_index, embedding_matrix)


most_similar("idk", embedding_matrix, word_index, 50)


