OPEN_PAREN = '('
CLOSE_PAREN = ')'
TOKENS = ['-', '+', '/', '*', '^']

MATH_FUNCTIONS = {
  '-' : (l, r) -> l - r
  '+' : (l, r) -> l + r
  '/' : (l, r) -> l / r
  '*' : (l, r) -> l * r
  '^' : Math.pow
}

class Node
  constructor : (val, l, r) ->
    @val = val
    @left = l
    @right = r


findToken = (string) ->
  for token in TOKENS
    return token if string.indexOf(token) > -1

split = (string, token) ->
    splitIndex = string.indexOf(token)
    [string[0...splitIndex], string[splitIndex + 1..-1]]
    
parensPresent = (string) ->
  openParenIndex = string.indexOf(OPEN_PAREN)
  closeParenIndex = string.indexOf(CLOSE_PAREN)
  openParenIndex > -1 and closeParenIndex > openParenIndex
  
getCloseParenIndex = (startIndex, string) ->
  openParensInBetween = 0
  
  for char, i in string[startIndex..-1]
      if openParensInBetween is 0 and char is CLOSE_PAREN
          return startIndex + i
      else if char is OPEN_PAREN
          openParensInBetween += 1
      else if char is CLOSE_PAREN and openParensInBetween > 0
          openParensInBetween -= 1
  
getParensSubstring = (string) ->
  startIndex = string.indexOf(OPEN_PAREN) + 1
  endIndex = getCloseParenIndex(startIndex, string) - 1
  string[startIndex..endIndex]

toTree = (string) ->
  return null if string.length < 0
  
  if parensPresent(string)
    substring = getParensSubstring(string)
    evaluatedString = string.replace("(#{substring})", evaluate(substring))
    toTree(evaluatedString)
  else
    if token = findToken(string)
      [left, right] = split(string, token)
      new Node(token, toTree(left), toTree(right))
    else
      new Node(string)

process = (node) ->
  isNumber = !isNaN(parseInt(node.val))

  if isNumber
    parseInt(node.val)
  else
    MATH_FUNCTIONS[node.val](process(node.left), process(node.right))  

evaluate = (input) -> process(toTree(input))

str = "((1 + 1) ^ (15 / (2 + 1 * 3))) + (1)" 
result = evaluate str

console.log "#{str} = #{result}"
