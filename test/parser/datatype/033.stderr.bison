At: "033.hac":7:
parse error: syntax error
parser stacks:
state	value
#STATE#	(null) 
#STATE#	(null) 
#STATE#	keyword: deftype [6:1..7]
#STATE#	identifier: my_data [6:9..15]
#STATE#	<: [6:17]
#STATE#	(type-ref) [6:20..25]
#STATE#	list<(port-formal-decl)>: (port-formal-decl) ... [6:27..44]
#STATE#	{ [6:46]
#STATE#	list<(def-body-item)>: ... [0:0]
#STATE#	datatype: bool [7:2..5]
in state #STATE#, possible rules are:
	defdatatype: optional_template_specification DEFTYPE ID DEFINEOP data_type_ref optional_port_formal_decl_list_in_parens '{' optional_datatype_body . set_body get_body '}'  (#RULE#)
acceptable tokens are: 
	SET (shift)