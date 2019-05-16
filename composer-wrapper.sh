#!/bin/sh

php /usr/local/lib/php-code-quality-analysis-tools/composer.phar $@
STATUS=$?
return $STATUS
