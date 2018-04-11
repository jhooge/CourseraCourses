library(keras)
source("helpers.R")

load("data/embeddings/glove_embedding_matrix")
tokenizer <- load_text_tokenizer("data/derived/tokenizer")
dat_train <- read.csv("data/derived/en_US/en_US.training.csv", 
                      header = T, sep = ",", as.is=TRUE)

MAX_SEQUENCE_LENGTH <- 10
MAX_NUM_WORDS <- 20000
EMBEDDING_DIM <- 50

word_index <- tokenizer$word_index[1:MAX_NUM_WORDS]
vocab_size <- dim(embedding_matrix)[1]

dat_train.head <- head(dat_train, 20000)
X <- dat_train.head$X
y <- dat_train.head$y

# X <- dat_train$X
# y <- dat_train$y

x_train <- tokenizer$texts_to_sequences(as.array(X))
x_train <- pad_sequences(x_train, maxlen = MAX_SEQUENCE_LENGTH)
y_train <- tokenizer$texts_to_sequences(as.array(y))
is_empty <- sapply(y_train, function(x) length(x) == 0)
x_train <- x_train[!is_empty,] # remove rows with un-embedded y labels
y_train <- unlist(y_train)
y_train <- to_categorical(y_train, num_classes = vocab_size)
stopifnot(dim(x_train)[1] == dim(y_train)[1])

num_words <- min(c(MAX_NUM_WORDS, length(word_index)))

model <- keras_model_sequential()
model %>%
 layer_embedding(
   input_dim = MAX_NUM_WORDS,
   output_dim = EMBEDDING_DIM,
   weights = list(embedding_matrix),
   input_length = MAX_SEQUENCE_LENGTH,
   trainable = FALSE) %>%
  layer_lstm(128, activation="tanh", 
             input_shape = c(MAX_SEQUENCE_LENGTH, 1)) %>%
  layer_dense(vocab_size) %>%
  layer_activation("softmax")

optimizer <- optimizer_adam(lr = 0.01)

model %>% compile(
  loss = "categorical_crossentropy", 
  optimizer = optimizer,
  metrics = c('accuracy')
)

history <- model %>% fit(x_train, y_train, 
                         epochs = 10, batch_size = 512,
                         validation_split = 0.2)

plot(history)

for (i in 1:100) {
  X.encoded <- tokenizer$texts_to_sequences(as.array(X[i]))
  X.encoded <- pad_sequences(X.encoded, maxlen = MAX_SEQUENCE_LENGTH)
  y_pred <- model$predict_classes(x=as.array(unlist(X.encoded)))+1
  y_pred <- names(unlist(word_index[y_pred]))
  y_true <- y[i]
  
  print(sprintf("%s... (y_pred=%s,  y_true=%s)", X[i], y_pred, y_true))
}