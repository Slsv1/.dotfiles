#!/bin/bash
set -x
set -euo pipefail

cd "$1" || exit 1
SESSION="py"

wait_for_window() {
    local session="$1"
    local window="$2"
    for _ in {1..10}; do
        if tmux list-windows -t "$session" | grep -q "$window"; then
            return 0
        fi
        sleep 0.1
    done
    echo "Window $window in session $session not found."
    exit 1
}

if [ -z "${TMUX:-}" ]; then
    # Start new detached session with first window named 'edit'
    tmux new-session -d -s "$SESSION" -n edit
    tmux new-window -t "$SESSION:" -n terminal
else
    # Already inside tmux; create new windows in the current session
    CURRENT_SESSION=$(tmux display-message -p '#S')
    tmux new-window -t "$CURRENT_SESSION:" -n edit
    tmux new-window -t "$CURRENT_SESSION:" -n terminal
    SESSION="$CURRENT_SESSION"
fi

wait_for_window "$SESSION" "terminal"
wait_for_window "$SESSION" "edit"

tmux send-keys -t "$SESSION:terminal" "source .venv/bin/activate" C-m
tmux send-keys -t "$SESSION:edit" "source .venv/bin/activate" C-m

tmux send-keys -t "$SESSION:edit" "nvim ." C-m
tmux select-window -t "$SESSION:edit"

if [ -z "${TMUX:-}" ]; then
    tmux attach-session -t "$SESSION"
fi

