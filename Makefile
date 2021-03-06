.PHONY: arosunits.tgz arosunits.chm amunits.tgz amunits.chm
HTMLPARAMS=--format=html --charset=UTF-8 --index-colcount=4 --footer-date=yyyy-mm-dd
CHMPARAMS=--format=chm --charset=UTF-8 --auto-toc --auto-index --make-searchable --footer-date=yyyy-mm-dd

# update example: makeskel --update --package=aros --descr=arosxml/exec.xml --input="-dAROS_ABIv0 arosunits/src/exec.pas" --output=execupdate.xml

arosunits.tgz: arosunits
		fpdoc --package=aros --ostarget=aros --cputarget=i386 --content --descr-dir=arosxml --input-dir=arosunits/src --output=aroshtml/ $(HTMLPARAMS)
		tar -czf arosunits.tgz aroshtml/*
arosunits.chm: arosunits
		fpdoc --package=aros --ostarget=aros --cputarget=i386 --content --descr-dir=arosxml --input-dir=arosunits/src --output=arosunits.chm $(CHMPARAMS)

amunits.tgz: amunits
		fpdoc --package=amunits --ostarget=amiga --cputarget=m68k --content --descr-dir=./amxml/ --input-dir=amunits/src/coreunits/ --input-dir=amunits/src/otherlibs/ --output=amhtml/ $(HTMLPARAMS)
		tar -czf amunits.tgz amhtml/*
amunits.chm: amunits
		fpdoc --package=amunits --ostarget=amiga --cputarget=m68k --content --descr-dir=./amxml/ --input-dir=amunits/src/coreunits/ --input-dir=amunits/src/otherlibs/ --output=amunits.chm $(CHMPARAMS)

morphunits.tgz: morphunits
		fpdoc --package=morphunits --ostarget=morphos --cputarget=powerpc --content --descr-dir=./morphxml/ --input-dir=morphunits/src/ --output=morphhtml/ $(HTMLPARAMS)
		tar -czf amunits.tgz amhtml/*
morphunits.chm: morphunits
		fpdoc --package=morphunits --ostarget=morphos --cputarget=powerpc --content --descr-dir=./morphxml/ --input-dir=morphunits/src/ --output=morphunits.chm $(CHMPARAMS)

arosunits:
		svn checkout http://svn.freepascal.org/svn/fpc/trunk/packages/arosunits arosunits

amunits:
		svn checkout http://svn.freepascal.org/svn/fpc/trunk/packages/amunits amunits

morphunits:
		svn checkout http://svn.freepascal.org/svn/fpc/trunk/packages/morphunits morphunits

os4units:
		svn checkout http://svn.freepascal.org/svn/fpc/trunk/packages/os4units os4units

allaros: arosunits.tgz arosunits.chm

allamiga: amunits.tgz amunits.chm

allmorphos: morphunits.tgz morphunits.chm

all: allaros allamiga allmorphos

clean:
		rm -rf html *.tgz *.chm *.pdf
		rm -rf amunits arosunits morphunits os4units
		rm -rf amhtml aroshtml morphhtml os4html