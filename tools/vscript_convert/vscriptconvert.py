import re
from ast import parse

from tree_sitter import Parser, Language, Tree, Node

class SquirrelParser:
    GRAMMAR = Language('built_grammars/ts_squirrel.dll', 'squirrel')
    parser: Parser = Parser()
    tree: Tree = None
    result = []

    def __init__(self):
        self.parser = Parser()
        self.parser.set_language(SquirrelParser.GRAMMAR)

    def parse_node(self, node: Node, indent=0):
        #print(node.type)

        match node.type:
            # return statement used to prevent iterating over children
            # because there's no children in that node

            case 'comment':
                self.result.append(node.text.replace(b'//', b'--'))
                self.result.append(b'\n')

            # Uses child loop
            case 'local_declaration':
                for child in node.children: self.parse_node(child)
                self.result.append(b'\n')

            # Uses child loop
            case 'update_expression':
                for child in node.children: self.parse_node(child)
                self.result.append(b'\n')

            # - variables -
            case 'identifier':
                if node.parent and node.parent.type == 'table_slot':
                    self.result.append(b'["' + node.text + b'"]')
                else:
                    self.result.append(node.text)

            case 'integer':
                self.result.append(node.text)

            case 'float':
                self.result.append(node.text)

            case 'string':
                self.result.append(node.text)

            case 'verbatim_string':
                verbatim_lua = re.sub(rb'@\"(.*?)\"', rb'[[\1]]', node.text, flags=re.DOTALL)
                self.result.append(verbatim_lua)

            case 'char':
                self.result.append(node.text)

            case 'bool':
                self.result.append(node.text)

            case 'table':
                self.result.append(b'{')
                for element in node.children:
                    self.parse_node(element)
                self.result.append(b'}')

            case 'array':
                self.result.append(b'{')
                for element in node.children:
                    self.parse_node(element)
                self.result.append(b'}')

            case 'null':
                self.result.append(b'nil')

            # - punctuation -
            case ',':
                self.result.append(b', ')

            # - keywords -
            case 'local':
                self.result.append(b'local ')

            # - operators -
            case '=':
                self.result.append(b' = ')

            case '<-':
                self.result.append(b' = ')

            case '[':
                if node.parent.type != "array":
                    self.result.append('[')

            case ']':
                if node.parent.type != "array":
                    self.result.append(']')

            case _:
                for child in node.children: self.parse_node(child)

    def parseCode(self, src: bytes):
        self.tree = self.parser.parse(src)
        self.parse_node(self.tree.root_node)

        print(b''.join(self.result).decode())