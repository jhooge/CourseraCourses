Building a Deep Learning Word Prediction Model
========================================================

Hack for HPC plotting capabilities.


Load libraries, needed for the process.


Provide convenience functions for following steps.

```r
readData <- function(path) {
    data <- data.frame()
    
    inputFolder <- "data//en_US"
    
    for (f in list.files(inputFolder)) {
        con <- file(paste(inputFolder, f, sep="/"), "r")
        lines <- readLines(con)
        data <- rbind(data, cbind(rep(f, length(lines)), lines))
        close(con)
    }
    colnames(data) <- c("file", "infile")
    data$file <- as.factor(data$file)
    return(data)
}
```

Read the data line by line

```r
data <- readData("data/en_US/")
```

```
## Warning: line 167155 appears to contain an embedded nul
## Warning: line 268547 appears to contain an embedded nul
## Warning: line 1274086 appears to contain an embedded nul
## Warning: line 1759032 appears to contain an embedded nul
```

```r
data <- data[1:100,]
```

Filter data for twitter, blog and news posts.

```r
twitterData <- filter(data, data$file == "en_US.twitter.txt")
blogData <- filter(data, data$file == "en_US.blog.txt")
newsData <- filter(data, data$file == "en_US.news.txt")
```

## Construct the lexical Corpus and the Term Document Matrix
We use the function Corpus to create the corpus, and the function VectorSource to indicate that the text is in the character vector mach_text. In order to create the term-document matrix we apply different transformation such as removing numbers, punctuation symbols, lower case, etc.

```r
corpus <- Corpus(VectorSource(data$infile))
tdm = TermDocumentMatrix(corpus,
   control = list(removePunctuation = TRUE, stopwords = TRUE, 
                  removeNumbers = TRUE, tolower = TRUE))
```

## Obtain words and their frequencies

```r
# define tdm as matrix
m = as.matrix(tdm)
# get word counts in decreasing order
word_freqs = sort(rowSums(m), decreasing=TRUE) 
# create a data frame with words and their frequencies
dm = data.frame(word=names(word_freqs), freq=word_freqs)
```

## Let's plot the wordcloud
![plot of chunk unnamed-chunk-8](figure/unnamed-chunk-8.png) 
