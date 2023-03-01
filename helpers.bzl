load(
    "@com_github_buildbuddy_io_rules_xcodeproj//xcodeproj:defs.bzl",
    "project_options",
    "top_level_target",
    "xcode_schemes",
    _rules_xcodeproj = "xcodeproj",
)

def xcodeproj(name, deps, **kwargs):
    _rules_xcodeproj(
        name = name,
        project_name = name,
        project_options = project_options(
            indent_width = 2,
            tab_width = 2,
            uses_tabs = False,
        ),
        scheme_autogeneration_mode = "none",
        schemes = [rules_xcodeproj_scheme(target) for target in deps],
        top_level_targets = [
            top_level_target(
                target,
                target_environments = ["simulator"],
            )
            for target in deps
        ],
    )

def rules_xcodeproj_scheme(target):
    target_label = Label(target)

    # Roughly try to find if this target is a test.
    test_target = None
    if target_label.name.endswith("Tests"):
        test_target = target

    return xcode_schemes.scheme(
        name = target_label.name,
        build_action = xcode_schemes.build_action(
            targets = [target],
        ),
        launch_action = None,
        test_action = xcode_schemes.test_action(
            env = {
                "IS_EXECUTING_TEST": "1",
            },
            targets = [test_target],
        ) if test_target else None,
    )
