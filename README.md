# setup-java v5.5 test bed

CI test bed for changes merged into [`actions/setup-java`](https://github.com/actions/setup-java)
**after the v5.4.0 release**. Every workflow pins the action to commit
[`a50fdcc`](https://github.com/actions/setup-java/commit/a50fdccef19f861401a6f00b7caa2abf98504acb)
(the tip of `main` at the time this repo was created) so the exact code under test is unambiguous.

## What changed since v5.4.0

| PR | Change | Workflow |
|----|--------|----------|
| [#672](https://github.com/actions/setup-java/pull/672) | New **Tencent Kona JDK** distribution (`distribution: kona`) | [`kona.yml`](.github/workflows/kona.yml) |
| [#1060](https://github.com/actions/setup-java/pull/1060) | **`verify-signature`** input (GPG verification for Temurin & Microsoft) | [`verify-signature.yml`](.github/workflows/verify-signature.yml) |
| [#1053](https://github.com/actions/setup-java/pull/1053) | **`show-download-progress`** input → `-ntp` in `MAVEN_ARGS` | [`maven-args.yml`](.github/workflows/maven-args.yml) |
| [#1052](https://github.com/actions/setup-java/pull/1052) | `settings.xml` now sets **`interactiveMode=false`** | [`settings-interactive-mode.yml`](.github/workflows/settings-interactive-mode.yml) |
| [#534](https://github.com/actions/setup-java/pull/534) | Fix: **Maven toolchains grows unexpectedly** on repeated runs | [`toolchains.yml`](.github/workflows/toolchains.yml) |

Dependency bumps and internal CI/test-only commits from the same range are intentionally
not covered here — they have no user-facing action behavior to exercise.

## Layout

- `.github/workflows/` — one workflow per feature, each running on Ubuntu, Windows and macOS.
- `maven-sample-project/` — a tiny Maven project with one external dependency, used by
  `maven-args.yml` to prove that transfer-progress logs are suppressed by default.

## Running

Push to `main`, open a PR, or trigger any workflow manually via **workflow_dispatch**.
