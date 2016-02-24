all: noheader makedb clean

noheader:
	tail -n +2 usdaplants.csv > nohead.csv

makedb:
	sqlite3 usdadb.sqlite3 < import.sql

clean:
	rm nohead.csv
