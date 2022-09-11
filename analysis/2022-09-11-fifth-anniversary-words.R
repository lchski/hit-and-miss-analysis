source("load.R")

library(tidytext)

newsletter_words_raw <- newsletters %>%
  select(-html_parsed) %>%
  unnest_tokens(word, text)

newsletter_words <- newsletter_words_raw %>%
  anti_join(get_stopwords())

# Wordiest issues?
newsletter_words_raw %>% count(id, sort = TRUE)

# Words per issue?
(newsletter_words_raw %>% nrow) / (newsletters %>% nrow)

# Most common words?
newsletter_words %>% count(word, sort = TRUE)

