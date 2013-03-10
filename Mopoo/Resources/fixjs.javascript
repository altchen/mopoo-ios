<script>
function process_image (){
	var allImage = document.getElementsByTagName("img");
	var urlArray = new Array();
	var allSize = allImage.length;
	var load_index = 0;
	for(var i = 0 ;i<allSize;i++){
		var currSrc = allImage[i].src;
		if(currSrc.indexOf("https://www.253874.com/new/ball")==0){
			allImage[i].src ="file:///android_asset/"+currSrc.substring(23,currSrc.length);
			continue;			
		}
		if(currSrc.indexOf("file:///new/ball")==0){
			allImage[i].src = currSrc.substring(0,8)+"android_asset/"+currSrc.substring(8,currSrc.length);
			continue;
		}
		if((currSrc.indexOf("https://")!=0 && currSrc.indexOf("http://")!=0) || currSrc.indexOf("https://www.253874.com")==0){
			allImage[i].id ="mopoo_load_"+load_index;
			urlArray.push(currSrc);
			load_index++;
		}
	}
	window.mopoo.fixedImage(urlArray);
}

try{
	process_image();
}catch(e){
}
function mopoo_show_img(index,path){
	var obj = document.getElementById("mopoo_load_"+index);
	if(obj != null){
		obj.src=path;
	}
}
</script>