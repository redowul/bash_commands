#!/bin/bash
REPO=temp
git init $REPO
cd $REPO

# Holidays (YYYY-MM-DD)
declare -a holidays=("2018-07-04", "2018-12-25", "2019-01-01", "2019-07-04", "2019-12-25", "2020-01-01", "2020-07-04", "2020-12-25", "2021-01-01", "2021-07-04", "2021-12-25", "2022-01-01", "2022-07-04", "2022-12-25", "2023-01-01", "2023-07-04")

# Check if a date is a holiday
function is_holiday {
    local check_date=$1
    for holiday in "${holidays[@]}"
    do
        if [[ "$check_date" == "$holiday" ]]; then
            echo "1"
            return
        fi
    done
    echo "0"
}

# Check if a date is in summer (from May 15th to September 14th)
function is_summer {
    local check_date=$1
    local month=$(date -d "$check_date" '+%m')
    local day=$(date -d "$check_date" '+%d')
    
    if [[ $month -ge 5 && $month -le 9 ]]; then
        if [[ $month -eq 5 && $day -lt 15 ]]; then
            echo "0"
        elif [[ $month -eq 9 && $day -gt 14 ]]; then
            echo "0"
        else
            echo "1"
        fi
    else
        echo "0"
    fi
}

# Generate weighted random number for daily commits
function weighted_random {
    local -a weights_before_2020=(90 10 0 0 0 0)
    local -a weights_after_2020=(60 30 7 2 1 0)
    local -a elements=(1 2 3 4 5 6)
    local rnd_num
    local weight
    local idx
    local -a weights

    if [ "$1" < "2020-01-01" ]; then
        weights=("${weights_before_2020[@]}")
    else
        weights=("${weights_after_2020[@]}")
    fi

    local sum_of_weights=0
    for weight in "${weights[@]}"; do
        let "sum_of_weights += weight"
    done

    rnd_num=$((RANDOM % sum_of_weights))

    for idx in "${!weights[@]}"; do
        weight=${weights[idx]}
        if ((rnd_num < weight)); then
            echo ${elements[idx]}
            break
        fi
        let "rnd_num -= weight"
    done
}

start_date="2018-01-20"
end_date="2023-07-01"

d="$start_date"
while [ "$d" != "$end_date" ]; do 
    day_of_week=$(date -d "$d" '+%u')
    if [[ $(is_holiday $d) == "0" ]] && ((day_of_week != 6)) && ((day_of_week != 7)); then
        if [[ $d < "2020-01-01" && $(is_summer $d) == "1" ]]; then
            # Sparse commits in summer
            if ((RANDOM % 10 < 2)); then
        # Skip this day with no commits
        continue
    fi
    
    num_commits=$(weighted_random $d)
    for j in $(seq 1 $num_commits)
    do
        hour=$(printf "%02d" $(( RANDOM % 10 + 8 )))
        echo "$d-$j" > file.txt
        git add file.txt
        GIT_COMMITTER_DATE="$d $hour:00:00" git commit --date="$d $hour:00:00" -m "POC commit number $j on $d at $hour:00:00"
    done

    d=$(date -I -d "$d + 1 day")
done




#bash
#Copy code
#git commit --allow-empty -m "Checkpoint commit"
#Note the commit SHA of the checkpoint commit (let's call it CHECKPOINT_SHA). You can find it using git log.

#After running the script and pushing your changes, you can reset your repository back to the checkpoint:

#bash
#Copy code
#git reset --hard CHECKPOINT_SHA
#git push origin HEAD --force

##############################################################################

# To add a special code phrase to every commit message, you can simply modify the commit message in the script. For example:
#GIT_COMMITTER_DATE="$d 12:00:00" git commit --date="$d 12:00:00" -m "commit number $j on $d - special code phrase"

##############################################################################

#Here's a basic script to delete all commits with the "special code phrase" in their commit messages:
#git filter-branch --force --msg-filter '
#    if grep -q "special code phrase" "$GIT_COMMIT"; then
#        # This commit has the special phrase, so skip it
#        git commit-tree "$GIT_COMMIT" </dev/null
#    else
#        # This commit doesn't have the special phrase, so keep it as-is
#        cat
#    fi
#' --tag-name-filter cat -- --all

#After running this, you'll need to force push your changes with git push origin --force.

#Remember, this script permanently alters your repository's history. Be sure to backup your repository before running it.

#git log --grep="POC"
