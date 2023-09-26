import re
from bs4 import BeautifulSoup

def Convert(myobject):
    li = list(myobject.splitlines())
    return li

# Read in the Google exported html page
with open("myfile.html", "r") as og_file:
    og_file_contents = og_file.read()
    #delete the google search prepend they added
    og_file_contents = og_file_contents.replace("https://www.google.com/url?","")
    
    #replace all commas with carets for now
    og_file_contents = re.sub("\,","^", og_file_contents)
    #Don't forget to add quotes to escape commas later
    
    #delete the head
    og_file_contents = re.sub("<head(.*)>.*</head>","",og_file_contents)

    #delete the table
    og_file_contents = re.sub("<table(.*)>(.*)</table>","",og_file_contents)

    #break lines at each Heading 2
    og_file_contents = re.sub('<h2(.*?)><span class="c7 c5">','\n',og_file_contents)
    #put in a comma where the h2 closes
    og_file_contents = re.sub('</span></h2>',',',og_file_contents)
    #insert a comma where each li starts
    og_file_contents = re.sub('<li class="c0 li-bullet-0"><span>',',',og_file_contents)
    #TODO trim some span crap, but this method creates a comma which splits the list too soon
    #og_file_contents = re.sub('</span><span class="c4"><a class="c10" ','',og_file_contents)

        
    #og_file_contents = re.sub('</span><span class=\"c4\"><a class=\"c10\" href=\"q=',',',og_file_contents)
    #og_file_contents = re.sub('</a></span></li>.*\n','\n', og_file_contents)
    #og_file_contents = re.sub("<span class=\"c7 c5\">(.*)</span>","\1\n",og_file_contents)

    #TODO create a list where [0] is the date and [1] is the rest of the line
    #turn each line into a list item
    og_file_list = Convert(og_file_contents)


    #split each line into a list with date at the first index [0][1]....[0][n]
    
    final_file_list = []
    #make each line a list
    for each_line in og_file_list:
        each_line = each_line.split(",")
        #assign the date to a variable so we can reuse it to build one line at a time
        application_date = each_line[0]
        for each_element in each_line:
            new_line_list = []
            #trim out the crap in the second element
            each_element = re.sub(': </span><span class="c4"><a class="c10" href="q=',',',each_element)
            each_element = re.sub('">',',',each_element)

            new_line_list.append(application_date)
            new_line_list.append(each_element) #this should
            final_file_list.append(new_line_list)

    
    #write the output csv
    with open('output.csv', "w+") as writefile:
        for line in final_file_list:
            if line[0]!=line[1]:
                for each_item in line:
                    this_line = ','.join(line)
                writefile.write("%s\n" % this_line)