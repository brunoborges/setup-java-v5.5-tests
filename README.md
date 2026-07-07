# setup-java v5.5 test bed

CI test bed for changes merged into [`actions/setup-java`](https://github.com/actions/setup-java)
**after the v5.4.0 release**. Every workflow pins the action to commit
[`6657b99`](https://github.com/actions/setup-java/commit/6657b993409da921e0c021d82aa9c159601e7a27)
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

Dependency bumps and internal CI/test-only commits from the same range are intentionally
not covered here — they have no user-facing action behavior to exercise.

## Baseline vs current

Each feature workflow (except `verify-signature`, where v5.4.0 simply ignores the unknown
input) contains **two sets of jobs** so you can compare behavior directly in the Actions UI:

- `BASELINE v5.4.0: …` — pinned to [`1bcf9fb`](https://github.com/actions/setup-java/commit/1bcf9fb12cf4aa7d266a90ae39939e61372fe520) (v5.4.0) and asserts the **previous** behavior.
- `CURRENT: …` — pinned to [`6657b99`](https://github.com/actions/setup-java/commit/6657b993409da921e0c021d82aa9c159601e7a27) and asserts the **new** behavior.

Both are expected to pass: together they document exactly what changed.

## Layout

- `.github/workflows/` — one workflow per feature, each running on Ubuntu, Windows and macOS.
- `maven-sample-project/` — a tiny Maven project with one external dependency, used by
  `maven-args.yml` to prove that transfer-progress logs are suppressed by default.

## Running

Push to `main`, open a PR, or trigger any workflow manually via **workflow_dispatch**.
