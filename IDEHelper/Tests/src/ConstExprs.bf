#pragma warning disable 168
using System;
namespace Tests
{
	class ConstExprs
	{
		enum EnumA
		{
			A,
			B,
			C
		}

		class ClassA<T, TSize> where TSize : const int
		{
			public int GetVal()
			{
				return TSize;
			}
		}

		class ClassB<T, TSize> where TSize : const int8
		{
			ClassA<T, TSize> mVal = new ClassA<T, const TSize>() ~ delete _;
			var mVal2 = new ClassA<T, const TSize + 100>() ~ delete _;
			
			public int GetVal()
			{
				return mVal.GetVal(); 
			}

			public int GetVal2()
			{
				return mVal2.GetVal();
			}
		}

		class ClassC<TEnum> where TEnum : const EnumA
		{
			public int Test()
			{
				EnumA ea = TEnum;
				if (TEnum == .A)
				{
					return 1;
				}
				return 0;
			}
		}

		[Test]
		public static void TestBasics()
		{
			ClassB<float, const 123> cb = scope .();
			Test.Assert(cb.GetVal() == 123);
			Test.Assert(cb.GetVal2() == 223);

			ClassB<float, const -45> cb2 = scope .();
			Test.Assert(cb2.GetVal() == -45);
			Test.Assert(cb2.GetVal2() == 55);

			ClassC<const EnumA.A> cc = scope .();
			Test.Assert(cc.Test() == 1);
		}
	}
}
