﻿package {		import flash.display.*;	import flash.events.*;	import flash.text.*;		import flash.external.ExternalInterface;	import flash.net.FileReference;	import flash.net.FileReferenceList;	import flash.net.FileFilter;	import flash.net.URLRequest;	import flash.utils.Timer;	import flash.events.TimerEvent;		public class AjaxFileUpload extends MovieClip {				var singleFileRef:FileReference;		var multiFileRef:FileReferenceList;		var file:*;		var allowedContentTypes:Array;		var fileSizeLimit:Number = 100000000;		var request:URLRequest;		var timer:Timer;		var speed:Number = 0;		var currentBytes:Number = 0;		var totalBytes:Number = 0;		var settings:Object = LoaderInfo(stage.loaderInfo).parameters;				public function AjaxFileUpload() {						if (!settings.url) {				settings.url = "";			}						if (!settings.method) {				settings.method = "post";			}						if (!settings.multiple) {				singleFileRef = new FileReference();				file = singleFileRef;			} else {				multiFileRef = new FileReferenceList();				file = multiFileRef;			}			request = new URLRequest();			request.url = settings.url;			request.method = settings.method;			timer = new Timer(1000);						setupButton();			bindEvents();			bindJSEvents();						return;					}				private function setupButton():void {			select_btn.useHandCursor = true;			select_btn.alpha = 0;			select_btn.x = 0;			select_btn.y = 0;			select_btn.width = this.root.width;			select_btn.height = this.root.height;		}		private function bindJSEvents() {			//ExternalInterface.callback("upload");		}      				private function bindEvents() {			select_btn.addEventListener(MouseEvent.CLICK, triggerBrowseDialog);				file.addEventListener(Event.CANCEL, onCancel);			file.addEventListener(Event.COMPLETE, onComplete);			file.addEventListener(IOErrorEvent.IO_ERROR, onError);			file.addEventListener(Event.OPEN, onOpen);			file.addEventListener(ProgressEvent.PROGRESS, onProgress);			file.addEventListener(Event.SELECT, onSelection);			file.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, onCompleteData);		}		private function triggerBrowseDialog(e:MouseEvent) {    		//fileRef.browse(new Array( new FileFilter( "Images (*.jpg, *.jpeg, *.gif, *.png)", "*.jpg;*.jpeg;*.gif;*.png" )));			file.browse();			}				private function onCancel(e:Event) {}				private function onComplete(e:Event) {			trace("complete");		}				private function onError(e:IOErrorEvent) {			ExternalInterface.call("AjaxFileUploadProxy", ["onError", e]);		}				private function onOpen(e:Event) {			timer.start();		}				private function onProgress(e:ProgressEvent) {			currentBytes = e.bytesLoaded;			totalBytes = e.bytesTotal;		}				private function onSelection(e:Event) {			if (validateFile(file)) {				file.upload(request);			}		}		private function onCompleteData(e:DataEvent) {			trace("complete");			trace(e.data);			log_txt.text = e.data;			timer.stop();		}				private function validateFile(file:FileReference) {			return (file.size > fileSizeLimit);		}			}	}