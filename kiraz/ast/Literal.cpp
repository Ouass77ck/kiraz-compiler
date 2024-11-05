#include <cassert>
#include <kiraz/token/Literal.h>
#include "Literal.h"

namespace ast {
Integer::Integer(Token::Ptr t) :Node(L_INTEGER){
    assert(t->get_id()== L_INTEGER);
    auto token_int=std::static_pointer_cast<const token::Integer>(t);
    auto base = token_int->get_base();
    try{
        m_value=std::stoll(token_int->get_value(),nullptr,base);
    }
    catch (std::out_of_range &e){
        //TODO MARK THIS Node as invalide
    }
}

Type::Type(Token::Ptr t) : Node(TYPE) {
    assert(t->get_id() == TYPE);
    auto token_type = std::static_pointer_cast<const token::Type>(t);
    m_value = token_type->get_value();
}

Identifier::Identifier(Token::Ptr t) : Node(IDENTIFIER) {
    assert(t->get_id() == IDENTIFIER);
    auto token_identifier = std::static_pointer_cast<const token::Identifier>(t);
    m_value = token_identifier->get_value();
}

}
