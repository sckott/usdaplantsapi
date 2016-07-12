all: noheader makedb clean

noheader:
	tail -n +2 usdaplants.csv > nohead.csv

makedb:
	sqlite3 usdadb_new.sqlite3 < import_new.sql

clean:
	rm nohead.csv
