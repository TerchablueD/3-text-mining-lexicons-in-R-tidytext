#PROJECT : 3 text-mining lexicons in R tidytext
# https://datacritics.com/2018/03/14/three-text-sentiment-lexicons-in-r-tidytext/

# Load
library("dplyr")
library("tidytext")
library(gutenbergr)


#unstructuredsata & text mining
library(gutenbergr)
gutenberg_metadata %>%
  filter(title=="Wuthering Heights")  #id=768
whcloud <- gutenberg_download(768) #master

#EXPLORATION 1 : WORDCLOUD OLD SCHOOL - JUMP TO #2 IF YOU WANT
library("tm")
library("SnowballC")
library("wordcloud")
library("RColorBrewer")

#load book text as corpus & REVIEW
wcloud <-Corpus(VectorSource(whcloud))
inspect(wcloud)

#Data Transformation 
clean1 <- content_transformer(function (x , pattern ) gsub(pattern, " ", x))
wcloud <- tm_map(wcloud, clean1, "/")
wcloud <- tm_map(wcloud, clean1, "@")
wcloud <- tm_map(wcloud, clean1, "\\|")
wcloud <- tm_map(wcloud, content_transformer(tolower))
wcloud <- tm_map(wcloud, removeNumbers)
wcloud <- tm_map(wcloud, removeWords, stopwords("english")) #no other custom stopwords
wcloud <- tm_map(wcloud, removePunctuation)
wcloud <- tm_map(wcloud, stripWhitespace)
wcloud <- tm_map(wcloud, stemDocument)

#Build a term document matrix
wh <- TermDocumentMatrix(wcloud)
whm <- as.matrix(wh)
whv <- sort(rowSums(whm),decreasing=TRUE)
whd <- data.frame(word = names(whv),freq=whv)
head(whd, 10)

#Generate wordcloud
set.seed(1234)
wordcloud(words = whd$word, freq = whd$freq, min.freq = 1,
          max.words=200, random.order=FALSE, rot.per=0.35, 
          colors=brewer.pal(8, "Dark2"))

#Source : http://www.sthda.com/english/wiki/text-mining-and-word-cloud-fundamentals-in-r-5-simple-steps-you-should-know

#EXPLORATION TIBBLING FOR SENTIMENTS


library(stringr)

#tibble & unnesting 
twh <- whcloud %>%
  unnest_tokens(word,text)
data(stop_words)
twh <- twh %>% anti_join(stop_words)
#create tibble of count from highest
twh <- twh %>% count(word, sort=TRUE) #8096 obs
twh <- twh %>% filter(n>1) #4808 obs 

library(wordcloud)

#wordcloudvia this route
twh %>%
  with(wordcloud(word,n,max.words=100,
  random.order=FALSE, rot.per=0.35,colors=brewer.pal(8, "Dark2")))

#THE REVEAL sentiment 

library(reshape2)


twh %>%
  inner_join(get_sentiments("nrc")) %>%
  count(sentiment,sort=T) %>%
  with(wordcloud(sentiment,nn,max.words=100,
                 random.order=FALSE, rot.per=0.35,colors=brewer.pal(8, "Dark2")))
  
