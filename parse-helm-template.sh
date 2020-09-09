#!/bin/bash
php /scienta-helm-versioning/bin/convert-versions.php convert -s$CHART_SUFFIX -c$COMMIT_SHA -- /helmsource /helmfiles $CHART_VERSION $SCIENTA_VERSION 1>/dev/null \
&& helm template /helmfiles/scienta$CHART_SUFFIX/v$CHART_VERSION "$@"
