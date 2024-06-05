#import "template.typ": *
#show: template.with(
  title: "Lecture 13",
  subtitle: "14.15"
)

= Games

/ Static: Game is played all at once and not over time.
/ Complete Information: There is no unnecessary or private information in a game.

The strategy set $S_i$ describes the set of choices available to the $i$th player. The payoff function $u$ describes the outcome (payoff) for every single possible set of choices amongst the players.

#example(
  title: "Prisoner's Dilemma"
)[
  If both prisoners cooperate, 1 year in prison, 2 if both defect, and 3 if you are the only one not to defect. The sole defector in that case would get 0 years. 

  $
  N = {1, 2}\
  S_1 = S_2 = {C, D}\
  u_1(C, C) = u_2(C, C) = 2\
  u_1(D, D) = u_2(D, D) = 1\
  u_1(C, D) = u_2(D, C) = 0\
  u_1(D, C) = u_2(C, C) = 3\
  $

  We can create a payoff matrix with $x$ being P2, $y$ being P1, and the payoff function $u_1, u_2$ in each cell.
]
