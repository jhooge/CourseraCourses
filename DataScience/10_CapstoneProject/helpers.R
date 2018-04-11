## Utility functions

unpack <- function(fpath, ...) {
  
  if (tools::file_ext(fpath) == "zip") {
    cat(sprintf("[INFO] Decompressing %s\n", fpath))
    unzip(fpath, ...)
  } else if(tools::file_ext(fpath) %in% c("tar", "gz")) {
    cat(sprintf("[INFO] Decompressing %s\n", fpath))
    untar(fpath, ...)
  }
}

download_data <- function(data_dir, url_path, data_file, decompress=T, ...) {
  destfile <- file.path(data_dir, data_file)
  
  if (!file.exists(destfile)) {
    if(!dir.exists(data_dir))
      dir.create(data_dir, recursive = T)
    
    download.file(paste0(url_path, data_file), destfile, ...)
    
    if(decompress) {unpack(destfile, exdir=data_dir)}
    unlink(data_file)
  } else {
    cat(sprintf("[INFO] %s already exists!\n", destfile))
    if(decompress) {unpack(destfile, exdir=data_dir)}
  }
}

read_corpus <- function(fpath) {
  t <- readLines(fpath, encoding = "utf8")
  t <- paste(t, collapse = "\n")
  i <- regexpr(pattern = '\n\n', t, fixed = TRUE)[[1]]
  if (i != -1L)
    t <- substring(t, i)
  
  return(t)
}

filter_words <- function(texts, word_list) {
  print("Filtering words.")
  texts <- unlist(strsplit(texts[1], split = " "))
  texts <- texts[!texts %in% word_list]
  texts <- paste(texts, collapse = " ")
  return(texts)
}

