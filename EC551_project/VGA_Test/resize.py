def resize(width_old, height_new, width_new):
    old_file=open("test.txt")
    new_file=open("test_output.txt","w")
    height_count=0
    width_count=0

    lines=old_file.readlines()

    i=0
    while(1):        

        #If the new width is reached
        if width_count==width_new:
            
            i+=(width_old-width_new)#Skip the rest

            width_count=0 #new line
            height_count+=1

            #If the new height is achieved, we are done
            if height_count==height_new:
                new_file.close()
                old_file.close()
                break

        
        new_file.write(lines[i])
        width_count+=1
        i+=1

resize(5,4,4)