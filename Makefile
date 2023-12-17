.PHONY: compile clean pdf_folder

SOURCE_PATHS := ./full_version/ ./sis_version/
CLEAN_FILES := *.aux *.bbl *.log *.out *.toc *.gz  *.blg *.bcf *.xml *.run.xml *.synctex.gz *.fls *.fdb_latexmk *.idx *.ilg *.ind

compile:
	docker-compose up -d
	$(foreach path,$(SOURCE_PATHS),docker-compose exec -T euaiact latexmk -pdf -pdflatex="pdflatex -interaction=nonstopmode" -use-make -cd $(path)main.tex &)

clean:
	$(foreach file,$(CLEAN_FILES),docker-compose exec -T euaiact find . -name "$(file)" -type f -delete &)

pdf_folder:
	docker-compose exec -T euaiact rm -rf pdf_folder
	docker-compose exec -T euaiact mkdir pdf_folder
	$(foreach path,$(SOURCE_PATHS),docker-compose exec -T euaiact cp $(path)main.pdf pdf_folder/$(notdir $(patsubst %/,%,$(path))).pdf &)

all: compile pdf_folder clean