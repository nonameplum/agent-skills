#!/usr/bin/env bash
set -euo pipefail

source_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

targets=(
  "$HOME/.codex/skills"
  "$HOME/.cursor/skills"
  "$HOME/.claude/skills"
)
target_counts=(0 0 0)
created_counts=(0 0 0)
replaced_counts=(0 0 0)

if command -v rsync >/dev/null 2>&1; then
  copy_dir() {
    local from_dir="$1"
    local to_dir="$2"
    rsync -a "$from_dir"/ "$to_dir"/
  }
else
  copy_dir() {
    local from_dir="$1"
    local to_dir="$2"
    mkdir -p "$to_dir"
    cp -R "$from_dir"/. "$to_dir"/
  }
fi

has_skills=false
has_targets=false

index_for_target() {
  local target="$1"
  local index=0
  for candidate in "${targets[@]}"; do
    if [ "$candidate" = "$target" ]; then
      echo "$index"
      return 0
    fi
    index=$((index + 1))
  done
  return 1
}

for manifest in "$source_root"/*/SKILL.md; do
  if [ -f "$manifest" ]; then
    has_skills=true
    skill_dir="$(dirname "$manifest")"
    skill_name="$(basename "$skill_dir")"
    for target in "${targets[@]}"; do
      if [ -d "$target" ]; then
        has_targets=true
        destination="$target/$skill_name"
        target_index="$(index_for_target "$target")"
        if [ "${target_counts[$target_index]}" -eq 0 ]; then
          echo "==> $target"
        fi
        if [ -d "$destination" ]; then
          action="replaced"
          replaced_counts[$target_index]=$((replaced_counts[$target_index] + 1))
        else
          action="created"
          created_counts[$target_index]=$((created_counts[$target_index] + 1))
        fi
        copy_dir "$skill_dir" "$destination"
        echo "  - $skill_name ($action)"
        target_counts[$target_index]=$((target_counts[$target_index] + 1))
      fi
    done
  fi
done

if [ "$has_skills" = false ]; then
  echo "No skill folders with SKILL.md found in $source_root" >&2
fi

if [ "$has_targets" = false ]; then
  echo "No target skill directories exist." >&2
fi

index=0
for target in "${targets[@]}"; do
  count="${target_counts[$index]}"
  if [ -d "$target" ] && [ "$count" -gt 0 ]; then
    echo "----"
    echo "Summary: $target"
    echo "  - Created: ${created_counts[$index]}"
    echo "  - Replaced: ${replaced_counts[$index]}"
  fi
  index=$((index + 1))
done
