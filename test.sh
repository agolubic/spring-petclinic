#!/bin/bash

BITBUCKET_REPO_URL="https://bitbucket.org/ispivsall/spring-petclinic"
API_USERNAME="agolubic"
API_PASSWORD="Cha1nsaw1!"

# Extract owner and repository name from the URL
REPO_OWNER=$(echo "$BITBUCKET_REPO_URL" | awk -F'/' '{print $(NF-1)}')
REPO_NAME=$(echo "$BITBUCKET_REPO_URL" | awk -F'/' '{print $NF}')

# Fetch all open pull requests
OPEN_PRS=$(curl -s "https://bitbucket.org/!api/internal/repositories/ispivsall/spring-petclinic/pr-authors/?pr_status=open" | jq -r '.values[].id')

# Iterate over each pull request
for PR_ID in $OPEN_PRS; do
  # Create a text file for the pull request
  FILENAME="pull_request_${PR_ID}_diff.txt"

  # Fetch the pull request diff and store it in the text file
  curl -s -u "${API_USERNAME}:${API_PASSWORD}" "${BITBUCKET_REPO_URL}/pull-requests/${PR_ID}/diff" >"${FILENAME}"

  echo "Pull request ${PR_ID} diff saved in ${FILENAME}"
done
