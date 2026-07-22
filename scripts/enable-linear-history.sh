#!/usr/bin/env bash
# Configure this GitHub repository for strict linear history on main.
# Run as the repo owner (or an admin):  ./scripts/enable-linear-history.sh
set -euo pipefail

REPO="${1:-iqbalmuddassir/bookish-pancake}"

echo "Disabling merge commits; keeping squash + rebase merges on ${REPO}..."
gh api "repos/${REPO}" -X PATCH \
  -f allow_merge_commit=false \
  -f allow_squash_merge=true \
  -f allow_rebase_merge=true \
  -f delete_branch_on_merge=true \
  --jq '{allow_merge_commit, allow_squash_merge, allow_rebase_merge, delete_branch_on_merge}'

echo "Creating/ensuring ruleset: Require linear history on main..."
EXISTING_ID="$(gh api "repos/${REPO}/rulesets" --jq '.[] | select(.name=="Require linear history on main") | .id' | head -n1 || true)"

PAYLOAD='{
  "name": "Require linear history on main",
  "target": "branch",
  "enforcement": "active",
  "conditions": {
    "ref_name": {
      "include": ["refs/heads/main"],
      "exclude": []
    }
  },
  "rules": [
    { "type": "required_linear_history" }
  ]
}'

if [ -n "${EXISTING_ID}" ]; then
  gh api "repos/${REPO}/rulesets/${EXISTING_ID}" -X PUT --input - <<<"${PAYLOAD}" \
    --jq '{id, name, enforcement, rules}'
else
  gh api "repos/${REPO}/rulesets" -X POST --input - <<<"${PAYLOAD}" \
    --jq '{id, name, enforcement, rules}'
fi

echo "Done. Merge via Squash or Rebase only; merge commits to main are blocked."
