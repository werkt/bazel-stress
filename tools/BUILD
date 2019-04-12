load("@com_github_yugui_rules_ruby//ruby:def.bzl", "ruby_binary")

cc_binary(
  name = "ex",
  srcs = ["ex.c"],
  visibility = ["//visibility:public"],
)

ruby_binary(
  name = "gen",
  srcs = ["gen.rb"],
  visibility = ["//visibility:public"],
  data = ["package.erb", "target.erb"],
)
