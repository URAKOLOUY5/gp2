from tree_sitter import Language, Parser

from vscriptconvert import SquirrelParser

src1 = b"""
    // Hello hello
    // hello
    local test = 1;
    local test2 = "hello"
    local test2_verbatin = @"
        hello verbatim
    "
    local test3 = 'c'
    local test4 = 4.2;
    local test5 = true;
    local test6 = [2,3,4,5,null]
    local test7  = {test = 1, state = false}
    local test8 = null
    global_var <- 5;
"""

parser = SquirrelParser()
parser.parseCode(src1)