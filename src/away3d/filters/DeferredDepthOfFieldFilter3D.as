package away3d.filters
{
	import away3d.cameras.Camera3D;
	import away3d.containers.ObjectContainer3D;
	import away3d.core.managers.Stage3DProxy;
	import away3d.core.render.DeferredRenderer;
	import away3d.filters.tasks.Filter3DeferredHDepthOfFieldTask;
	import away3d.filters.tasks.Filter3DDeferredVDepthOfFieldTask;

	import flash.display3D.textures.Texture;
	import flash.geom.Vector3D;

	public class DeferredDepthOfFieldFilter3D extends Filter3DBase
	{
		private var _focusTarget : ObjectContainer3D;
		private var _hDofTask : Filter3DeferredHDepthOfFieldTask;
		private var _vDofTask : Filter3DDeferredVDepthOfFieldTask;

		public function DeferredDepthOfFieldFilter3D(renderer : DeferredRenderer, maxBlurX : uint = 3, maxBlurY : uint = 3, stepSize:int = -1)
		{
			super();
			_hDofTask = new Filter3DeferredHDepthOfFieldTask(renderer, maxBlurX, stepSize);
			_vDofTask = new Filter3DDeferredVDepthOfFieldTask(renderer, maxBlurY, stepSize);
			addTask(_hDofTask);
			addTask(_vDofTask);
		}

		public function get stepSize() : int
		{
			return _hDofTask.stepSize;
		}

		public function set stepSize(value : int) : void
		{
			_vDofTask.stepSize = _hDofTask.stepSize = value;
		}

		public function get focusTarget() : ObjectContainer3D
		{
			return _focusTarget;
		}

		public function set focusTarget(value : ObjectContainer3D) : void
		{
			_focusTarget = value;
		}

		public function get focusDistance() : Number
		{
			return _hDofTask.focusDistance;
		}

		public function set focusDistance(value : Number) : void
		{
			_hDofTask.focusDistance = _vDofTask.focusDistance = value;
		}

		public function get range() : Number
		{
			return _hDofTask.range;
		}

		public function set range(value : Number) : void
		{
			_vDofTask.range = _hDofTask.range = value;
		}

		public function get maxBlurX() : uint
		{
			return _hDofTask.maxBlur;
		}

		public function set maxBlurX(value : uint) : void
		{
			_hDofTask.maxBlur = value;
		}

		public function get maxBlurY() : uint
		{
			return _vDofTask.maxBlur;
		}

		public function set maxBlurY(value : uint) : void
		{
			_vDofTask.maxBlur = value;
		}

		override public function update(stage : Stage3DProxy, camera : Camera3D) : void
		{
			if (_focusTarget)
				updateFocus(camera);
		}

		private function updateFocus(camera : Camera3D) : void
		{
			var target : Vector3D = camera.inverseSceneTransform.transformVector(_focusTarget.scenePosition);
			_hDofTask.focusDistance = _vDofTask.focusDistance = target.z;
		}

		override public function setRenderTargets(mainTarget : Texture, stage3DProxy : Stage3DProxy) : void
		{
			_hDofTask.target = _vDofTask.getMainInputTexture(stage3DProxy);
		}
	}
}
