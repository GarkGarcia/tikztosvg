package:
	asciidoctor -b manpage -o man/tikztosvg.1 man/man.adoc
	tar -cvO * | gzip -c /dev/stdin > tikztosvg.tar.gz

install:
	sh install.sh

