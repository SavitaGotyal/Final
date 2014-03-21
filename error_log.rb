#!/usr/bin/ruby
require 'rubygems'
require 'mongo'
include Mongo

db   = Connection.new.db('Error_db1')
coll = db.collection('Error_Info_db')
coll1 = db.collection('Knowledge_db')
arr = IO.readlines("error.log")
len=arr.size
i = 0 
log=File.open("intermediate.txt","w")
   for i in (0...len)
	if( arr[i] =~ /(.+)Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec/)
		log.syswrite(arr[i])
		log.syswrite(arr[i+1])
		log.syswrite(arr[i+2])
		log.syswrite("\n")
		
	end
   end
array = IO.readlines("intermediate.txt")
len=array.size

coll.remove
id=0;
i=1;
while(i < len)
	date=array[i-1].match(/ [Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec](.+)[AM|PM]/).to_s
	second_line_words=array[i].split(":")
	length1=second_line_words.size
	error_type=second_line_words[1]
	client_name=second_line_words[length1-2]
	doc_id_arr = second_line_words[length1-1].split(" ")
	doc_id = doc_id_arr[0]
	third_line_words=array[i+1].split(":")
	length =third_line_words.size
	error_name=third_line_words[length-1].delete("\n")
	error_msg=array[i+1].sub!(/attempt(.+?):/, "").delete("\n")
	coll.insert({'ERROR_ID' => id, 'DATE' => date, 'CLIENT_NAME' => client_name, 'ERROR_TYPE' => error_type,'ERROR_NAME' => error_name,'ERROR_MSG' => error_msg, 'Document_Id' => doc_id })
	id+=1	
	i+=4
	
end

coll1.remove
j=0

distinct_error_type = coll.distinct('ERROR_TYPE')
distinct_error_name= coll.find({"ERROR_TYPE" => distinct_error_type[0]}, {:fields=>{'ERROR_NAME' => 1,'_id'=>0}}).to_a
distinct_error_name=distinct_error_name.uniq
print(distinct_error_name)
i=0
l1=distinct_error_type.size
l2=distinct_error_name.size

#print(l2)
while(i< l1)
	while(j< l2)
		coll1.insert({'ERROR_TYPE' =>distinct_error_type[i],'ERROR_NAME' =>distinct_error_name[j]})
		
		print("\n")
		print(distinct_error_type[i])
		print("\t")
		print(distinct_error_name[j])
		print("\n")		
		j+=1

						
	end
	i+=1
end





  

