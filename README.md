# PHP code quality and static code analysis tools
The objective is to include multiple PHP code quality and static code analysis tools in an easy to use Docker image. The
tools include PHP static analysis, lines of PHP code report, mess detector, code smell highlighting,
copy/paste detection, and the compatibility of the application from one version of PHP to another for modernization.

More specifically this includes:

- squizlabs/php_codesniffer
- phpunit/phpunit
- phploc/phploc
- pdepend/pdepend
- phpmd/phpmd
- sebastian/phpcpd
- friendsofphp/php-cs-fixer
- phpcompatibility/php-compatibility
- phpmetrics/phpmetrics
- phpstan/phpstan
- magento/magento-coding-standard
- drupal/coder
- dealerdirect/phpcodesniffer-composer-installer

## Prerequisite

- Operating system - Windows/Linux/Mac
- Docker setup
    - Refer https://docs.docker.com/install/ for more details
- PHP project

## Usage

NOTE: This image does nothing when invoking it without a followup command, such as:

```
$ cd "/path/to/desired/directory"
$ docker run -it --rm -v "$PWD":/app -w /app madhavvyas/php-code-quality-analysis-tools:latest "desired-command-with-arguments"
```

IMPORTANT: To execute above command in windows, "$PWD" to be replace with %cd%.

In the example above, Docker runs an interactive terminal to be removed when all is completed, and mounts
the current host directory (%cd%) inside the container, sets this as the current working directory, and then
loads the image madhavvyas/php-code-quality-analysis-tools. Following this the user can add any commands to be executed inside
the container. (such as running the tools provided by the image)

This is the most common use case, enabling the user to run the tools on everything in and/or below the working
directory.

Available commands provided by the madhavvyas/php-code-quality-analysis-tools image:

* php + args
* composer + args
* vendor/bin/phploc + args
* vendor/bin/phpmd + args
* vendor/bin/pdepend + args
* vendor/bin/phpcpd + args
* vendor/bin/phpmetrics + args
* vendor/bin/phpunit + args
* vendor/bin/phpcs + args
* vendor/bin/php-cs-fixer + args
* vendor/bin/phpstan + args (more robust commands via config file)
* sh (or any other command) + args

### Some example commands:


NOTE: If using the commands below "as-is", please create a 'code_coverage_report' folder within the project first.
This will be used, by the commands, to contain the results of the various tools. Modify as desired.

IMPORTANT: If you run into memory issues, where the output states the process ran out of memory, you can alter the amount
of memory the PHP process uses for a given command by adding the -d flag to the PHP command.  Note that the following example
is for extreme cases since the image already sets the memory limit to 1G.

```
php -d memory_limit=2G
```

#### PHP Lines of Code (PHPLoc)

See https://github.com/sebastianbergmann/phploc for more usage details of this tool.

```
$ docker run -it --rm -v %cd%:/app -w /app madhavvyas/php-code-quality-analysis-tools:latest \
php /usr/local/lib/php-code-quality-analysis-tools/vendor/bin/phploc -v --names "*.php" \
--exclude "vendor" . > ./code_coverage_report/phploc.txt
```
#### PHP Mess Detector (phpmd)

See https://phpmd.org/download/index.html for more usage details of this tool.

```
$ docker run -it --rm -v %cd%:/app -w /app madhavvyas/php-code-quality-analysis-tools:latest \
php /usr/local/lib/php-code-quality-analysis-tools/vendor/bin/phpmd . xml codesize --exclude 'vendor' \
--reportfile './code_coverage_report/phpmd_results.xml'
```

#### PHP Depends (Pdepend)

See https://pdepend.org/ for more usage details of this tool.

```
$ docker run -it --rm -v %cd%:/app -w /app madhavvyas/php-code-quality-analysis-tools:latest \
php /usr/local/lib/php-code-quality-analysis-tools/vendor/bin/pdepend --ignore='vendor' \
--summary-xml='./code_coverage_report/pdepend_output.xml' \
--jdepend-chart='./code_coverage_report/pdepend_chart.svg' \
--overview-pyramid='./code_coverage_report/pdepend_pyramid.svg' .
```

