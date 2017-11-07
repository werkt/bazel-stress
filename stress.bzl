def _remote_ex_rule(ctx):
    ctx.actions.run(
        inputs = ctx.files.deps,
        outputs = [ctx.outputs.txt],
        executable = ctx.executable._ex,
        arguments = [str(ctx.attr.usecs), ctx.outputs.txt.path],
    )
    
remote_ex_rule = rule(
    implementation = _remote_ex_rule,
    attrs = {
        "deps": attr.label_list(),
        "usecs": attr.int(mandatory=True),
        "_ex": attr.label(default="//tools:ex", executable=True, cfg="host"),
    },
    outputs = {
        "txt": "%{name}.txt",
    }
)
