#!/bin/bash
input=$(cat)

# Extract data from JSON
cwd=$(echo "$input" | jq -r '.workspace.current_dir')
input_tokens=$(echo "$input" | jq -r '.context_window.current_usage.input_tokens // 0')
cache_creation=$(echo "$input" | jq -r '.context_window.current_usage.cache_creation_input_tokens // 0')
cache_read=$(echo "$input" | jq -r '.context_window.current_usage.cache_read_input_tokens // 0')
context_window_size=$(echo "$input" | jq -r '.context_window.context_window_size // empty')
model_name=$(echo "$input" | jq -r '.model.display_name // .model.id // empty')

current_dir=$(basename "$cwd")

# Git branch + dirty status
git_info=""
if git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
    branch=$(git -C "$cwd" --no-optional-locks branch --show-current 2>/dev/null)
    if [ -n "$branch" ]; then
        if [ -n "$(git -C "$cwd" --no-optional-locks status --porcelain 2>/dev/null)" ]; then
            git_info=" git:($branch)✗"
        else
            git_info=" git:($branch)"
        fi
    fi
fi

# Context usage with color coding
context_info=""
ctx_color=""
total_input=$((input_tokens + cache_creation + cache_read))
if [ "$total_input" -gt 0 ] && [ -n "$context_window_size" ] && [ "$context_window_size" -gt 0 ]; then
    input_k=$(( (total_input + 500) / 1000 ))
    window_k=$(( (context_window_size + 500) / 1000 ))
    percentage=$(( (total_input * 100 + context_window_size / 2) / context_window_size ))
    context_info=" ctx:${input_k}k/${window_k}k (${percentage}%)"
    if [ "$percentage" -lt 50 ]; then ctx_color="\033[32m"
    elif [ "$percentage" -lt 80 ]; then ctx_color="\033[33m"
    else ctx_color="\033[31m"; fi
fi

printf "\033[36m%s\033[0m" "$current_dir"
[ -n "$git_info" ] && printf "\033[34m%s\033[0m" "$git_info"
[ -n "$model_name" ] && printf " \033[35m%s\033[0m" "$model_name"
[ -n "$context_info" ] && printf "${ctx_color}%s\033[0m" "$context_info"
