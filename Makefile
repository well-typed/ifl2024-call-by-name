all: \
        printSecret-1a.eventlog.html \
        printSecret-1b.eventlog.html \
        printSecret-1c.eventlog.html \
		printSecret-2.eventlog.html \
		printSecret-2.eventlog.html \
		numberLines-0.eventlog.html \
		numberLines-1.eventlog.html \
		numberLines-2a.eventlog.html \
		numberLines-2b.eventlog.html \
		numberLines-3a.eventlog.html \
		numberLines-3b.eventlog.html \
		numberLines-4.eventlog.html \
		conduit-1a.eventlog.html \
		conduit-1b.eventlog.html \
		conduit-2.eventlog.html \
		conduit-3.eventlog.html \
		conduit-4.eventlog.html \
		conduit-5.eventlog.html \
        printSecret-1a.pdf \
        printSecret-1b.pdf \
        printSecret-1c.pdf \
		numberLines-0.pdf \
		numberLines-1.pdf \
		numberLines-2a.pdf \
		numberLines-2b.pdf \
		numberLines-3a.pdf \
		numberLines-3b.pdf \
		numberLines-4.pdf \
		conduit-1a.pdf \
		conduit-1b.pdf \
		conduit-2.pdf \
		conduit-3.pdf \
		conduit-4.pdf \
		conduit-5.pdf \
		conduit-6.pdf \
		conduit-7.pdf \
		conduit-8.pdf \

printSecret-1a.eventlog printSecret-1a.hp: ifl2024-sharing.cabal lib/*.hs exe/printSecret-1/*.hs
	cat input | cabal run printSecret-1a -- +RTS -s -l -hT -i0.001

printSecret-1b.eventlog printSecret-1b.hp: ifl2024-sharing.cabal lib/*.hs exe/printSecret-1/*.hs
	cat input | cabal run printSecret-1b -- +RTS -s -l -hT -i0.001

printSecret-1c.eventlog printSecret-1c.hp: ifl2024-sharing.cabal lib/*.hs exe/printSecret-1/*.hs
	cat input | cabal run printSecret-1c -- +RTS -s -l -hT -i0.001

printSecret-2.eventlog printSecret-2.hp: ifl2024-sharing.cabal lib/*.hs exe/printSecret-2/*.hs
	cat input | cabal run printSecret-2 -- +RTS -s -l -hT -i0.001

printSecret-3.eventlog printSecret-3.hp: ifl2024-sharing.cabal lib/*.hs exe/printSecret-3/*.hs
	cat input | cabal run printSecret-3 -- +RTS -s -l -hT -i0.001

numberLines-0.eventlog numberLines-0.hp: ifl2024-sharing.cabal lib/*.hs exe/numberLines-0/*.hs lotsalines
	cat lotsalines | cabal run numberLines-0 -- +RTS -s -l -hT -i0.001 >/dev/null

numberLines-1.eventlog numberLines-1.hp: ifl2024-sharing.cabal lib/*.hs exe/numberLines-1/*.hs lotsalines
	cat lotsalines | cabal run numberLines-1 -- +RTS -s -l -hT -i0.001 >/dev/null

numberLines-2a.eventlog numberLines-2a.hp: ifl2024-sharing.cabal lib/*.hs exe/numberLines-2/*.hs lotsalines
	cat lotsalines | cabal run numberLines-2a -- +RTS -s -l -hT -i0.001 >/dev/null

numberLines-2b.eventlog numberLines-2b.hp: ifl2024-sharing.cabal lib/*.hs exe/numberLines-2/*.hs lotsalines
	cat lotsalines | cabal run numberLines-2b -- +RTS -s -l -hT -i0.001 >/dev/null

numberLines-3a.eventlog numberLines-3a.hp: ifl2024-sharing.cabal lib/*.hs exe/numberLines-3/*.hs lotsalines
	cat lotsalines | cabal run numberLines-3a -- +RTS -s -l -hT -i0.001 >/dev/null

numberLines-3b.eventlog numberLines-3b.hp: ifl2024-sharing.cabal lib/*.hs exe/numberLines-3/*.hs lotsalines
	cat lotsalines | cabal run numberLines-3b -- +RTS -s -l -hT -i0.001 >/dev/null

numberLines-4.eventlog numberLines-4.hp: ifl2024-sharing.cabal lib/*.hs exe/numberLines-4/*.hs lotsalines
	cat lotsalines | cabal run numberLines-4 -- +RTS -s -l -hT -i0.001 >/dev/null

conduit-1a.eventlog conduit-1a.hp: ifl2024-sharing.cabal lib/*.hs exe/conduit-1/*.hs lotsalines
	cabal run conduit-1a -- +RTS -s -l -hT -i0.1

conduit-1b.eventlog conduit-1b.hp: ifl2024-sharing.cabal lib/*.hs exe/conduit-1/*.hs lotsalines
	cabal run conduit-1b -- +RTS -s -l -hT -i0.1

conduit-2.eventlog conduit-2.hp: ifl2024-sharing.cabal lib/*.hs exe/conduit-2/*.hs lotsalines
	cabal run conduit-2 -- +RTS -s -l -hT -i0.1

conduit-3.eventlog conduit-3.hp: ifl2024-sharing.cabal lib/*.hs exe/conduit-3/*.hs lotsalines
	cabal run conduit-3 -- +RTS -s -l -hT -i0.1

conduit-4.eventlog conduit-4.hp: ifl2024-sharing.cabal lib/*.hs exe/conduit-4/*.hs lotsalines
	cabal run conduit-4 -- +RTS -s -l -hT -i0.1

conduit-5.eventlog conduit-5.hp: ifl2024-sharing.cabal lib/*.hs exe/conduit-5/*.hs lotsalines
	cabal run conduit-5 -- +RTS -s -l -hT -i0.1

conduit-6.eventlog conduit-6.hp: ifl2024-sharing.cabal lib/*.hs exe/conduit-6/*.hs lotsalines
	cabal run conduit-6 -- +RTS -s -l -hT -i0.1

conduit-7.eventlog conduit-7.hp: ifl2024-sharing.cabal lib/*.hs exe/conduit-7/*.hs lotsalines
	cabal run conduit-7 -- +RTS -s -l -hT -i0.1

conduit-8.eventlog conduit-8.hp: ifl2024-sharing.cabal lib/*.hs exe/conduit-8/*.hs lotsalines
	cabal run conduit-8 -- +RTS -s -l -hT -i0.1

lotsalines:
	./genlotsalines.sh

%.eventlog.html: %.eventlog
	eventlog2html $<

%.svg: %.hp
	hp2pretty $<

%.pdf: %.svg
	convert $< $@

.PHONY: clean
clean:
	rm -f *.eventlog
	rm -f *.eventlog.html
	rm -f *.hp
	rm -f *.svg
	rm -rf dist-newstyle
	rm -rf dump
