library(dash)
library(dashBootstrapComponents)
library(ggplot2)
library(plotly)
library(tidyr)

app <- Dash$new(external_stylesheets = dbcThemes$BOOTSTRAP)

df <- readr::read_csv(here::here("data", "raw", "world-data-gapminder_raw.csv"))
# df_non_na <- df %>%
#     mutate(
#         across(everything(), ~ replace_na(.x, 0))
#     ) 

df[is.na(df)] <- 0
# print(df)

df_subregion_year <- df %>%
  group_by(sub_region, year) %>%
  summarise(mean_life_expectancy = mean(life_expectancy))

df_year_region <- df %>%
  group_by(year, region) %>%
  summarise(sum_co2_per_capita = sum(co2_per_capita))

app$layout(
  div(
    list(
      dbcRow(className = "text-center bg-warning",
             list(
               h1("Gapminder Challenge"),
               p(
                 paste(
                   "Take the challenges below to see how you understand global issues such as healthcare and finance development."
                 )
               ),
               p(
                 paste(
                   "Test yourselves now!"
                 )
               )
             )
      ),
      dbcRow(
        list(
          dbcCol(dbcCard(className = "m-3 p-3", div(
            "Card 1"
          )),
          md = 6
          ),
          dbcCol(
            dbcCard(className = "m-3 p-3", div(
              "Card 2"
            )),
            md = 6
          )
        )
      ),
      dbcRow(
        list(
          dbcCol(dbcCard(className = "m-3 p-3", 
                         list(
                           dccGraph(id = "line_chart_3"),
                           dccRangeSlider(
                             id = "slider_3",
                             min = 1918,
                             max = 2018,
                             step = 10,
                             marks = list(
                               "1918" = "1918",
                               "1928" = "1928",
                               "1938" = "1938",
                               "1948" = "1948",
                               "1958" = "1958",
                               "1968" = "1968",
                               "1978" = "1978",
                               "1988" = "1988",
                               "1998" = "1998",
                               "2008" = "2008",
                               "2018" = "2018"
                             ),
                             value = list(1938, 2018)
                           ),
                           dccDropdown(
                             id = "dropdown_3",
                             options = unique(df_subregion_year$sub_region),
                             value = unique(df_subregion_year$sub_region)[15],
                             multi = TRUE
                           )
                         )
          ),
          md = 6
          ),
          dbcCol(dbcCard(className = "m-3 p-3",div(
            "Card 4"
          )), md = 6)
        )
      )
    )
  )
)

# app$callback(
#   output("bar_chart", "figure"),
#   list(
#     input("slider", "value"),
#     input("dropdown", "value")

app$callback(
  output("line_chart_3", "figure"),
  list(
    input("slider_3", "value"),
    input("dropdown_3", "value")
  ),
  function(selected_year, selected_regions) {
    title_text = paste0("Mean Life Expectancy from ",
                        as.character(selected_year[1]),
                        " to ",
                        as.character(selected_year[2]))
    p <- ggplot(df_subregion_year %>%
                  filter(year >= selected_year[1], year <= selected_year[2],
                         sub_region %in% selected_regions)) +
      aes(y = mean_life_expectancy,
          x = year, color = sub_region) +
      geom_line() +
      labs(x = "Year", y = "Mean Life Expectancy") +
      theme_bw(base_size = 13) +
      ggtitle(title_text)
    ggplotly(p) %>% layout()
  }
)


app$run_server(host = "0.0.0.0")