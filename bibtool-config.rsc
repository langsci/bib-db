%% This is a resource file for BibTool.
%% Usage: bibtool -r bibtool-config.rsc -i INPUT -o OUTPUT


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% general options 
%%

bibtex.env.name          = "BIBINPUTS"
check.case.sensitive     = on               % for regular expression checks 

%% handling doubles/duplicates
%% "Two entries are considered equal if their sort key [see sort.format] is identical and they are adjacent in the final output."
check.double             = on  % check for doubles
check.double.delete      = on  % check for and delete doubles
print.deleted.prefix     = "###"
print.deleted.entries    = on

count.all                = on
count.used               = off
crossref.limit           = 32
dir.file.separator       = "/"
env.separator            = ":"
expand.macros            = on
verbose                  = off
quiet                    = on

%% general printing options
suppress.initial.newline = off
print.entry.types        = "pisnmac"
print.newline            = 1          % number of newlines between entries


%% ignored words: relevant for sorting
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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% entry types	(in order to change their appearance)
%%

new.entry.type           = "ARTICLE"      
new.entry.type           = "BOOK"        
new.entry.type           = "COLLECTION"        
new.entry.type           = "INBOOK"       
new.entry.type           = "INCOLLECTION" 
new.entry.type           = "INPROCEEDINGS"
new.entry.type           = "MANUAL"       
new.entry.type           = "MASTERSTHESIS"
new.entry.type           = "MISC"         
new.entry.type           = "PHDTHESIS"    
new.entry.type           = "PROCEEDINGS"  
new.entry.type           = "TECHREPORT"
new.entry.type           = "THESIS" 
new.entry.type           = "UNPUBLISHED"
new.entry.type           = "REPORT"  


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% select entries (relevant for duplicate detection) 
%%

select.crossrefs	 = on
select.case.sensitive    = off
select.fields            = "$key"


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% sort entries (relevant for duplicate detection) 
%%

sort                     = on
sort.cased               = off
sort.format	= {%N(author) %s(year) %s(title) # %N(author) %s(year) %s(booktitle) # %N(editor) %s(year) %s(booktitle) # %N(editor) %s(year) %s(title) }
sort.macros              = on
sort.reverse             = off


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% key generation
%%

default.key              = "**key*"
key.base                 = lower
key.expand.macros        = on
%key.format               = short
key.format = { %2n(author):%-2d(year) # %2n(editor):ed:%-2d(year)}
key.generation           = on
key.number.separator     = ""

%% keys from the input 
preserve.key.case        = off
preserve.keys            = off

%% formatting of names and titles
fmt.et.al                = ":etal"
fmt.inter.name           = ""
fmt.name.name            = ":"
fmt.name.pre             = "."
fmt.name.title           = ":"
fmt.title.title          = "-"

%% expand macros in keys
tex.define {\"[1]=#1e}
tex.define {\ss[1]=ss}
tex.define {\ss=ss}
tex.define {\AE=AE}
tex.define {\OE=OE}
tex.define {\aa=aa}
tex.define {\AA=AA}
tex.define {\o=o}
tex.define {\O=O}
tex.define {\l=l}
tex.define {\L=L}
tex.define {\i=i}
tex.define {\j=j}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% normalize field names and values
%%

%delete.field {timestamp}
delete.field {_orig}
delete.field {date-added}
delete.field {date-modified}
delete.field {keywords}
delete.field {language}
delete.field {lid}
delete.field {annotation}
delete.field {lgcode}
delete.field {aiatsis_callnumber}
delete.field {aiatsis_reference_language}
delete.field {aiatsis_code}
delete.field {alnumcodes}
delete.field {languoidbase_ids}
delete.field {numberofpages}
delete.field {ozbib_id}
delete.field {ozbibnote}
delete.field {ozbibreftype}
delete.field {call-number}
delete.field {lastchecked}
delete.field {urldate}
delete.field {bdsk-url-1}
delete.field {isbn}
delete.field {issn}
delete.field {typ}
delete.field {last_changed}
add.field {owner = langsci}
rewrite.case.sensitive   = on    % case sensitivity during matching
rewrite.limit            = 512   % max number of applications of each rewrite rule (-1 is unrestricted)
rename.field {journaltitle = journal}
rename.field {location = address}
rename.field {title = booktitle if $type = "collection"}
rename.field {title = booktitle if $type = "proceedings"}
rewrite.rule { pages # "\([0-9]+\) *- *\([0-9]+\)" = "\1--\2" }
%rewrite.rule { "Å" # "{\\AA}" }
expand.crossref = on
sort.order{* =           
	 author
	#sortkey
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
	#owner
	}                 % * is the wildcard for entry types


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% pretty print of entries
%%

symbol.type              = lower        % print field names in lower case
pass.comments            = off

%% position of '=' of field-value pairs
print.align              = 0	% default is 18
% print.align.string       = 18
% print.align.preamble     = 11
% print.align.comment      = 10
print.align.key          = 0	% default is 18

print.all.strings        = on     % print all macros
print.braces             = on     % alternatively double quotes
print.comma.at.end       = on
print.equal.right        = on
print.indent             = 2
print.line.length        = 9999
print.parentheses        = off    % Enclose the whole entry in parentheses instead of braces.
print.use.tab            = on
print.wide.equal         = on 	  % space around =


