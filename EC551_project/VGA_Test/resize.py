def resize(width_old, height_new, width_new):
    old_file=open("grayscale_image_data.txt")
    new_file=open("grayscale_image_data_output.txt","w")
    height_count=0
    width_count=0

    lines=old_file.readlines()

    for i in range(len(lines)):

        #If the new height is achieved, we are done
        if height_count==height_new:
            new_file.close()
            old_file.close()
            break

        #If the new width is reached
        if width_count==width_new:

            i+=(width_old-width_new)#Skip the rest

            width_count=0 #new line
            height_count+=1


        new_file.write(lines[i])
        width_count+=1

resize(768,480,640)
