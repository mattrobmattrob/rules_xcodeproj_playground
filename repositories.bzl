load(
    "@bazel_tools//tools/build_defs/repo:http.bzl",
    "http_archive",
)
load(
    "@bazel_tools//tools/build_defs/repo:git.bzl",
    "git_repository",
)

def _github_archive(name, path, commit, sha256, **kwargs):
    """
    Wraps an archive fetch from GitHub.
    """
    [org, repo] = path.split("/", 2)

    http_archive(
        name = name,
        sha256 = sha256,
        urls = [
            "https://github.com/" + path + "/archive/" + commit + ".tar.gz",
        ],
        strip_prefix = repo + "-" + commit,
        **kwargs
    )

def workspace_dependencies():
    _github_archive(
        name = "xctestrunner",
        path = "reddit/xctestrunner",
        # master + fixups, as of 2023-02-21
        commit = "3ec25f572c091b7111b7d351f9328fa67468baf5",
        sha256 = "f66233a3b40e78d2d0e33c937c8147ff6b2553d82284376700b9630d9672d31e",
    )

    # rules_swift (relying on @build_bazel_rules_apple as provider for now)
    # git_repository(
    #     name = "build_bazel_rules_swift",
    #     # v1.5.1 of bazelbuild/rules_swift as of 2023-01-10
    #     commit = "ba9397c518139619ab0a1ae32ce574ce2bb1e463",
    #     remote = "https://github.com/bazelbuild/rules_swift",
    #     shallow_since = "1673032754 -0600",
    # )

    # rules_apple
    _github_archive(
        name = "build_bazel_rules_apple",
        path = "bazelbuild/rules_apple",
        # master, as of 2023-02-21
        commit = "2fb221631dec5dfbbe650bd8a614237eb46cb7db",
        sha256 = "2e68d159b783046c497979a0275cea8ce7720b4cbf3db17f4e0de9586b27082a",
    )

    # rules_ios
    git_repository(
        name = "build_bazel_rules_ios",
        # master, as of 2023-02-09
        commit = "ea40a7b13dd1a29a454de2268a3799a65907501a",
        remote = "https://github.com/bazel-ios/rules_ios.git",
        shallow_since = "1675903550 +0000",
    )

    # rules_xcodeproj
    _github_archive(
        name = "rules_xcodeproj",
        path = "buildbuddy-io/rules_xcodeproj",
        # main, as of 2023-03-20
        commit = "047775d86a0db85e821bbbe1bd4d5ca1cba8fabc",
        sha256 = "",
    )
