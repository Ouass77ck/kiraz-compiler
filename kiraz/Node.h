#ifndef KIRAZ_NODE_H
#define KIRAZ_NODE_H

#include <cassert>
#include <vector>
#include <fmt/format.h>
#include <kiraz/Token.h>

extern int yylineno;

class Node {
public:
    using Ptr = std::shared_ptr<Node>;
    using Cptr = std::shared_ptr<const Node>;

    Node() {}
    Node(int i) : m_id(i) {}
    
    virtual int get_id() const { return m_id; }
    virtual ~Node();

    virtual std::string as_string() const = 0;
    void print() { fmt::print("{}\n", as_string()); }

    static Ptr create_list();
    static Ptr append_to_list(const Ptr& list, const Ptr& stmt);

    void set_pos(int l, int c) {
        m_line = l;
        m_col = c;
    }

    template <typename T, typename... Args>
    static auto add(Args &&...args) {
        auto root = std::make_shared<T>(std::forward<Args>(args)...);
        root->set_pos(yylineno, Token::colno);
        s_roots.back() = root;
        return root;
    }

    static void reset_root() { s_roots.emplace_back(); }
    static auto &current_root() {
        assert(! s_roots.empty());
        return s_roots.back();
    }

private:
    static std::vector<Node::Ptr> s_roots;
    int m_id;
    int m_line = 0;
    int m_col = 0;
};

class NodeList : public Node {
public:
    NodeList() = default;

    void add_statement(const Node::Ptr& stmt) {
        m_statements.push_back(stmt);
    }

    const std::vector<Node::Ptr>& get_statements() const {
        return m_statements;
    }

    std::string as_string() const override {
        std::string result = "";
        for (const auto& stmt : m_statements) {
            result += stmt->as_string() + ", ";
        }
        if (!m_statements.empty()) {
            result.pop_back();
            result.pop_back();
        }
        result += "";
        return result;
    }

private:
    std::vector<Node::Ptr> m_statements;
};

inline Node::Ptr Node::create_list() {
    return std::make_shared<NodeList>();
}

inline Node::Ptr Node::append_to_list(const Ptr& list, const Ptr& stmt) {
    auto node_list = std::dynamic_pointer_cast<NodeList>(list);
    if (node_list) {
        node_list->add_statement(stmt);
    }
    return list;
}

#endif // KIRAZ_NODE_H
