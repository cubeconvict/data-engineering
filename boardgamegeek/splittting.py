import re

def parse_bgg(mystring):
    pattern = re.compile(r"""(?P<name>.*?) #everything up to the open paren is the name
                        \((?P<year>\d{4})\) #everything between the parentheses is the name, this will need to be changed to look for four digits
                        (?P<description>.*) #from the close paren to the end
                        """, re.VERBOSE)

    match = pattern.match(mystring)
    name = match.group("name")
    year = int(match.group("year"))
    description = match.group("description")
    return(name,year,description)

#test
mystring = "Brass: Birmingham(2018)Build networks, grow industries, and navigate the world of the Industrial Revolution."

returned_data = parse_bgg(mystring)
print("Name: ", returned_data[0])
print("Year: ",returned_data[1])
print("Description: ",returned_data[2])

