load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    patches = ["//third_party:rules_ruby.patch"],
    name = "com_github_yugui_rules_ruby",
    sha256 = "868f7f7ff48af995ca5197a981baef717315e44b2ca0d52f01c2ccf50f3b9f33",
    strip_prefix = "rules_ruby-7771813c532e51367e25f9b3928822aad06d2183",
    url = "https://github.com/yugui/rules_ruby/archive/7771813c532e51367e25f9b3928822aad06d2183.zip",
)

load("@com_github_yugui_rules_ruby//ruby:def.bzl", "ruby_register_toolchains")

ruby_register_toolchains()
