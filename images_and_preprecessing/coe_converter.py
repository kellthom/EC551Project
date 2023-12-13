#Set to desired filenames
read_file=open("grayscale_image_data_640.txt")
write_file=open("coe2.txt","w")

lines=read_file.readlines()

write_file.write("memory_initialization_radix=16;\n")
write_file.write("memory_initialization_vector=\n")

for i in range(len(lines)):
    data=lines[i][0:2]
    if i==len(lines)-1:
        write_file.write(data+";\n")
    else:
        write_file.write(data+",\n")

read_file.close()
write_file.close()