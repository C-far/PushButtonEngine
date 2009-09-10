/*
 *	  File name: LogViewerAS.as
 *	     Author: Nate Beck (blog.natebeck.net)
 *		   Date: 09/05/2009
 * 	Description: An ActionScript only version of the LogViewer.
 */
package com.pblabs.engine.debug.log4PBE
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;

	public class LogViewerAS extends Sprite implements ILogAppender
	{
		protected var _messageQueue:Array = [];
		protected var _maxLength:uint = 200000;
		protected var _truncating:Boolean = false;
		
		protected var _output:TextField;
		
		public function LogViewerAS(consoleHeight:uint=150, consoleWidth:uint=500):void
		{
			addChild(newOutputField(consoleHeight, consoleWidth));
		}
		
		protected function newOutputField(outputHeight:uint, outputWidth:uint):TextField
		{
			_output = new TextField();
			_output.type = TextFieldType.DYNAMIC;
			_output.border = true;
			_output.borderColor = 0;
			_output.background = true;
			_output.backgroundColor = 0xFFFFFF;
			_output.height = outputHeight;
			_output.width = outputWidth;
			_output.wordWrap = true;
			var format:TextFormat = _output.getTextFormat();
			format.font = "_typewriter";
			format.size = 8;
			_output.setTextFormat(format);
			_output.defaultTextFormat = format;
			
			return _output;
		}
		
		protected function truncateOutput():void
		{
			if (_output.text.length > maxLength){
				_output.text = _output.text.slice(-maxLength);
				if(!_truncating)
				{
					_truncating = true;
					Logger.getLogger(UIAppender).warn("You have exceeded "+_maxLength+" characters in LogViewerAS. " +
						"It will now only show the latest "+_maxLength+" characters of the log.");
				}
			}
		}

		public function addLogMessage(level:String, loggerName:String, errorNumber:int, message:String, arguments:Array):void
		{
			var numberString:String = "";
			if (errorNumber >= 0)
				numberString = " - " + errorNumber;
			
			var text:String = level + ": " + loggerName + numberString + " - " + message;
			if (_output)
			{
				_output.appendText(text + "\n");
				truncateOutput();
				
				_output.scrollV = _output.maxScrollV;
			}
		}

		public function get maxLength():uint
		{
			return _maxLength;
		}

		public function set maxLength(value:uint):void
		{
			_maxLength = value;
			truncateOutput();
		}

	}
}