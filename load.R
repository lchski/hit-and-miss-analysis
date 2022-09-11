library(tidyverse)
library(rvest)

newsletters <- tibble(filename = fs::dir_ls("data/source/h-m-html/", recurse = TRUE, glob = "*.html")) %>%
  mutate(
    id = str_remove(filename, fixed("data/source/h-m-html/")),
    id = str_remove(id, fixed("/index.html"))
  ) %>%
  separate(
    id,
    into = c("issue_number"),
    extra = "drop",
    remove = FALSE,
    convert = TRUE
  ) %>%
  arrange(issue_number) %>%
  mutate(html_parsed = map(filename, read_html)) %>%
  select(-filename) %>%
  mutate(text = map_chr(
    html_parsed,
    ~ (.x %>%
         html_element(xpath = "//article/div") %>%
         html_text2()
     )
  ))

newsletter_links <- newsletters %>%
  mutate(link = map(
    html_parsed,
    ~ (.x %>%
         html_elements("article > div a") %>%
         html_attr("href")
     )
  )) %>%
  select(-text, -html_parsed) %>%
  unnest(link)
