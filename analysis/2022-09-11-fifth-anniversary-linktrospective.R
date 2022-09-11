source("load.R")

library(urltools)

newsletter_links_parsed <- newsletter_links %>%
  mutate(link_parsed = map(link, url_parse)) %>%
  unnest_wider(link_parsed) %>%
  select(-port, )

# Which newsletter has the most links?
newsletter_links %>% count(id, sort = TRUE)

# Ditto, if we remove duplicates? (i.e., the same link more than once in a single issue)
newsletter_links %>% group_by(id) %>% distinct(link) %>% count(id, sort = TRUE)

# Which newsletters _don't_ have links?
newsletters_without_links <- newsletters %>%
  filter(! id %in% (
    newsletter_links %>% count(id) %>% pull(id)
  ))

round((newsletters_without_links %>% nrow()) / (newsletters %>% nrow()), 2)

newsletters_without_links_or_with_only_selflinks <- newsletters %>%
  filter(! id %in% (
    newsletter_links_parsed %>% filter(! domain == "lucascherkewski.com") %>% count(id) %>% pull(id)
  ))

round((newsletters_without_links_or_with_only_selflinks %>% nrow()) / (newsletters %>% nrow()), 2)

# Which links are most common, most repeated?
# (note, we haven’t standardized the URLs, so if sometimes here’s trailing slashes and sometimes not, that’d be the same URL twice)
newsletter_links %>% count(link, sort = TRUE)

# What are the most common domains?
newsletter_links_parsed %>% count(domain, sort = TRUE)

