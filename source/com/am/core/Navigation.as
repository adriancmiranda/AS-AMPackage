package com.am.core {
	import com.am.utils.Cleaner;
	import com.am.events.Note;
	import com.am.display.ISection;
	import com.am.nsapplication;

	import com.greensock.TweenLite;
	import com.greensock.TweenMax;

	import flash.display.DisplayObjectContainer;
	import flash.display.DisplayObject;
	import flash.events.Event;

	/**
	 * @author Adrian C. Miranda <adriancmiranda@gmail.com>
	 > TODO: Subsections manager
	 */
	use namespace nsapplication;
	public final class Navigation extends NavigationData {
		private var _isInterrupted:Boolean;
		private var _transitionState:int;
		private var _section:ISection;
		private var _fresh:ISection;

		public function Navigation(key:String = null) {
			super(key);
		}

		public static function getInstance(key:String = null):Navigation {
			if (!hasInstance(key)) instances[key] = new Navigation(key);
			return instances[key] as Navigation;
		}

		public static function classes(...rest:Array):void {
			// no need to do anything - we just want to force the classes to get compiled in the swf.
		}

		override protected function stackTransition(view:View, params:Object = null):void {
			try {
				this._fresh = new view.caste();
				this._fresh.apiKey = super.apiKey;
				this._fresh.name = view.className;
				if (this._section) {
					//super.stop(true);
					this._section.transitionOut();
				} else {
					//this._section = new view.caste();
					//this._section.apiKey = super.apiKey;
					//this._section.name = view.className;
					this._section = this._fresh;
					this._section.addEventListener(Note.TRANSITION_IN, this.onSectionTransitionIn);
					this._section.addEventListener(Note.TRANSITION_IN_COMPLETE, this.onSectionTransitionInComplete);
					this._section.addEventListener(Note.TRANSITION_OUT, this.onSectionTransitionOut);
					this._section.addEventListener(Note.TRANSITION_OUT_COMPLETE, this.onSectionTransitionOutComplete);
					super.container.addEventListener(Event.ADDED, onSectionAdded);
					super.container.addChild(DisplayObject(this._section));
				}
			} catch(event:Error) {
				trace('[ApplicationFacade]::stackTransition:', event.message);
			}
		}

		private function onSectionAdded(event:Event):void {
			super.container.removeEventListener(Event.ADDED, onSectionAdded);
			this._section.transitionIn();
		}

		private function onSectionTransitionIn(event:Note):void {
			if (this._section) this._section.removeEventListener(Note.TRANSITION_IN, this.onSectionTransitionIn);
			this._transitionState |= 1;
			this._isInterrupted = true;
		}

		private function onSectionTransitionInComplete(event:Note):void {
			if (this._section) this._section.removeEventListener(Note.TRANSITION_IN_COMPLETE, this.onSectionTransitionInComplete);
			this._transitionState &= 2;
			this._isInterrupted = false;
		}

		private function onSectionTransitionOut(event:Note):void {
			if (this._section) this._section.removeEventListener(Note.TRANSITION_OUT, this.onSectionTransitionOut);
			this._transitionState |= 2;
			this._isInterrupted = true;
		}

		private function onSectionTransitionOutComplete(event:Note):void {
			if (this._section) this.killSection();
		}

		private function killSection(flush:Boolean = false):void {
			this._transitionState &= 1;
			this._isInterrupted = false;
			TweenMax.killTweensOf(this._section);
			TweenMax.killChildTweensOf(DisplayObjectContainer(this._section));
			TweenMax.killDelayedCallsTo(this._section);
			TweenLite.killTweensOf(this._section);
			TweenLite.killDelayedCallsTo(this._section);
			Cleaner.kill(DisplayObjectContainer(this._section));
			this._section = null;
			if (!flush) {
				this.stackTransition(super.view);
			}
		}

		private function onInterruptTransition():void {
			var transitionDirection:String = new String();
			if (this._transitionState & 1) transitionDirection = 'IN';
			if (this._transitionState & 2) transitionDirection += 'OUT';
			if (transitionDirection == 'INOUT') transitionDirection = 'CROSS';
			trace('>>> INTERRUPT ' + transitionDirection + ' <<<');
			TweenLite.to(this._section, 0.2, { alpha:0, onComplete:this.killSection, overwrite:0 } );
		}

		public function get section():ISection {
			return this._section;
		}

		public function get birth():ISection {
			return this._fresh;
		}

		override public function dispose(flush:Boolean = false):void {
			if (flush) {
				if (this._section) {
					this.killSection(flush);
				}
			}
			super.dispose(flush);
		}

		override public function toString():String {
			return '[Navigation ' + super.apiKey + ']';
		}
	}
}
