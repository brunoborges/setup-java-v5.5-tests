#!/usr/bin/env bash
# Probe the local Maven repository for the maven-shade-plugin dependency set that
# actions/setup-java#990 is about. Prints a presence table and exits:
#   0  -> all probed artifacts are present (issue NOT reproduced)
#   1  -> at least one probed artifact is missing (issue reproduced)
set -uo pipefail

label="${1:-probe}"
repo="${HOME}/.m2/repository"

# groupId/artifactId paths of the distinctive shade-plugin dependency set.
artifacts=(
  "org/codehaus/plexus/plexus-archiver"
  "org/apache/commons/commons-compress"
  "io/airlift/aircompressor"
  "org/tukaani/xz"
)

echo "==================== probe-m2: ${label} ===================="
echo "repo: ${repo}"
missing=0
for a in "${artifacts[@]}"; do
  dir="${repo}/${a}"
  count=0
  if [ -d "${dir}" ]; then
    count=$(find "${dir}" -name '*.jar' -type f 2>/dev/null | wc -l | tr -d ' ')
  fi
  if [ "${count}" -gt 0 ]; then
    printf '  [present] %-40s (%s jar(s))\n' "${a}" "${count}"
  else
    printf '  [MISSING] %-40s\n' "${a}"
    missing=1
  fi
done
echo "-----------------------------------------------------------"
if [ "${missing}" -eq 0 ]; then
  echo "result: ALL PRESENT"
else
  echo "result: SOME MISSING"
fi
echo "==========================================================="
exit "${missing}"
