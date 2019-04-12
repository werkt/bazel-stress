Generates a desired number of actions according to a linear noise
shape profile. The generated actions consume a deterministic amount
of cpu time and depend on zero or one targets in order to establish
their position in the overall organization of the build graph.

To generate:

bazel run tools:gen [shamt] [desired_targets] > BUILD

*shamt* is a power-of-2 degree of the linear noise generated. The higher
the *shamt*, the more levels to the graph.

*desired_targets* is a total count of targets that should be generated.
This is desired, not exact, and may shift slightly to ensure no empty
levels.

To exercise:

bazel build :all

Shortest time for a given parameter set wins.

Feel free to use any options you want to improve your score.