clean_text <- function(text, 
                       lowercase=TRUE, alnum=TRUE, 
                       punctuation=TRUE,
                       spaces=TRUE, numbers=TRUE,
                       abbreviations=TRUE, twitter=FALSE) {
  
  # texts: character string
  if(lowercase) {
    print("Converting to lower case.")
    text <- tolower(text)
  }
  
  if(numbers) {
    print("Removing numbers.")
    text <- gsub("[[:digit:]]", "", text)
  }
  
  if(abbreviations) {
    print("Replacing abbreviations ('s, 've, n't, ...).")
    text <- gsub("’", "'", text)
    text <- gsub("`", "'", text)
    text <- gsub("'s", " is", text, ignore.case = T)
    text <- gsub("'ve", " have", text, ignore.case = T)
    text <- gsub("can't", "cannot", text, ignore.case = T)
    text <- gsub("n't", " not", text, ignore.case = T)
    text <- gsub("'m ", " am ", text, ignore.case = T)
    text <- gsub(" m ", " am ", text, ignore.case = T)
    text <- gsub("'re", " are ", text, ignore.case = T)
    text <- gsub("'d", " would ", text, ignore.case = T)
    text <- gsub("'ll", " will ", text, ignore.case = T)
    text <- gsub("y'all", "you all", text, ignore.case = T)
  }
  
  if(twitter) {
    
    ## taken from http:/www.socialmediatoday.com
    print("Replacing conversational abbreviations.")
    text <- gsub("#[a-z,A-Z]*", "", text, ignore.case = T) ## hashtags
    text <- gsub("@[a-z,A-Z]*", "", text, ignore.case = T) ## users
    text <- gsub("afaik", "as far as i know", text, ignore.case = T)
    text <- gsub("ayfkmwts", "are you fucking kidding me with this shit", text)
    text <- gsub("b4", "before", text, ignore.case = T)
    text <- gsub("bfn", "bye for now", text, ignore.case = T)
    text <- gsub("bgd", "background", text, ignore.case = T)
    text <- gsub("\\bbh\\b", "blockhead", text, ignore.case = T)
    text <- gsub("\\bbr\\b", "best regards", text, ignore.case = T)
    text <- gsub("btw", "by the way", text, ignore.case = T)
    text <- gsub("cd9", "code 9", text, ignore.case = T)
    text <- gsub("chk", "check", text, ignore.case = T)
    text <- gsub("cul8r", "see you later", text, ignore.case = T)
    text <- gsub("\\bdam\\b", "see you later", text, ignore.case = T)
    text <- gsub("\\bdd\\b", "dear daughter", text, ignore.case = T)
    text <- gsub("\\bdf\\b", "dear fiance", text, ignore.case = T)
    text <- gsub("\\bdp\\b", "profile picture", text, ignore.case = T)
    text <- gsub("\\bds\\b", "dear son", text, ignore.case = T)
    text <- gsub("\\bdyk\\b", "did you know", text, ignore.case = T)
    text <- gsub("\\bem\\b", "email", text, ignore.case = T)
    text <- gsub("\\bema\\b", "email", text, ignore.case = T)
    text <- gsub("\\bf2f\\b", "face to face", text, ignore.case = T)
    text <- gsub("\\bftf\\b", "face to face", text, ignore.case = T)
    text <- gsub("\\bfb\\b", "facebook", text, ignore.case = T)
    text <- gsub("\\bff\\b", "follow friday", text, ignore.case = T)
    text <- gsub("\\bffs\\b", "for fuck's sake", text, ignore.case = T)
    text <- gsub("\\bfml\\b", "fuck my life", text, ignore.case = T)
    text <- gsub("\\bfotd\\b", "find of the day", text, ignore.case = T)
    text <- gsub("\\bftw\\b", "for the win", text, ignore.case = T)
    text <- gsub("\\bfubar\\b", "fucked up beyond all repair", text, ignore.case = T)
    text <- gsub("\\bfoobar\\b", "fucked up beyond all repair", text, ignore.case = T)
    text <- gsub("\\bfwiw\\b", "for what it's worth", text, ignore.case = T)
    text <- gsub("\\bgmafb\\b", "give me a fucking break", text, ignore.case = T)
    text <- gsub("\\bgtfoohb\\b", "get the fuck out of here", text, ignore.case = T)
    text <- gsub("\\bgtfob\\b", "get the fuck out of here", text, ignore.case = T)
    text <- gsub("\\bgtfb\\b", "get the fuck out of here", text, ignore.case = T)
    text <- gsub("\\bgtsb\\b", "guess the song", text, ignore.case = T)
    text <- gsub("\\bhagnb\\b", "have a good night", text, ignore.case = T)
    text <- gsub("\\bhotdb\\b", "headline of the day", text, ignore.case = T)
    text <- gsub("\\bhandb\\b", "have a nice day", text, ignore.case = T)
    text <- gsub("\\bhthb\\b", "hope this helps", text, ignore.case = T)
    text <- gsub("\\bomg\\b", "oh my god", text, ignore.case = T)
    text <- gsub("\\bicb\\b", "i see", text, ignore.case = T)
    text <- gsub("\\bicymib\\b", "in case you missed it", text, ignore.case = T)
    text <- gsub("\\bidkb\\b", "i dont know", text, ignore.case = T)
    text <- gsub("\\bikb\\b", "i know", text, ignore.case = T)
    text <- gsub("\\biircb\\b", "if i remember correctly", text, ignore.case = T)
    text <- gsub("\\bimho\\b", "in my humble opinion", text, ignore.case = T)
    text <- gsub("\\birl\\b", "in real life", text, ignore.case = T)
    text <- gsub("\\biwsn\\b", "i want sex now", text, ignore.case = T)
    text <- gsub("\\bjk\\b", "joke", text, ignore.case = T)
    text <- gsub("\\bjsyk\\b", "just so you know", text, ignore.case = T)
    text <- gsub("\\bjv\\b", "joint venture", text, ignore.case = T)
    text <- gsub("\\bkk\\b", "cool cool", text, ignore.case = T)
    text <- gsub("\\bkyso\\b", "knock your socks off", text, ignore.case = T)
    text <- gsub("\\blhh\\b", "laughing over laughing", text, ignore.case = T)
    text <- gsub("\\blmao\\b", "laughing my ass off", text, ignore.case = T)
    text <- gsub("\\blol\\b", "laughing out loud", text, ignore.case = T)
    text <- gsub("\\bmm\\b", "music monday", text, ignore.case = T)
    text <- gsub("\\bmirl\\b", "meet in real life", text, ignore.case = T)
    text <- gsub("\\bmrjn\\b", "marijuana", text, ignore.case = T)
    text <- gsub("\\bnbd\\b", "no big deal", text, ignore.case = T)
    text <- gsub("\\bnct\\b", "nobody cares though", text, ignore.case = T)
    text <- gsub("\\bnfw\\b", "no fucking way", text, ignore.case = T)
    text <- gsub("\\bnjoy\\b", "enjoy", text, ignore.case = T)
    text <- gsub("\\bnsfw\\b", "not safe for work", text, ignore.case = T)
    text <- gsub("\\bnts\\b", "note to self", text, ignore.case = T)
    text <- gsub("\\bomfg\\b", "oh my fucking god", text, ignore.case = T)
    text <- gsub("\\boomf\\b", "one of my friends", text, ignore.case = T)
    text <- gsub("\\borly\\b", "oh really", text, ignore.case = T)
    text <- gsub("\\bplmk\\b", "please let me know", text, ignore.case = T)
    text <- gsub("\\bpnp\\b", "party and play", text, ignore.case = T)
    text <- gsub("\\bqotd\\b", "quote of the day", text, ignore.case = T)
    text <- gsub("\\bre\\b", "in reply to", text, ignore.case = T)
    text <- gsub("\\brtfm\\b", "read the fucking manual", text, ignore.case = T)
    text <- gsub("\\brtq\\b", "read the question", text, ignore.case = T)
    text <- gsub("\\bsfw\\b", "safe for work", text, ignore.case = T)
    text <- gsub("\\bsmdh\\b", "shaking my damn head", text, ignore.case = T)
    text <- gsub("\\bsmh\\b", "shaking my head", text, ignore.case = T)
    text <- gsub("\\bsnafu\\b", "situation normal all fucked up", text, ignore.case = T)
    text <- gsub("\\bsob\\b", "son of a bitch", text, ignore.case = T)
    text <- gsub("\\bsrs\\b", "serious", text, ignore.case = T)
    text <- gsub("\\bstfu\\b", "shut the fuck up", text, ignore.case = T)
    text <- gsub("\\bstfw\\b", "search the fucking web", text, ignore.case = T)
    text <- gsub("\\btftf\\b", "thanks for the follow", text, ignore.case = T)
    text <- gsub("\\btftt\\b", "thanks for the tweet", text, ignore.case = T)
    text <- gsub("\\btl\\b", "timeline", text, ignore.case = T)
    text <- gsub("\\btldr\\b", "too long did not read", text, ignore.case = T)
    text <- gsub("\\btl;dr\\b", "too long did not read", text, ignore.case = T)
    text <- gsub("\\btmb\\b", "tweet me back", text, ignore.case = T)
    text <- gsub("\\btt\\b", "trending topic", text, ignore.case = T)
    text <- gsub("\\bty\\b", "thank you", text, ignore.case = T)
    text <- gsub("\\btyia\\b", "thank you in advance", text, ignore.case = T)
    text <- gsub("\\btyvm\\b", "thank you very much", text, ignore.case = T)
    text <- gsub("\\btyt\\b", "take your time", text, ignore.case = T)
    text <- gsub("\\bw\\\\b", "with", text, ignore.case = T)
    text <- gsub("\\bwtv\\b", "whatever", text, ignore.case = T)
    text <- gsub("\\bygtr\\b", "you got that right", text, ignore.case = T)
    text <- gsub("\\bykwim\\b", "you know what i mean", text, ignore.case = T)
    text <- gsub("\\byolo\\b", "you only look once", text, ignore.case = T)
    text <- gsub("\\byoyo\\b", "you are on your own", text, ignore.case = T)
    text <- gsub("\\byw\\b", "you are welcome", text, ignore.case = T)
    text <- gsub("\\bzomg\\b", "oh my god", text, ignore.case = T)
    
    print("Removing technical twitter abbreviations")  
    text <- gsub("\\bcc\\b", "", text, ignore.case = T)
    text <- gsub("\\bcx\\b", "", text, ignore.case = T)
    text <- gsub("\\bct\\b", "", text, ignore.case = T)
    text <- gsub("\\bdm\\b", "", text, ignore.case = T)
    text <- gsub("\\bht\\b", "", text, ignore.case = T)
    text <- gsub("\\bmt\\b", "", text, ignore.case = T)
    text <- gsub("\\bprt\\b", "", text, ignore.case = T)
    text <- gsub("\\brt\\b", "", text, ignore.case = T)
  }
  
  if(punctuation) {
    print("Removing punctuation.")
    text <- gsub('[[:punct:] ]+',' ', text)
  }
  
  if(alnum) {
    print("Removing non-alphanumerics.")
    text <- gsub("[^[:alnum:] ]", "", text)
  }
  
  if(spaces) {
    print("Removing extra white spaces.")
    text <- gsub("[ \t]{2,}", " ", text)
    text <- gsub("^\\s+|\\s+$", "", text)
  }
  
  return(text)
}

