#ifndef KIRAZ_AST_LITERAL_H
#define KIRAZ_AST_LITERAL_H

#include <kiraz/Node.h>

namespace ast {
class Integer : public Node {
public:
    Integer(Token::Ptr);

    std::string as_string() const override {return fmt::format("Integer({})", m_value);}
private:
    int64_t m_value;
};
class Integer2 : public Node {
public:
    Integer2(Token::Ptr);

    std::string as_string() const override {return fmt::format("Int(10,{})", m_value);}
private:
    int64_t m_value;
};

class SignedNode : public Node {
public:
    SignedNode(int op, Node::Cptr operand) : Node(L_INTEGER), m_operator(op), m_operand(operand) {}
    std::string as_string() const override {
        return fmt::format("Integer'({}, {})", m_operator, m_operand->as_string());
    }
private:
    int m_operator;
    Node::Cptr m_operand;
};

class Type : public Node {
public:
    Type(Token::Ptr);

    std::string as_string() const override {return fmt::format("Type({})", m_value);}
private:
    std::string m_value;
};

class Identifier : public Node {
public:
    Identifier(Token::Ptr);

    std::string as_string() const override {return fmt::format("Identifier({})", m_value);}
private:
    std::string m_value;
};

class String : public Node {
public:
    String(Token::Ptr);

    std::string as_string() const override {return fmt::format("Str({})", m_value);}
private:
    std::string m_value;
};
}

#endif
