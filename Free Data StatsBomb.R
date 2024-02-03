


if (!require("dplyr")) install.packages("dplyr")
library(dplyr)
if (!require("plotly")) install.packages("plotly")
library(plotly)

FreeCompetitions <- FreeCompetitions()

Comp <- FreeCompetitions() %>%
  dplyr::filter(country_name == 'International' 
                & competition_name == 'FIFA World Cup'
                & season_name == '2022')

Matches <- FreeMatches(Comp)

StatsBombData <- get.matchFree(Matches[1,])

for(i in seq(from = 2, to = nrow(Matches))){
  StatsBombData <- dplyr::bind_rows(StatsBombData, get.matchFree(Matches[i,]))
}

StatsBombData = allclean(StatsBombData)
StatsBombData = cleanlocations(StatsBombData)


#Save the events database in Excel in xlsx format








