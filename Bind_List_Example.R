#Grab play by play data for a specific game
#bring in the data
dat <- read_json(paste0("http://site.api.espn.com/apis/site/v2/sports/football/college-football/summary?event=",401110841))


#Pbp Box Score
box <- dat$boxscore

#Two sections in box, teams and players
bt <- box$teams
bp <- box$players

#box teams is a list for each team 
#there are two elements in the team section
# 1 - team info
# 2 - team statistics

#create  data table to house the team info in bt[[1]]$team

team_info = NULL
for(tm in bt){
  each_team = NULL
  each_team = dplyr::bind_cols(each_team, tm$team)
  team_info = dplyr::bind_rows(team_info, each_team)
}

#create  data table to house the team_statistics info in bt[[1]]$team
team_stat_info = NULL
for(tm in bt){
  for(stat in tm$statistics){
    each_stat = NULL
    each_stat = dplyr::bind_cols(each_stat, c(stat, team = tm$team$id))
    team_stat_info = dplyr::bind_rows(team_stat_info, each_stat)
  }
}

#spread to row type table
team_stat_info <- team_stat_info %>%
  select(-label) %>% 
  spread(key = name, value = displayValue)