package com.am.display {
    import com.am.display.IDisplay;
    import com.am.utils.Cleaner;

    import flash.events.Event;
    import flash.display.Shape;
    import flash.display.Scene;
    import flash.display.Sprite;
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.geom.Rectangle;
    import flash.geom.Point;

    /**
     * @author Adrian C. Miranda <adriancmiranda@gmail.com>
     > FIXME: Interface hierarchy to implements.
     > WARNING: @alpha tags are in test.
     */
    public class Leprechaun extends Nymph implements IDisplay/*, ISprite*/ {
    	private var _bounds:Rectangle = new Rectangle();
        private var _registrationPoint:Point;
        private var _registrationShape:Shape;
        private var _locked:Boolean;
        private var _dead:Boolean;

        public function Leprechaun() {
            super();
            this.moveRegistrationPoint(0, 0);
            super.addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage, false, 0, true);
            super.addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage, false, 0, true);
        }

        private function onAddedToStage(event:Event):void {
            super.removeEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage, false);
            this._bounds = super.getBounds(super);
			this.rotation = super.rotation;
            this.scaleX = super.scaleX;
            this.scaleY = super.scaleY;
            this.x = super.x;
            this.y = super.y;
        }

        private function onRemovedFromStage(event:Event):void {
            super.removeEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage, false);
            this.detachRegistrationPoint();
            this._bounds = null;
            this._dead = true;
        }

        public function moveRegistrationPoint(x:Number, y:Number):void {
            this._registrationPoint = new Point(x, y);
            if (this._registrationShape) {
                this._registrationShape.x = x;
                this._registrationShape.y = y;
            }
        }

        override public function set x(value:Number):void {
            if (super.parent) {
                var point:Point = super.parent.globalToLocal(super.localToGlobal(this._registrationPoint));
                super.x = super.x + (value - point.x);
            } else {
                super.x = value;
            }
        }

        override public function get x():Number {
            if (super.parent) {
                var point:Point = super.parent.globalToLocal(super.localToGlobal(this._registrationPoint));
                return point.x;
            }
            return super.x;
        }

        override public function set y(value:Number):void {
            if (super.parent) {
                var point:Point = super.parent.globalToLocal(super.localToGlobal(this._registrationPoint));
                super.y = super.y + (value - point.y);
            } else {
                super.y = value;
            }
        }

        override public function get y():Number {
            if (super.parent) {
                var point:Point = super.parent.globalToLocal(super.localToGlobal(this._registrationPoint));
                return point.y;
            }
            return super.y;
        }

        override public function get mouseX():Number {
            return Math.round(super.mouseX - this._registrationPoint.x);
        }

        override public function get mouseY():Number {
            return Math.round(super.mouseY - this._registrationPoint.y);
        }

        override public function set scaleX(value:Number):void {
            this.setProperty('scaleX', value);
        }

        override public function set scaleY(value:Number):void {
            this.setProperty('scaleY', value);
        }

        override public function set rotation(value:Number):void {
            this.setProperty('rotation', value);
        }

        // @alpha
        override public function set rotationX(value:Number):void {
            this.setProperty('rotationX', value);
        }

        // @alpha
        override public function set rotationY(value:Number):void {
            this.setProperty('rotationY', value);
        }

        private function setProperty(property:String, value:Number):void {
            if (super.parent) {
                var pointA:Point = super.parent.globalToLocal(super.localToGlobal(this._registrationPoint));
                super[property] = value;
                var pointB:Point = super.parent.globalToLocal(super.localToGlobal(this._registrationPoint));
                super.x = super.x - (pointB.x - pointA.x);
                super.y = super.y - (pointB.y - pointA.y);
            } else {
                super[property] = value;
            }
        }

        public function get registrationPoint():Point {
            return this._registrationPoint.clone();
        }

        public function move(x:Number, y:Number):void {
            this.x = Math.round(x);
            this.y = Math.round(y);
        }

        public function size(width:Number, height:Number):void {
            super.width = width;
            super.height = height;
        }

        public function set scale(value:Number):void {
            this.scaleX = this.scaleY = value;
        }

        public function fit(width:Number, height:Number):void {
            if (super.height < super.width) {
                fitY(height);
            } else {
                fitX(width);
            }
        }

        public function fitX(width:Number):void {
        	super.width = width;
            this.scaleY = this.scaleX;
            if (super.height < height) {
                super.height = height;
                this.scaleX = this.scaleY;
            }
        }

        public function fitY(height:Number):void {
        	super.height = height;
            this.scaleX = this.scaleY;
            if (super.width < width) {
                super.width = width;
                this.scaleY = this.scaleX;
            }
        }

        public function lock(value:Boolean, all:Boolean = false):void {
            this._locked = value;
            super.mouseEnabled = !value;
            super.mouseChildren = !value;
            super.tabEnabled = !value;
            super.doubleClickEnabled = !value;
            if (this.stage && all) {
                super.stage.mouseChildren = !value;
            }
        }

        public function get locked():Boolean {
            return this._locked;
        }

		public function get originBounds():Rectangle {
			return this._bounds ? this._bounds.clone() : new Rectangle();
		}

        public function set showRegistrationPoint(value:Boolean):void {
            value ? this.attachRegistrationPoint(5) : this.detachRegistrationPoint();
        }

        override public function addChild(child:DisplayObject):DisplayObject {
            var holder:DisplayObject;
            try {
                holder = super.addChild(child);
                super.dispatchEvent(new Event(Event.RESIZE));
            } catch(event:Error) {
                trace(this.toString() + 'addChild(' + event.message + ');');
            }
            return holder;
        }

        override public function addChildAt(child:DisplayObject, index:int):DisplayObject {
            var holder:DisplayObject;
            try {
                holder = super.addChildAt(child, index);
                super.dispatchEvent(new Event(Event.RESIZE));
            } catch(event:Error) {
                trace(this.toString() + 'addChildAt(' + event.message, index + ');');
            }
            return holder;
        }

        public function removeAllChildren(target:DisplayObjectContainer = null):void {
            Cleaner.removeChildrenOf(target || this);
        }

        public function die():void {
            if (!this._dead) {
                super.removeAllEventListener();
                Cleaner.kill(this);
                this._dead = true;
            }
        }

        private function attachRegistrationPoint(diameter:Number = 5):void {
            this.detachRegistrationPoint();
            this._registrationShape = this.addChild(new Shape()) as Shape;
            if (this._registrationShape) {
                this._registrationShape.graphics.beginFill(0xffffff, 0);
                this._registrationShape.graphics.lineStyle(2, 0x00CCFF);
                this._registrationShape.graphics.moveTo(-diameter, -diameter);
                this._registrationShape.graphics.lineTo(diameter, diameter);
                this._registrationShape.graphics.moveTo(-diameter, diameter);
                this._registrationShape.graphics.lineTo(diameter, -diameter);
                this._registrationShape.graphics.endFill();
                super.setChildIndex(this._registrationShape, super.numChildren - 1);
            }
        }

        private function detachRegistrationPoint():void {
            if (this._registrationShape) {
                this._registrationShape.graphics.clear();
                if (this._registrationShape.parent) {
                    this._registrationShape.parent.removeChild(this._registrationShape);
                    this._registrationShape = null;
                }
            }
        }

        override public function toString():String {
            return '[Leprechaun ' + super.name + ']';
        }

        //
        //
        // IMovieClip proxies
        //
        //

        public function addFrameScript(...args:*):void {
            // never implement
        }

        public function gotoAndStop(frame:Object, scene:String = null):void {
            // never implement
        }

        public function gotoAndPlay(frame:Object, scene:String = null):void {
            // never implement
        }

        public function prevFrame():void {
            // never implement
        }

        public function nextFrame():void {
            // never implement
        }

        public function nextScene():void {
            // never implement
        }

        public function prevScene():void {
            // never implement
        }

        public function stop():void {
            // never implement
        }

        public function play():void {
            // never implement
        }

        public function playTo(frame:Object, vars:Object = null):void {
            // never implement
        }

        public function playToBeginAndStop(vars:Object = null):void {
            // never implement
        }

        public function playToEndAndStop(vars:Object = null):void {
            // never implement
        }

        public function loopBetween(from:Object = 1, to:Object = 0, yoyo:Boolean = false, vars:Object = null):void {
            // never implement
        }

        public function cancelLooping():void {
            // never implement
        }

        public function set onCompleteFrame(closure:Function):void {
            // never implement
        }

        public function set trackAsMenu(value:Boolean):void {
            // never implement
        }

        public function set enabled(value:Boolean):void {
            // never implement
        }

        public function get currentFrameLabel():String {
            return '';
        }

        public function get currentScene():Scene {
            return null;
        }

        public function frameIsValid(frame:Object):Boolean {
            return !1;
        }

        public function get trackAsMenu():Boolean {
            return !1;
        }

        public function get enabled():Boolean {
            return !1;
        }

        public function getFrameByLabel(frame:String):int {
            return 0;
        }

        public function parseFrame(frame:Object):int {
            return 0;
        }

        public function get duration():Number {
            return 0;
        }

        public function get position():Number {
            return 0;
        }

        public function get currentFrame():int {
            return 0;
        }

        public function get framesLoaded():int {
            return 0;
        }

        public function get totalFrames():int{
            return 0;
        }

        public function get currentLabels():Array {
            return [];
        }

        public function get scenes():Array {
            return [];
        }

        public function get currentLabel():String {
            return '';
        }
    }
}
