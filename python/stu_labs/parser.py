class Parser:
    OK, ERROR = "OK", "ERROR"
    eof = "eof"


    def parse(self, dummy_self, string:str):
        """assuming 'string' is not null and not of zero length"""
        tag = self.OK
        result = string[0]
        leftover = string[1:]
        return tag, result, leftover

    
    def __call__(self, string:str) -> (str, str, str):
        """
        Parser-Combiner for string parsing. Takes a string as input,
        scans it from beginning, parses known expressions and leaves other unused 
        : param string: string to be parsed
        : return: tag, result, leftover
        tag - OK if parsed successfully, else ERROR
        result - Parser result if everything OK, else - error message
        leftover - unused remainder of input expression
        """
        if not string:
            return self.ERROR, self.eof, string
        return self.parse(self, string)


    def __init__(self, parse_func):
        if parse_func != None:
            self.parse = parse_func
        else:
            print("warning: initializing Parser with default parsing method")


def any_of(symbols:str):
        def inner(self, input_str):
            first_char = input_str[0]
            if first_char not in symbols:
                return self.ERROR, "expected any of '" + symbols + "', got " + first_char, input_str
            return self.OK, first_char, input_str[1:]
        return inner

def test_any_of():
    symbols = ""
    p = Parser(any_of(symbols))
    tag, p_res, leftover = p("")
    assert tag == Parser.ERROR
    assert p_res == Parser.eof
    assert leftover == ""
    
    symbols = "abc"
    p = Parser(any_of(symbols))
    tag, p_res, leftover = p("ai")
    assert tag == Parser.OK
    assert p_res == "a"
    assert leftover == "i"
    tag, p_res, leftover = p("ia")
    assert tag == Parser.ERROR
    assert leftover == "ia"
    


def chain(*parsers):
    """
    : param parsers: list of Parser instances to be combined
    : return: superposition of parsers
    """
    def shallow_parse(self, input_str):
        return self.OK, "", input_str
    
    def inner(self, input_str):
        tag, res, leftover = shallow_parse(self, input_str)
        res_list = []
        for parser in parsers:
            tag, res, leftover = parser(leftover)
            res_list.append(res)
            if tag != Parser.OK:
                return tag, res_list, leftover
        return self.OK, res_list, leftover
    return inner


def test_chain():
    input_str = "()."

    p = Parser(chain())
    tag, res, leftover = p(input_str)
    assert tag == Parser.OK
    assert len(res) == 0
    assert leftover == input_str
    
    p1, p2 = Parser(any_of("(")), Parser(any_of(")"))
    p = Parser(chain(p1, p2))
    tag, res, leftover = p(input_str)
    assert tag == Parser.OK
    assert len(res) == 2
    assert res[0] == input_str[0]
    assert res[1] == input_str[1]
    assert leftover == input_str[2:]


def choice(*parsers):
    """
    : param parsers: list of Parser instances, each is applied to input string independently
    : return: result of first parser in 'parsers' that returns OK as a tag, else informs user about failure of all
    """
    choice.err_no_match = "none matched"
    
    def inner(self, input_str):
        for parser in parsers:
            tag, res, leftover = parser(input_str)
            if tag == Parser.OK:
                return tag, res, leftover
        return self.ERROR, choice.err_no_match, input_str
    return inner
                

def test_choice():
    p = Parser(choice(Parser(any_of(".")), Parser(any_of("!"))))
    for symbol in ".!?":
        tag, res, leftover = p(symbol)
        if symbol in ".!":
            assert tag == Parser.OK
            assert res == symbol
            assert leftover == ""
        else:
            assert tag == Parser.ERROR
            assert res == choice.err_no_match
            assert leftover == symbol


def many(parser, empty=True):
    """
    : param parser: a Parser instance which is to be applied to input string repeatedly until it returns ERROR
    : return: result - list of 'parser' results
    """
    def inner(self, input_str):
        res_list = []
        tag, res, leftover = parser(input_str)
        while tag == Parser.OK:
            res_list.append(res)
            tag, res, leftover = parser(leftover)
        if empty:
            return Parser.OK, res_list, leftover
        return Parser.ERROR, res, input_str # if 'empty'==false, returns error message returned by 'parser'
    return inner


def test_many():
    p = Parser(many(Parser(any_of("bcehiktrqu "))))
    input_str = "the quick red fox jumps over the lazy brown dog"
    tag, res, leftover = p(input_str)
    assert tag == Parser.OK
    assert len(res) == 12
    assert leftover == input_str[12:]    


if __name__ == "__main__":
    test_any_of()
    test_chain()
    test_choice()
    test_many()
    
