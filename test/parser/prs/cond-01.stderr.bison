At: "-stdin-":8:
parse error: syntax error
parser stacks:
state	value
#STATE#	(null) 
#STATE#	(template-formal-decl-list-pair) [4:10..17]
#STATE#	keyword: defproc [5:1..7]
#STATE#	identifier: ass [5:9..11]
#STATE#	list<(port-formal-decl)>: ... [5:12..13]
#STATE#	{ [5:15]
#STATE#	list<(def-body-item)>: (instance-decl) ... [6:2..10]
#STATE#	[ [7:2]
#STATE#	(arith-expr) [7:3..13]
#STATE#	-> [7:14]
#STATE#	keyword: prs [8:3..5]
in state #STATE#, possible rules are:
	guarded_instance_management: expr RARROW . instance_management_list  (#RULE#)
acceptable tokens are: 
	'{' (shift)
	'[' (shift)
	'(' (shift)
	'-' (shift)
	'~' (shift)
	'!' (shift)
	ID (shift)
	FLOAT (shift)
	INT (shift)
	STRING (shift)
	SCOPE (shift)
	CHANNEL (shift)
	BOOL_TRUE (shift)
	BOOL_FALSE (shift)
	INT_TYPE (shift)
	BOOL_TYPE (shift)
	PINT_TYPE (shift)
	PBOOL_TYPE (shift)
	PREAL_TYPE (shift)