package sample.pages {
	import sample.components.*;

	import com.am.core.*;
	import com.am.display.*;
	import com.am.errors.*;
	import com.am.events.*;
	import com.am.media.*;
	import com.am.net.*;
	import com.am.text.*;
	import com.am.ui.*;
	import com.am.utils.*;

	import com.greensock.plugins.*;
	import com.greensock.loading.*;
	import com.greensock.events.*;
	import com.greensock.easing.*;
	import com.greensock.*;

	import flash.display.*;
	import flash.system.*;
	import flash.events.*;
	import flash.utils.*;
	import flash.media.*;
	import flash.geom.*;
	import flash.text.*;
	import flash.net.*;
	import flash.ui.*;

	public final class Contact extends SectionLite {

		public function Contact() {
			super(false, false, null);
		}

		override protected function initialize():void {
			trace('Contact initialised!')
		}

		override protected function finalize():void {
			// N/A yet.
		}

		override public function transitionIn():void {
			super.transitionIn();
			TweenLite.to(this, 0.4, { alpha:1, onComplete:transitionInComplete });
		}

		override public function transitionOut():void {
			super.transitionOut();
			TweenLite.to(this, 0.4, { alpha:0, onComplete:transitionOutComplete });
		}

		override public function arrange():void {
			// N/A yet.
		}
	}
}
