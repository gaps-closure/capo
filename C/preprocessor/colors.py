class Colors:
    pref = "\033["
    reset = f"{pref}0m"
    black = "30m"
    red = "31m"
    green = "32m"
    yellow = "33m"
    blue = "34m"
    magenta = "35m"
    cyan = "36m"
    white = "37m"
def format(text: str, color: str = Colors.white) -> str:
    return f"{Colors.pref}{color}{text}{Colors.pref}{Colors.reset}"