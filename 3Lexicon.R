#PROJECT : 3 text-mining lexicons in R tidytext
# https://datacritics.com/2018/03/14/three-text-sentiment-lexicons-in-r-tidytext/
# NOTE THIS SCRIPT IS FROM THE AMAZING BOOK TEXTMINING FROM R - this is for a perpsective of output options

# Load
library("dplyr")
library("tidytext")
library(gutenbergr)

# ONE - download book
wh <- gutenberg_download(768) 

# TWO - set up : tokenization & unnest word into row,
# & remove stop_words (words from three lexicons in tidytext)
lxwh <- wh %>%
  unnest_tokens(word,text)
data(stop_words)
lxw1 <- lxwh %>% anti_join(stop_words)

#THREE : explore lexicon output
#Lexicon option 1 = "nrc" - binary categorization + emotions
lxw1 %>%
  inner_join(get_sentiments("nrc")) 
#Lexicon option 2 = "afinn" - binary categorization
lxw1 %>%
  inner_join (get_sentiments("afinn")) 
#Lexicon option 3 = "bing" - range 5 to -5
lxw1 %>%
  inner_join(get_sentiments("bing")) 

#FOUR : SUMMARIES
#summarize nrc
lxw1 %>%
  inner_join(get_sentiments("nrc")) %>%
  count(sentiment,sort=T) 
#summarize "bing"
lxw1 %>%
  inner_join(get_sentiments("bing")) %>%
  count(sentiment,sort=T) 
#summarize "affin"
lxw1 %>%
  inner_join(get_sentiments("afinn")) %>%
  count(score,sort=F)  
#opted for sort=F to see distribution across all scores

