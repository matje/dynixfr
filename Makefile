TITLE=$(shell grep docName template.xml | sed -e 's/.*docName=\"//' -e 's/\">//')

.PHONY: txt clean

all: txt

txt: $(TITLE).txt

draft.txt: *.mkd template.xml draft.xml
	xml2rfc template.xml -o draft.txt --text

$(TITLE).txt:	draft.txt
	ln -sf $< $@

draft.xml: *.mkd template.xml
	pandoc -t docbook -s middle.mkd | xsltproc --nonet transform.xsl - > middle.xml
	pandoc -t docbook -s back.mkd | xsltproc --nonet transform.xsl - > back.xml
	pandoc -t docbook -s abstract.mkd | xsltproc --nonet transform.xsl - > abstract.xml

clean:
	rm -f *.txt
	rm middle.xml back.xml abstract.xml
