# Claude writes a commit message for the staged changes.
# The editor opens with the message, so nothing is committed without a look.
commit() {
  if git diff --cached --quiet; then
    echo "Nothing staged. Run git add first."
    return 1
  fi

  local msg
  msg=$(git diff --cached | claude -p "Write a short git commit message for this diff. \
Conventional Commits style, imperative mood, subject under 72 chars, optional body. \
Return only the message.") || return 1

  git commit -e -m "$msg"
}

# Undo the last commit but keep the changes staged.
uncommit() {
  git reset --soft HEAD~1
}
