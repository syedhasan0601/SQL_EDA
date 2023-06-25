-- Q1. What are the top 5 players with most player of the match awards
select count(*) as no_of_awards,player_of_match from matches group by player_of_match order by no_of_awards desc LIMIT 5;

-- Q2. HOW MANY MATCHES WERE WON BY EACH TEAM IN EACH SEASON?
select count(*) as matches_won , winner as Teams , season from matches  group by season,winner order by Teams,season;

-- Q3. WHAT IS THE AVERAGE STRIKE RATE OF BATSMEN IN THE IPL DATASET?
select avg(strike_rate) as average_strike_rate from
(select batsman,(sum(total_runs)/count(ball))*100 as strike_rate from deliveries group by batsman) as batsman_stats;

-- Q4.WHAT IS THE NUMBER OF MATCHES WON BY EACH TEAM BATTING FIRST VERSUS BATTING SECOND?
select batting_first,count(*) as matches_won
from(
select case when win_by_runs>0 then team1
else team2
end as batting_first
from matches
where winner!="Tie") as batting_first_teams
group by batting_first; 

-- Q5.WHICH BATSMAN HAS THE HIGHEST STRIKE RATE (MINIMUM 200 RUNS SCORED)?
select batsman,(sum(batsman_runs)*100/count(*))
as strike_rate
from deliveries group by batsman
having sum(batsman_runs)>=200
order by strike_rate desc
limit 1;

-- Q6.HOW MANY TIMES HAS EACH BATSMAN BEEN DISMISSED BY THE BOWLER 'MALINGA'?
select batsman,count(*) as no_of_dismissals from deliveries
where player_dismissed is NOT NULL and bowler = 'SL Malinga' and dismissal_kind not in ('run out','retired hurt') group by batsman;

-- Q7. WHAT IS THE AVERAGE PERCENTAGE OF BOUNDARIES (FOURS AND SIXES COMBINED) HIT BY EACH BATSMAN?
select batsman,avg(case when batsman_runs = 4 or batsman_runs = 6 then 1 else 0 end) * 100 as average_boundaries from deliveries group by batsman;

-- Q8.WHAT IS THE AVERAGE NUMBER OF BOUNDARIES HIT BY EACH TEAM IN EACH SEASON?
select season,batting_team,avg(fours+sixes) as average_boundaries from(select season,match_id,batting_team,
sum(case when batsman_runs=4 then 1 else 0 end)as fours,
sum(case when batsman_runs=6 then 1 else 0 end) as sixes
from deliveries,matches 
where deliveries.match_id=matches.id
group by season,match_id,batting_team) as team_boundaries
group by season,batting_team;

-- Q9. WHAT IS THE HIGHEST PARTNERSHIP (RUNS) FOR EACH TEAM IN EACH SEASON?
select season,batting_team,max(total_runs) as highest_partnership
from(select season,batting_team,partnership,sum(total_runs) as total_runs
from(select season,match_id,batting_team,over_no,
sum(batsman_runs) as partnership,sum(batsman_runs)+sum(extra_runs) as total_runs
from deliveries,matches where deliveries.match_id=matches.id
group by season,match_id,batting_team,over_no) as team_scores
group by season,batting_team,partnership) as highest_partnership
group by season,batting_team; 

-- Q10. HOW MANY EXTRAS (WIDES & NO-BALLS) WERE BOWLED BY EACH TEAM IN EACH MATCH?
select bowling_team as team,sum(extra_runs) as extras from deliveries  group by bowling_team,match_id;

-- Q11.WHICH BOWLER HAS THE BEST BOWLING FIGURES (MOST WICKETS TAKEN) IN A SINGLE MATCH?
select match_id,count(*) as wickets_taken,bowler from deliveries
where player_dismissed is NOT NULL and dismissal_kind not in ('run out','retired hurt') 
group by bowler,match_id order by wickets_taken desc limit 1;

-- Q12. HOW MANY MATCHES RESULTED IN A WIN FOR EACH TEAM IN EACH CITY?
select m.city,
	case 
		when m.team1=m.winner then m.team1
		when m.team2=m.winner then m.team2
		else 'draw'
	end as winning_team,
count(*) as wins
from matches as m
where m.result!='Tie'
group by m.city,winning_team
order by winning_team , wins desc;

-- Q13.HOW MANY TIMES DID EACH TEAM WIN THE TOSS IN EACH SEASON?
select season,toss_winner,count(*) as toss_wins from matches group by season,toss_winner;

-- Q14.HOW MANY MATCHES DID EACH PLAYER WIN THE "PLAYER OF THE MATCH" AWARD?
select player_of_match as player,count(*) as no_of_times from matches group by player_of_match order by no_of_times desc;  

-- Q15.WHAT IS THE AVERAGE NUMBER OF RUNS SCORED IN EACH OVER OF THE INNINGS IN EACH MATCH?
select match_id as id,inning,over_no,avg(total_runs) as avg_runs from deliveries group by match_id,inning,over_no;

-- Q16.WHICH TEAM HAS THE HIGHEST TOTAL SCORE IN A SINGLE MATCH?
select match_id ,batting_team as team,sum(total_runs) as runs from deliveries group by match_id,team order by runs desc limit 1;

-- Q17.WHICH BATSMAN HAS SCORED THE MOST RUNS IN A SINGLE MATCH?
select match_id ,batsman,sum(batsman_runs) as runs from deliveries group by match_id,batsman order by runs desc limit 1;