strtail <- function(s,n=1) {
  if(n<0)
    substring(s,1-n)
  else
    substring(s,nchar(s)-n+1)
}

strhead <- function(s,n) {
  if(n<0)
    substr(s,1,nchar(s)+n) 
  else
    substr(s,1,n)
}

split_to_words <- function(text) {
  return(unlist(strsplit(text, " ")))
}

## returns chunks of chunksize.
chunk <- function(text, chunk_size=1) {
  stopifnot(chunk_size > 0)
  
  chunks <- c()
  for (i in 1:(length(text)-chunk_size)) {
    chunk <- paste(text[i:(i+chunk_size-1)], collapse = " ")
    chunks <- c(chunks, chunk)
  }
  return(chunks)
}

sample_chunks <- function(text, n, max_size=10, seed=42) {
  set.seed(seed)
  starts <- sample(1:(length(text)-max_size-1), n, replace=F)
  ends <- starts + sample(0:(max_size-1), n, replace=T)
  
  samples <- c()
  successors <- c()
  
  for (i in 1:length(starts)) {
    samples <- c(samples, paste(text[starts[i]:ends[i]], collapse = " "))
    successors <- c(successors, text[ends[i]+1])
    
#    print(paste(starts[i], ends[i]))
#    print(paste(text[starts[i]:ends[i]], collapse = " "))
#    print(text[ends[i]+1])
  }
  
  return(data.frame(X=samples, y=successors))
}

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

