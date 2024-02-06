# Database Fundamentals
## Football League Project
### Task
Design a relational database for a football league system. The database should store information about teams, players, matches, goals, and standings. 

### Description
A football league system is a hierarchy of leagues that compete in the same sport. Each league has a number of teams that play against each other in a round-robin format. The teams are ranked by points, goal difference, and goals scored. The top teams of each league may be promoted to a higher league, while the bottom teams may be relegated to a lower league. 

### Tables
* **Team:** This table stores information about each team in the league system, such as name, city, stadium, and manager.
* **Player:** This table stores information about each player who belongs to one or more teams in the league system, such as name, date of birth, nationality, position, and number. 
* **Match:** This table stores information about each match that is played between two teams in the league system, such as match, date, time, venue, home team, away team, home score, and away score.
* **Goal:** This table stores information about each goal that is scored in a match (match, player, team, and time). 
* **Standing:** This table stores information about the current ranking of each team in each league, team, position, points, played, won, drawn, lost, goals for, goals against, and goal difference.

### Management system
https://lucid.app/lucidchart/c5c0fea7-b658-4cc9-a18e-8bec70abfe1c/edit?viewport_loc=-1892%2C315%2C1652%2C991%2C0_0&invitationId=inv_43af4491-5099-4d08-92c4-532ad585d965
