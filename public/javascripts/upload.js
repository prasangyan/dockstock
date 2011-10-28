
var queueBytesLoaded = 0;
var queueBytesTotal = 0;
var myQueue = null;
var IsUploadStarted = false;
var queueChangeHandler = function(queue){
	// alert('Uploading Started');
	myQueue = queue;
	// console.log("COLLECTION CHANGE!");
	var list = document.getElementById('file_todo_list');
	// Clear out the old
	while (list.hasChildNodes()){list.removeChild(list.firstChild);}
	// Add the new
	for (i=0;i<queue.files.length;i++)
	{
		addFileToTodoList(queue.files[i].name, queue.files[i].size, i);
	}
    if(!IsUploadStarted)
    {
        //s3_swf_1_object.startUploading();
        IsUploadStarted = true;
    }
};

var uploadingStartHandler = function(){
	queueBytesTotal = 0;
	queueBytesLoaded = 0;
	for (i=0;i<myQueue.files.length;i++)
	{
		queueBytesTotal += parseInt(myQueue.files[i].size);
	}
	//document.getElementById('queue_size').innerHTML = readableBytes(queueBytesTotal);
};

var uploadingFinishHandler = function(){
	//document.getElementById('overall').firstChild.style.width = '100%';
	//document.getElementById('overall').firstChild.firstChild.innerHTML = '100%';
    //IsUploadStarted = true;
    //alert('All files have been successfully uploaded');
};

var queueClearHandler = function(queue){
	//document.getElementById('overall').firstChild.style.display = 'none';
	//document.getElementById('overall').firstChild.style.width = '0%';
	//document.getElementById('overall').firstChild.firstChild.innerHTML = '0%';
	var list = document.getElementById('file_done_list');
	while (list.hasChildNodes()){list.removeChild(list.firstChild);}
};

var addFileToDoneList = function(file_name, file_size){
	var list = document.getElementById('file_done_list');
	var li = document.createElement("li");
	li.innerHTML =
		'<span class="progress"><span class="amount">100%</span></span>'+
		'<span class="file_name">'+file_name+'</span>'+
		'<span class="file_size">'+readableBytes(file_size)+'</span>';
	list.appendChild(li);
};

var addFileToTodoList = function(file_name, file_size, index){
	var list = document.getElementById('file_todo_list');
	var li = document.createElement("li");
	li.innerHTML =
		'<span class="progress"><span class="amount">0%</span></span>'+
		'<span class="file_name">'+file_name+'</span>'+
		'<span class="file_size">'+readableBytes(file_size)+'</span>'+
		'<span class="delete" onclick="javascript:s3_swf_1_object.removeFileFromQueue('+index+');">Delete</span>';
	list.appendChild(li);
};

var progressHandler = function(progress_event){
	document.getElementById('file_todo_list').firstChild.children[3].style.display = 'none';
	var current_percentage = Math.floor((parseInt(progress_event.bytesLoaded)/parseInt(progress_event.bytesTotal))*100)+'%';
	document.getElementById('file_todo_list').firstChild.firstChild.style.display = 'block';
	document.getElementById('file_todo_list').firstChild.firstChild.style.width = current_percentage;
	document.getElementById('file_todo_list').firstChild.firstChild.firstChild.innerHTML = current_percentage;

	var overall_percentage = Math.floor(((queueBytesLoaded+parseInt(progress_event.bytesLoaded))/queueBytesTotal)*100)+'%';
	document.getElementById('overall').firstChild.style.display = 'block';
	document.getElementById('overall').firstChild.style.width = overall_percentage;
	document.getElementById('overall').firstChild.firstChild.innerHTML = overall_percentage;
};

var uploadCompleteHandler = function(upload_options,event){
	queueBytesLoaded += parseInt(upload_options.FileSize);
	addFileToDoneList(upload_options.FileName,upload_options.FileSize);
};

var readableBytes = function(bytes) {
	var s = ['bytes', 'kb', 'MB', 'GB', 'TB', 'PB'];
	var e = Math.floor(Math.log(bytes)/Math.log(1024));
	return (bytes/Math.pow(1024, Math.floor(e))).toFixed(2)+" "+s[e];
};

