# ALCops Migration

## Initial Situation

The repository did not contain a versioned installation or configuration of
`BusinessCentral.LinterCop`. The initial compiler baseline was:

| Diagnostic | Count |
| --- | ---: |
| AL errors | 0 |
| AL0472 | 69 |
| AL1025 | 1 |
| LCxxxx | 0 |

No ruleset is used in this phase. No AL source, pragma, dependency, runtime, or
`app.json` setting is changed.

## Installed Version

This repository pins `ALCops.Analyzers` to version `1.1.0`. The installed AL
Language extension is version `17.0.2273547`, so the restore script selects the
`net8.0` analyzer binaries, as required by ALCops for AL Language 16.0 and later.

## Restore Procedure

Run the following command from the repository root:

```powershell
./scripts/Restore-ALCops.ps1
```

Use `-Force` to replace an existing generated `.alcops` directory:

```powershell
./scripts/Restore-ALCops.ps1 -Force
```

The script downloads the official NuGet package, extracts the `lib/net8.0`
contents into `.alcops/`, copies the matching compiler dependency
`Microsoft.Dynamics.Nav.Analyzers.Common.dll`, and records the restored version.
By default it detects that dependency from the installed AL Language extension;
the version is pinned to `17.0.2273547`, matching this project. In a
non-standard environment, pass `-CompilerPath <compiler-extension-folder>`. The
generated folder is ignored by Git. It can be restored from a clean clone without
user-specific paths.

## Enabled Analyzers

`.vscode/settings.json` loads these ALCops analyzers through workspace-relative
paths:

- `ALCops.Common.dll` (runtime dependency)
- `Microsoft.Dynamics.Nav.Analyzers.Common.dll` (AL compiler dependency)
- `ALCops.ApplicationCop.dll`
- `ALCops.LinterCop.dll`
- `ALCops.PlatformCop.dll`

DocumentationCop, FormattingCop, and TestAutomationCop remain disabled to avoid
unrelated diagnostic volume during this initial rollout.

## Compilation Procedure

Restore ALCops first, then compile with the local AL compiler and pass the same
three DLLs to `/analyzer`. Capture diagnostics with `/errorlog` to compare the
compiler warnings and each ALCops family without suppressions.

## Result After Installation

The verification used AL Compiler `17.0.34.45391` and the restored ALCops DLLs.
No analyzer loading failures occurred.

| Diagnostic | Before | After |
| --- | ---: | ---: |
| AL errors | 0 | 3 |
| AL0472 | 69 | 69 |
| AL1025 | 1 | 0 |
| ApplicationCop | 0 | 2731 |
| ALCops LinterCop | 0 | 2463 |
| PlatformCop | 0 | 1618 |

The three errors are PlatformCop diagnostics, not compiler errors from the AL
language itself: `PC0008` occurs once and `PC0013` occurs twice. They are
intentionally left unmodified in this infrastructure-only phase.

## Manual Actions

No global VS Code configuration was changed. If a developer later configures
`BusinessCentral.LinterCop` in user or profile settings, remove it before opening
this workspace so that only `ALCops.LinterCop.dll` is loaded.

## CI/CD Preparation

The restore script is self-contained and can be reused by a future Azure DevOps
pipeline before the AL compilation step. This phase intentionally does not add or
change pipeline configuration.

## Phase 1.1 Compilation Recovery

Phase 1.1 corrected only the three PlatformCop diagnostics reported as errors:

- `PC0008`: the Financial Flow snapshot filter now uses `StrSubstNo` before it
  is passed to `SetFilter`.
- `PC0013`: the install codeunit explicitly supplies a `Code[10]` report
  selection sequence.
- `PC0013`: the incident factbox validates and converts its filter to `Guid`
  before calling `Get`.

The verification run completed with zero errors, zero `PC0008`, zero `PC0013`,
and generated the application package. The full inventory of the 270 AL files
under `.vscode` is recorded in `docs/Vscode-AL-Inventory.md`; two test objects
are candidates for a future dedicated test app, while the remaining objects
currently compile as product code.
