MAKEFLAGS += -s

NAME = seminar

default: pdf

pdf:
	pdflatex $(NAME).tex
	echo
	echo $(NAME).pdf generated.
	echo

clean:
	rm -f *.nav *.snm *.blg *.bbl *.ps *.dvi *.aux *.toc *.idx *.ind *.ilg *.log *.out $(NAME).pdf
