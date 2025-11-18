#Covers: try/except/else/finally, raising exceptions, custom exceptions, built-in exceptions


def error_handling() -> None:
    
    #============================================================
    #BASIC TRY/EXCEPT
    #============================================================
    
    #Catch specific exception
    try:
        numbers: list[int] = [1, 2, 3]
        result = numbers[10] / 0
    except ZeroDivisionError:
        print("Division by zero")
    except IndexError:
        print("Index out of range")

    #Catch and use exception object
    try:
        result = 10 / 0
    except ZeroDivisionError as e:
        print(f"Error occurred: {e}")
    
    #Multiple exceptions, same handler
    try:
        result = int("abc")
    except (ValueError, TypeError) as e:
        print(f"Conversion error: {e}")
    
    #Catch all exceptions
    try:
        result = 10 / 0
    except Exception as e:
        print(f"Something went wrong: {e}")
    
    
    #============================================================
    #TRY/EXCEPT/ELSE/FINALLY
    #============================================================
    
    #else - runs if NO exception happens
    #finally - ALWAYS runs, even if exception occurs
    try:
        result = 10 / 2
    except ZeroDivisionError:
        print("Error")
    else:
        print("No error occurred")
    finally:
        print("Always runs")
    
    
    #============================================================
    #RAISING EXCEPTIONS
    #============================================================
    
    #Raise built-in exception
    def check_age(age: int) -> None:
        if age < 0:
            raise ValueError("Age cannot be negative")
        if age < 18:
            raise ValueError("Must be 18 or older")
    
    try:
        check_age(-5)
    except ValueError as e:
        print(f"Invalid age: {e}")
    
    #Re-raise exception after logging
    try:
        result = 10 / 0
    except ZeroDivisionError as e:
        print("Logging error...")
        raise #Re-raises the same exception
    
    
    #============================================================
    #CUSTOM EXCEPTIONS
    #============================================================
    
    #Basic custom exception
    class InvalidPasswordError(Exception):
        pass
    
    #Custom exception with additional data
    class InsufficientFundsError(Exception):
        """Raised when account has insufficient funds"""
        def __init__(self, balance: float, amount: float) -> None:
            self.balance: float = balance
            self.amount: float = amount
            message: str = f"Insufficient funds: balance={balance}, needed={amount}"
            super().__init__(message)
    
    #Using custom exceptions
    def withdraw(balance: float, amount: float) -> float:
        if amount > balance:
            raise InsufficientFundsError(balance, amount)
        return balance - amount
    
    try:
        new_balance: float = withdraw(100.0, 150.0)
    except InsufficientFundsError as e:
        print(f"Cannot withdraw: {e}")
        print(f"Balance: {e.balance}, Requested: {e.amount}")
    
    
    #============================================================
    #COMMON BUILT-IN EXCEPTIONS
    #============================================================
    
    
    try:
        pass
    except ValueError: #ValueError - invalid value
        pass
    except TypeError: #TypeError - wrong type
        pass
    except KeyError: #KeyError - dict key doesn't exist
        pass
    except IndexError: #IndexError - list index out of range
        pass
    except AttributeError: #AttributeError - attribute doesn't exist
        pass
    except FileNotFoundError: #FileNotFoundError - file doesn't exist
        pass
    except ZeroDivisionError: #ZeroDivisionError - division by zero
        pass
    except ImportError: #ImportError - module not found
        pass
    except AssertionError: #AssertionError - a variable is not the expected type
        pass
    except StopIteration: #StopIteration - The iterator has run out of values
        pass
    
    #============================================================
    #EXCEPTION CHAINING
    #============================================================
    
    #from - shows original cause
    try:
        try:
            result = int("abc")
        except ValueError as e:
            raise TypeError("Failed to process") from e
    except TypeError as e:
        print(f"Error: {e}")
        print(f"Original cause: {e.__cause__}")
    
    #Suppress original exception with from None
    try:
        result = int("abc")
    except ValueError:
        raise TypeError("Custom error") from None #Hides ValueError
    
    
    #============================================================
    #ASSERTIONS
    #============================================================
    
    #Assert - raises AssertionError if condition False
    def calculate_average(numbers: list[int]) -> float:
        assert len(numbers) > 0, "List cannot be empty"
        return sum(numbers) / len(numbers)
    
    try:
        avg: float = calculate_average([])
    except AssertionError as e:
        print(f"Assertion failed: {e}")
    
    #Assertions can be disabled with python -O flag
    #Don't use for data validation in production!
    
    
    #============================================================
    #CONTEXT MANAGERS (with statement)
    #============================================================
    
    #"with __ as __: " is a Context Manager that causes a File automatically closes even if exception occurs
    try:
        with open("data.txt", "r") as file:
            content = file.read()
            result = 10 / 0 #Exception!
            #file.close() automatically called in finally block
    except ZeroDivisionError:
        print("Error occurred but file was closed safely")
    

if __name__ == "__main__":
    error_handling()