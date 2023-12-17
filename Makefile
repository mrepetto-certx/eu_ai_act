.PHONY: compile clean pdf_folder

SOURCE_PATHS := ./full_version/ ./sis_version/
CLEAN_FILES := *.aux *.bbl *.log *.out *.toc *.gz  *.blg *.bcf *.xml *.run.xml *.synctex.gz *.fls *.fdb_latexmk

compile:
	docker-compose up -d
	$(foreach path,$(SOURCE_PATHS),docker-compose exec -T euaiact pdflatex -interaction=nonstopmode -output-directory="$(path)" $(path)main.tex)

clean:
	$(foreach file,$(CLEAN_FILES),docker-compose exec euaiact find . -name "$(file)" -type f -delete &)

pdf_folder:
	docker-compose exec euaiact rm -rf pdf_folder
	docker-compose exec euaiact mkdir pdf_folder
	$(foreach path,$(SOURCE_PATHS),docker-compose exec euaiact cp $(path)main.pdf pdf_folder/$(notdir $(patsubst %/,%,$(path))).pdf &)