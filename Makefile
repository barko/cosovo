NAME = cosovo
OCB_FLAGS = -use-ocamlfind -I lib -I src
OCB = ocamlbuild $(OCB_FLAGS)

lib:
	$(OCB) $(NAME).cma
	$(OCB) $(NAME).cmxa

tools:
	$(OCB) csvcat.native
	$(OCB) csvcat.byte

install:
	@ocamlfind install $(NAME) lib/META _build/lib/cosovo.cma _build/lib/cosovo.cmxa _build/lib/csv_types.cmi _build/lib/csv_io.cmi lib/csv_types.mli lib/csv_io.mli

uninstall:
	@ocamlfind remove $(NAME)

all: lib tools test

.PHONY: all lib tools test install uninstall
