import sys
import re

def calculate(expression):
    try:
        # Clean and validate the expression
        expression = expression.strip()
        print(f"Received expression: {expression}")
        
        if not expression:
            return "0"
        
        # Only allow numbers and basic operators
        if not re.match(r'^[\d\+\-\*\/\(\)\.\s]*$', expression):
            return "Error: Invalid characters"
        
        # Evaluate the expression
        result = eval(expression, {"__builtins__": {}}, {})
        print(f"Calculated result: {result}")
        
        # Format the result
        if isinstance(result, (int, float)):
            if float(result).is_integer():
                return str(int(result))
            return f"{result:.8f}".rstrip('0').rstrip('.')
            
        return "Error: Invalid result"
        
    except ZeroDivisionError:
        return "Error: Division by zero"
    except SyntaxError:
        return "Error: Invalid syntax"
    except Exception as e:
        print(f"Error occurred: {str(e)}")
        return f"Error: {str(e)}"

if __name__ == '__main__':
    print("Calculator script started")
    print(f"Arguments: {sys.argv}")
    
    if len(sys.argv) > 1:
        expression = sys.argv[1]
        result = calculate(expression)
        print(f"Final result: {result}")
        print(result)  # This is what gets returned to Flutter
    else:
        print("Error: No expression provided")
