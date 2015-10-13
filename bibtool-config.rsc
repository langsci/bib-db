%% This is a resource file for BibTool.
%% Usage: bibtool -r bibtool-config.rsc -i INPUT -o OUTPUT

%rewrite.rule { "Å" # "{\\AA}" }


%%
%% normalize entry format
%%
bibtex.env.name          = "BIBINPUTS"
check.case.sensitive     = on
check.double             = on
check.double.delete      = on
count.all                = on
count.used               = off
crossref.limit           = 32
default.key              = "**key*"
dir.file.separator       = "/"
env.separator            = ":"
expand.macros            = on
fmt.et.al                = ":etal"
fmt.inter.name           = ""
fmt.name.name            = ":"
fmt.name.pre             = "."
fmt.name.title           = ":"
fmt.title.title          = "-"
ignored.word             = "a"
ignored.word             = "an"
ignored.word             = "the"
ignored.word             = "le"
ignored.word             = "les"
ignored.word             = "la"
ignored.word             = "un"
ignored.word             = "une"
ignored.word             = "el"
ignored.word             = "il"
ignored.word             = "der"
ignored.word             = "die"
ignored.word             = "das"
ignored.word             = "ein"
ignored.word             = "eine"
key.base                 = lower
key.expand.macros        = on
%key.format               = short
key.format = { %2n(author):%-2d(year) # %2n(editor):ed:%-2d(year)}
key.generation           = on
key.number.separator     = ""
new.entry.type           = "ARTICLE"      
new.entry.type           = "BOOK"         
new.entry.type           = "BOOKLET"      
new.entry.type           = "CONFERENCE"   
new.entry.type           = "INBOOK"       
new.entry.type           = "INCOLLECTION" 
new.entry.type           = "INPROCEEDINGS"
new.entry.type           = "MANUAL"       
new.entry.type           = "MASTERSTHESIS"
new.entry.type           = "MISC"         
new.entry.type           = "PHDTHESIS"    
new.entry.type           = "PROCEEDINGS"  
new.entry.type           = "TECHREPORT"   
new.entry.type           = "UNPUBLISHED"
new.entry.type           = "REPORT"  
pass.comments            = off
preserve.key.case        = off
preserve.keys            = off
print.align              = 0	% default is 18
% print.align.string       = 18
% print.align.preamble     = 11
% print.align.comment      = 10
print.align.key          = 0	% default is 18
print.all.strings        = on
print.braces             = on
print.comma.at.end       = on
print.deleted.prefix     = "###"
print.deleted.entries    = on
print.entry.types        = "pisnmac"
print.equal.right        = on
print.indent             = 2
print.line.length        = 9999
print.newline            = 1
print.parentheses        = off
print.use.tab            = on
print.wide.equal         = on 	% space around =
quiet                    = off
rewrite.case.sensitive   = on
rewrite.limit            = 512
select.crossrefs	 = on
select.case.sensitive    = off
select.fields            = "$key"
sort                     = on
sort.cased               = off
%sort.format              = "%s($key)"
sort.format	= {%N(author) %d(year) %s(title) # %N(author) %d(year) %s(booktitle) # %N(editor) %d(year) %s(booktitle)}
sort.macros              = on
sort.order{* =
	 author
	#title
	#editor
	#booktitle
	#year
	#series
	#journal
	#volume
	#number
	#issue
	#pages
	#chapter
	#edition
	#school
	#address
	#location
	#month
	#date
	#organization
	#institution
	#publisher
	#note
	#howpublished
	#type
	#url
	#doi
	#owner}
sort.reverse             = off
suppress.initial.newline = off
symbol.type              = lower
verbose                  = off

%%
%% normalize field content
%%
delete.field {timestamp}
add.field {owner=langsci}
%rename.field {title = booktitle if $type = ”book”}
rewrite.rule { pages # "\([0-9]+\) *- *\([0-9]+\)" = "\1--\2" }
expand.crossref = on

%%
%% expand macros in keys
%%
tex.define {\"[1]=#1e}
