.PHONY: arosunits.tgz arosunits.chm
HTMLPARAMS=--format=html --output=aroshtml/ --charset=UTF-8 --index-colcount=4 --footer-date=yyyy-mm-dd
CHMPARAMS=--format=chm --output=arosunits.chm --charset=UTF-8 --auto-toc --auto-index --make-searchable --footer-date=yyyy-mm-dd

# update example: makeskel --update --package=aros --descr=arosxml/exec.xml --input="-dAROS_ABIv0 arosunits/src/exec.pas" --output=execupdate.xml

arosunits.tgz: arosunits
		fpdoc --package=aros --ostarget=aros --content --descr-dir=arosxml --input-dir=arosunits/src $(HTMLPARAMS)
		tar -czf arosunits.tgz aroshtml/*
arosunits.chm: arosunits
		fpdoc --package=aros --ostarget=aros --content --descr-dir=arosxml --input-dir=arosunits/src $(CHMPARAMS)

arosunits:
		svn checkout http://svn.freepascal.org/svn/fpc/trunk/packages/arosunits arosunits

amunits:
		svn checkout http://svn.freepascal.org/svn/fpc/trunk/packages/amunits amunits

morphunits:
		svn checkout http://svn.freepascal.org/svn/fpc/trunk/packages/morphunits morphunits

os4units:
		svn checkout http://svn.freepascal.org/svn/fpc/trunk/packages/os4units os4units

all: arosunits.tgz arosunits.chm

clean:
		rm -rf html *.tgz *.chm *.pdf
		rm -rf amunits arosunits morphunits os4units
		rm -rf amhtml aroshtml morphhtml os4html