word_to_index <- function(words, word_index) {
  indices <- rep(-1, length(words))
  is_in_index <- words %in% names(word_index)
  indices[is_in_index] <- unlist(word_index[words[is_in_index]])
  return(indices)
}

index_to_word <- function(indices, word_index) {
  is_unknown <- indices == -1
  words <- rep("<unk>", length(indices))
  words[!is_unknown] <- names(word_index)[match(indices[!is_unknown], word_index)]
  return(words)
}

word_to_vec <- function(words, word_index, embedding_matrix) {
  n_words <- length(words)
  embedding_dim <- dim(embedding_matrix)[2]
  indices <- word_to_index(words, word_index)
  is_unknown <- indices == -1
  
  embeddings <- matrix(rep(0, n_words*embedding_dim), 
                       nrow=n_words, ncol=embedding_dim)
  embeddings[!is_unknown, ] <- embedding_matrix[indices[!is_unknown],]
  return(embeddings)
}

cosine_similarity <- function(u, v) {
  norm_u <- norm(u, type = "2")
  norm_v <- norm(v, type = "2")
  a <- u%*%v
  b = norm_u %*% norm_v
  return(c(a/b))
}

pair_cosine_similarity <- function(u, V) {
  a <- apply(V, 1, function(x) u%*%x)
  b <- norm(u, type = "2")
  c <- apply(V, 1, function(x) sqrt(sum(x^2)))
  return(a/(b*c))
}

most_similar <- function(word, embedding_matrix, word_index, topN) {
  v <- word_to_vec(word, word_index, embedding_matrix)
  similarities <- pair_cosine_similarity(v, embedding_matrix)
  names(similarities) <- index_to_word(1:length(similarities), word_index)
  similarities <- similarities[!names(similarities) %in% word] ## remove v from similarity
  similarities <- sort(similarities, decreasing = T)
  return(head(similarities, topN))
}