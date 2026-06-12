#!/bin/sh

set -eu
umask 077

_repourl="https://github.com/${GITHUB_REPOSITORY}"
case "$JOB_STATUS" in
    success)
        _color="green"
        _icon="✅"
        ;;
    cancelled)
        _color="yellow"
        _icon="⚠️"
        ;;
    *)
        _color="red"
        _icon="❌"
        ;;
esac

# put url in config so it doesn't show up in process list
_config="$(mktemp -p "$RUNNER_TEMP")"
trap 'rm -f -- "$_config"' EXIT
cat <<EOF > "$_config"
url = "${ROCKETCHAT_WEBHOOK}"
EOF

cat <<EOF | curl -sSf -X POST -H "Content-Type: application/json" \
                -d @- --config "$_config"
{
  "text": "[${_icon} ${JOB_STATUS}]: ${GITHUB_REPOSITORY}/${GITHUB_REF_NAME}",
  "attachments": [
    {
      "collapsed": true,
      "color": "$_color",
      "title": "commit: ${GITHUB_SHA}",
      "fields": [
        {
          "short": true,
          "title": "ref",
          "value": "[${GITHUB_REF}](${_repourl}/tree/${GITHUB_REF})"
        },
        {
          "short": true,
          "title": "job",
          "value": "[${GITHUB_JOB}](${_repourl}/commit/${GITHUB_SHA}/checks)"
        },
        {
          "short": true,
          "title": "repository",
          "value": "[${GITHUB_REPOSITORY}](${_repourl})"
        },
        {
          "short": true,
          "title": "run",
          "value": "[${GITHUB_RUN_ID}](${_repourl}/actions/runs/${GITHUB_RUN_ID})"
        }
      ]
    }
  ]
}
EOF
