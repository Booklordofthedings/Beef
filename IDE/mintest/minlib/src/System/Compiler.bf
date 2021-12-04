namespace System
{
	class Compiler
	{
		public static class Options
		{
			[LinkName("#AllocStackCount")]
			public static extern int32 AllocStackCount;
		}

		[LinkName("#CallerLineNum")]
		public static extern int CallerLineNum;

		[LinkName("#CallerFilePath")]
		public static extern String CallerFilePath;

		[LinkName("#CallerFileName")]
		public static extern String CallerFileName;

		[LinkName("#CallerFileDir")]
		public static extern String CallerFileDir;

		[LinkName("#CallerMemberName")]
		public static extern String CallerMemberName;

		[LinkName("#CallerProject")]
		public static extern String CallerProject;

		[LinkName("#CallerExpression")]
		public static extern String[0x0FFFFFFF] CallerExpression;

		[LinkName("#ProjectName")]
		public static extern String ProjectName;

		[LinkName("#ModuleName")]
		public static extern String ModuleName;

		[LinkName("#TimeLocal")]
		public static extern String TimeLocal;

		[LinkName("#IsComptime")]
		public static extern bool IsComptime;

		[LinkName("#IsBuilding")]
		public static extern bool IsBuilding;

		[LinkName("#IsReified")]
		public static extern bool IsReified;

		[LinkName("#CompileRev")]
		public static extern int32 CompileRev;

		[Comptime]
		public static void Assert(bool cond)
		{
			if (!cond)
				Runtime.FatalError("Assert failed");
		}
	}
}
