/**
	\file "Object/inst/physical_instance_placeholder.h"
	$Id: physical_instance_placeholder.h,v 1.1.2.6 2006/09/11 22:31:06 fang Exp $
 */

#ifndef	__HAC_OBJECT_INST_PHYSICAL_INSTANCE_PLACEHOLDER_H__
#define	__HAC_OBJECT_INST_PHYSICAL_INSTANCE_PLACEHOLDER_H__

#include "Object/inst/instance_placeholder_base.h"

namespace HAC {
class cflat_options;
namespace entity {
class port_alias_tracker;
class state_manager;
class footprint_frame;
class port_collection_context;
class physical_instance_collection;
struct alias_visitor;
struct dump_flags;

//=============================================================================
/**
	Base class for physical entity placeholders, 
	as opposed to value placeholders.  
	We don't bother deriving from alias_visitee because the traversal
	is not polymorphic, yet we implement the require accept() interface.  
 */
class physical_instance_placeholder : public instance_placeholder_base {
private:
	typedef	physical_instance_placeholder	this_type;
	typedef	instance_placeholder_base	parent_type;
protected:
	typedef	parent_type::inst_ref_ptr_type	inst_ref_ptr_type;
	typedef	parent_type::member_inst_ref_ptr_type	
						member_inst_ref_ptr_type;
	typedef	parent_type::instance_relaxed_actuals_type
						instance_relaxed_actuals_type;
protected:
	physical_instance_placeholder() : parent_type() { }

	explicit
	physical_instance_placeholder(const size_t d) : parent_type(d) { }

	physical_instance_placeholder(const scopespace& o, const string& n, 
		const size_t d);

#if 0
	physical_instance_placeholder(const this_type& t, const footprint& f) :
		parent_type(t, f) { }
#endif

protected:
#if USE_INSTANCE_PLACEHOLDERS
virtual	MAKE_INSTANCE_COLLECTION_FOOTPRINT_COPY_PROTO = 0;
#endif

public:
virtual	~physical_instance_placeholder();

private:
	using parent_type::dump;	// don't intend to use directly

public:
	ostream&
	dump(ostream&, const dump_flags&) const;

virtual	ostream&
	dump_formal(ostream&) const = 0;

	size_t
	is_port_formal(void) const;

#define	UNROLL_PORT_ONLY_PROTO						\
	count_ptr<physical_instance_collection>				\
	unroll_port_only(const unroll_context&) const

virtual	UNROLL_PORT_ONLY_PROTO = 0;

	bool
	port_formal_equivalent(const this_type&) const;

// none of the following are appropriate for placeholders
#if 0
virtual bool
	is_partially_unrolled(void) const = 0;

virtual ostream&
	dump_unrolled_instances(ostream&, const dump_flags&) const = 0;

#define	ALLOCATE_LOCAL_INSTANCE_IDS_PROTO				\
	good_bool							\
	allocate_local_instance_ids(footprint&)

virtual	ALLOCATE_LOCAL_INSTANCE_IDS_PROTO = 0;

#define	CONNECT_PORT_ALIASES_RECURSIVE_PROTO				\
	good_bool							\
	connect_port_aliases_recursive(physical_instance_placeholder&)

virtual	CONNECT_PORT_ALIASES_RECURSIVE_PROTO = 0;

#define	CREATE_DEPENDENT_TYPES_PROTO					\
	good_bool							\
	create_dependent_types(void)

virtual	CREATE_DEPENDENT_TYPES_PROTO = 0;

#define	COLLECT_PORT_ALIASES_PROTO					\
	void								\
	collect_port_aliases(port_alias_tracker&) const

virtual	COLLECT_PORT_ALIASES_PROTO = 0;

#define	CONSTRUCT_PORT_CONTEXT_PROTO					\
	void								\
	construct_port_context(port_placeholder_context&, 		\
		const footprint_frame&) const

virtual	CONSTRUCT_PORT_CONTEXT_PROTO = 0;

#define	ASSIGN_FOOTPRINT_FRAME_PROTO					\
	void								\
	assign_footprint_frame(footprint_frame&,			\
		const port_placeholder_context&) const

virtual	ASSIGN_FOOTPRINT_FRAME_PROTO = 0;

virtual	void
	accept(alias_visitor&) const = 0;
#endif

virtual	count_ptr<meta_instance_reference_base>
	make_meta_instance_reference(void) const = 0;

protected:	// propagate to children
	using parent_type::collect_transient_info_base;
	using parent_type::write_object_base;
	using parent_type::load_object_base;
};	// end class physical_instance_placeholder

//=============================================================================
}	// end namespace entity
}	// end namespace HAC

#endif	// __HAC_OBJECT_INST_PHYSICAL_INSTANCE_PLACEHOLDER_H__
