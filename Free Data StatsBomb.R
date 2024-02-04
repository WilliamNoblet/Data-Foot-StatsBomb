


if (!require("dplyr")) install.packages("dplyr")
library(dplyr)
if (!require("plotly")) install.packages("plotly")
library(plotly)
if (!require("openxlsx")) install.packages("openxlsx")
library(openxlsx)
library(StatsBombR)

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

Matches <- separate(
  Matches,
  away_team.managers,
  into = c("away_team.managers.id", "away_team.managers.name", "away_team.managers.nickname", 
           "away_team.managers.dob", "away_team.managers.country.id", "away_team.managers.country.name"),
  sep = ","
)

Matches <- separate(
  Matches,
  home_team.managers,
  into = c("home_team.managers.id", "home_team.managers.name", "home_team.managers.nickname", 
           "home_team.managers.dob", "home_team.managers.country.id", "home_team.managers.country.name"),
  sep = ","
)



library(stringr)


Matches$away_team.managers.id <- stringr::str_replace_all(Matches$away_team.managers.id, 'list\\(id = ', '')

Matches$away_team.managers.name <- stringr::str_replace_all(Matches$away_team.managers.name, 'name = ', '')
Matches$away_team.managers.name <- stringr::str_replace_all(Matches$away_team.managers.name, '"', '')

Matches$away_team.managers.nickname <- stringr::str_replace_all(Matches$away_team.managers.nickname, 'nickname = ', '')
Matches$away_team.managers.nickname <- stringr::str_replace_all(Matches$away_team.managers.nickname, '"', '')

Matches$away_team.managers.dob <- stringr::str_replace_all(Matches$away_team.managers.dob, 'dob = ', '')
Matches$away_team.managers.dob <- stringr::str_replace_all(Matches$away_team.managers.dob, '"', '')

Matches$away_team.managers.country.id <- stringr::str_replace_all(Matches$away_team.managers.country.id, 'country.id = ', '')

Matches$away_team.managers.country.name <- stringr::str_replace_all(Matches$away_team.managers.country.name, 'country.name = ', '')
Matches$away_team.managers.country.name <- stringr::str_replace_all(Matches$away_team.managers.country.name, '"', '')
Matches$away_team.managers.country.name <- stringr::str_replace_all(Matches$away_team.managers.country.name, '\\)', '')



Matches$home_team.managers.id <- stringr::str_replace_all(Matches$home_team.managers.id, 'list\\(id = ', '')

Matches$home_team.managers.name <- stringr::str_replace_all(Matches$home_team.managers.name, 'name = ', '')
Matches$home_team.managers.name <- stringr::str_replace_all(Matches$home_team.managers.name, '"', '')

Matches$home_team.managers.nickname <- stringr::str_replace_all(Matches$home_team.managers.nickname, 'nickname = ', '')
Matches$home_team.managers.nickname <- stringr::str_replace_all(Matches$home_team.managers.nickname, '"', '')

Matches$home_team.managers.dob <- stringr::str_replace_all(Matches$home_team.managers.dob, 'dob = ', '')
Matches$home_team.managers.dob <- stringr::str_replace_all(Matches$home_team.managers.dob, '"', '')

Matches$home_team.managers.country.id <- stringr::str_replace_all(Matches$home_team.managers.country.id, 'country.id = ', '')

Matches$home_team.managers.country.name <- stringr::str_replace_all(Matches$home_team.managers.country.name, 'country.name = "', '')
Matches$home_team.managers.country.name <- stringr::str_replace_all(Matches$home_team.managers.country.name, '"', '')
Matches$home_team.managers.country.name <- stringr::str_replace_all(Matches$home_team.managers.country.name, '\\)', '')



print(Matches)

#Save the events database in Excel in xlsx format
write.xlsx(Matches, 'Free_Matches_WC_2022.xlsx')




filtered_data <- StatsBombData[is.null(StatsBombData$tactics.lineup) | sapply(StatsBombData$tactics.lineup, is.null), ]


is.null(StatsBombData$tactics.lineup[[3]]) == TRUE

filtered_data <- StatsBombData %>%
  dplyr::filter(is.null(tactics.lineup) == TRUE)



type.name <- StatsBombData %>% dplyr::select(type.name) %>% distinct()


MatchesEvents <- StatsBombData %>% 
  dplyr::filter(!(type.name == 'Starting XI' | type.name == 'Tactical Shift')) %>%
  dplyr::select(-tactics.lineup)


write.xlsx(MatchesEvents, 'Matches_Events_WC_2022.xlsx')