#### PHP Copy/Paste Detector (phpcpd)

See https://github.com/sebastianbergmann/phpcpd for more usage details of this tool.

```
$ docker run -it --rm -v %cd%:/app -w /app madhavvyas/php-code-quality-analysis-tools:latest \
php /usr/local/lib/php-code-quality-analysis-tools/vendor/bin/phpcpd . \
--exclude 'vendor' > ./code_coverage_report/phpcpd_results.txt
```

#### PHPMetrics

See http://www.phpmetrics.org/ for more usage details of this tool.

```
$ docker run -it --rm -v %cd%:/app -w /app madhavvyas/php-code-quality-analysis-tools:latest \
php /usr/local/lib/php-code-quality-analysis-tools/vendor/bin/phpmetrics --excluded-dirs 'vendor' \
--report-html=./code_coverage_report/metrics_results .
```

#### PHP Codesniffer (phpcs)

See https://github.com/squizlabs/PHP_CodeSniffer/wiki for more usage details of this tool.

```
$ docker run -it --rm -v %cd%:/app -w /app madhavvyas/php-code-quality-analysis-tools:latest \
php /usr/local/lib/php-code-quality-analysis-tools/vendor/bin/phpcs -sv --extensions=php --ignore=vendor \
--report-file=./code_coverage_report/codesniffer_results.txt .
```

##### For Drupal 8 project
```
$ docker run -it --rm -v %cd%:/app -w /app madhavvyas/php-code-quality-analysis-tools:latest \
php /usr/local/lib/php-code-quality-analysis-tools/vendor/bin/phpcs --standard=Drupal -sv --extensions=php,module,inc,install,test,profile,theme --ignore=vendor \
--report-file=./code_coverage_report/codesniffer_results.txt .
```

##### For Magento 2 project
```
$ docker run -it --rm -v %cd%:/app -w /app madhavvyas/php-code-quality-analysis-tools:latest \
php /usr/local/lib/php-code-quality-analysis-tools/vendor/bin/phpcs --standard=Magento2 -sv --extensions=php --ignore=vendor \
--report-file=./code_coverage_report/codesniffer_results.txt .
```

#### PHPCompatibility rules applied to PHP Codesniffer

See https://github.com/PHPCompatibility/PHPCompatibility and https://github.com/squizlabs/PHP_CodeSniffer/wiki for more
usage details of this tool.

```
$ docker run -it --rm -v %cd%:/app -w /app madhavvyas/php-code-quality-analysis-tools:latest sh -c \
'php /usr/local/lib/php-code-quality-analysis-tools/vendor/bin/phpcs -sv --config-set installed_paths  /usr/local/lib/php-code-quality-analysis-tools/vendor/phpcompatibility/php-compatibility && \
php /usr/local/lib/php-code-quality-analysis-tools/vendor/bin/phpcs -sv --standard='PHPCompatibility' --extensions=php --ignore=vendor . \
--report-file=./code_coverage_report/phpcompatibility_results.txt .'
```

## Alternative Preparations

Rather than allowing Docker to retrieve the image from Docker Hub, users could also build the docker image locally
by cloning the image repo from Github.

Why? As an example, a different version of PHP provided by including a different PHP image may be desired. Or a
specific version of the tools loaded by Composer might be required.

After cloning, navigate to the location:

```
$ git clone https://github.com/madhavvyas/php-code-quality-analysis-tools.git
$ cd php-code-quality-analysis-tools
```

Alter the Dockerfile as desired, then build the image locally: (don't miss the dot at the end)

```
$ docker build -t madhavvyas/php-code-quality-analysis-tools .
```

Or a user may simply desire the image as-is, for later use:

```
$ docker build -t madhavvyas/php-code-quality-analysis-tools https://github.com/madhavvyas/php-code-quality-analysis-tools.git
```


Courtesy: https://hub.docker.com/r/adamculp/php-code-quality

## Enjoy!

Please star, on Docker Hub and Github, if you find this helpful.
