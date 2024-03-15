
# find the top 20 sized direcotires in the current dirctory
du -mh . | sort -nr | head -n 20
