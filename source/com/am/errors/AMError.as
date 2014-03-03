package com.am.errors {

	/**
	 * @author Adrian C. Miranda <adriancmiranda@gmail.com>
	 > TODO: Make this thing right ò.-.
	 */
	public class AMError extends Error {
		public function AMError(message:String = '', id:int = 0, index:int = -1) {
			super(this.getMethodByIndex(index) + ' ' + id + ': ' + message, id);
		}

		private function getMethodByIndex(index:int):String {
			var methodName:String;
			try {
				methodName = super.getStackTrace().split('\n')[index].replace('\tat ', '');
				methodName = methodName.substr(0, methodName.indexOf('['));
			} catch (error:Error) {
				methodName = 'App';
			}
			return methodName;
		}
	}
}
