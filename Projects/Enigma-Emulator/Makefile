default:
	ocamlbuild -use-ocamlfind enigma_test.byte && ./enigma_test.byte
	
check:
	bash checkenv.sh && bash checktypes.sh
	
docs:
	mkdir docs
	ocamldoc -html -d docs/ enigma.ml	
clean:
	ocamlbuild -clean
	rm -f checktypes.ml
	rm -rf docs
	
test2: 
	ocamlbuild -use-ocamlfind enigma_test2.byte && ./enigma_test2.byte
test3: 
	ocamlbuild -use-ocamlfind enigma_test3.byte && ./enigma_test3.byte
