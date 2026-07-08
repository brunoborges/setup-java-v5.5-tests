# setup-java v5.5 test bed

CI test bed for changes merged into [`actions/setup-java`](https://github.com/actions/setup-java)
**after the v5.4.0 release**. Every workflow pins the action to commit
[`0f481fc`](https://github.com/actions/setup-java/commit/0f481fcb613427c0f801b606911222b5b6f3083a)
(the tip of `main`) so the exact code under test is unambiguous.

## What changed since v5.4.0

| PR | Change | Workflow | Baseline (v5.4.0) job |
|----|--------|----------|-----------------------|
| [#672](https://github.com/actions/setup-java/pull/672) | New **Tencent Kona JDK** distribution (`distribution: kona`) | [`kona.yml`](.github/workflows/kona.yml) | ✅ asserts v5.4.0 rejects `kona` |
| [#1060](https://github.com/actions/setup-java/pull/1060) | **`verify-signature`** input (GPG verification for Temurin & Microsoft) | [`verify-signature.yml`](.github/workflows/verify-signature.yml) | — (input silently ignored by v5.4.0) |
| [#1053](https://github.com/actions/setup-java/pull/1053) | **`show-download-progress`** input → `-ntp` in `MAVEN_ARGS` | [`maven-args.yml`](.github/workflows/maven-args.yml) | ✅ asserts v5.4.0 sets no `-ntp` |
| [#1052](https://github.com/actions/setup-java/pull/1052) | `settings.xml` now sets **`interactiveMode=false`** | [`settings-interactive-mode.yml`](.github/workflows/settings-interactive-mode.yml) | ✅ asserts v5.4.0 has no `interactiveMode` |
| [#534](https://github.com/actions/setup-java/pull/534) | Fix: **Maven toolchains grows unexpectedly** on repeated runs | [`toolchains.yml`](.github/workflows/toolchains.yml) | ✅ asserts v5.4.0 duplicates a re-run id |
| [#1017](https://github.com/actions/setup-java/pull/1017) | New **`set-default`** input (install a JDK without changing `JAVA_HOME`) | [`set-default.yml`](.github/workflows/set-default.yml) | ✅ asserts v5.4.0 ignores it (JDK becomes default) |
| [#975](https://github.com/actions/setup-java/pull/975) | **`.sdkmanrc` distribution auto-detect** (`java=21.0.5-tem` → temurin; `distribution` optional) | [`sdkmanrc-distribution.yml`](.github/workflows/sdkmanrc-distribution.yml) | ✅ asserts v5.4.0 still requires `distribution` |

Dependency bumps and internal CI/test-only commits from the same range are intentionally
not covered here — they have no user-facing action behavior to exercise.

## Baseline vs current

Each feature workflow (except `verify-signature`, where v5.4.0 simply ignores the unknown
input) contains **two sets of jobs** so you can compare behavior directly in the Actions UI:

- `BASELINE v5.4.0: …` — pinned to [`1bcf9fb`](https://github.com/actions/setup-java/commit/1bcf9fb12cf4aa7d266a90ae39939e61372fe520) (v5.4.0) and asserts the **previous** behavior.
- `CURRENT: …` — pinned to [`0f481fc`](https://github.com/actions/setup-java/commit/0f481fcb613427c0f801b606911222b5b6f3083a) and asserts the **new** behavior.

Both are expected to pass: together they document exactly what changed.

## Layout

- `.github/workflows/` — one workflow per feature, each running on Ubuntu, Windows and macOS.
- `maven-sample-project/` — a tiny Maven project with one external dependency, used by
  `maven-args.yml` to prove that transfer-progress logs are suppressed by default.
- `javac-matcher/` — standalone `.java` sources (warnings + errors) compiled directly with
  `javac` by `javac-problem-matcher.yml`.
- `javac-matcher-maven/` / `javac-matcher-gradle/` — the same warning/error sources built
  through Maven and Gradle, used by `javac-matcher-build-tools.yml` (below).

## javac problem matcher vs build tools

The `javac` problem matcher registered by setup-java only understands javac's **native**
diagnostic format (`File.java:12: warning|error: message`). Whether your build gets
annotated therefore depends on the build tool:

| Build tool | Compiler output | Matched by `javac` matcher? |
|------------|-----------------|-----------------------------|
| Direct `javac` | `File.java:12: warning: …` | ✅ annotated |
| **Gradle** | `File.java:12: warning: …` (passed through) | ✅ annotated |
| **Maven** (compiler plugin) | `[WARNING] /path/File.java:[12,5] …` | ❌ not annotated |

[`javac-matcher-build-tools.yml`](.github/workflows/javac-matcher-build-tools.yml) proves
this by capturing each build log and asserting the number of matcher-format lines (0 for
Maven, >0 for Gradle) — so it fails loudly if the behavior ever changes.

## Running


Push to `main`, open a PR, or trigger any workflow manually via **workflow_dispatch**.
