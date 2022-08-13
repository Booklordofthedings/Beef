#pragma warning disable 168

using System;
using System.Collections;

namespace Tests
{
	class Boxing
	{
		interface IFace
		{
			int Get() mut;
		}

		struct StructA : IFace
		{
			public int mA = 100;

			public int Get() mut
			{
				mA += 1000;
				return mA;
			}
		}

		[Reflect(.DynamicBoxing)]
		struct StructB : StructA, IHashable
		{
			public int mB = 200;

			public int GetHashCode()
			{
				return mB;
			}
		}

		struct StructC : StructB
		{
			public int mC = 300;
		}

		public static int GetFromIFace<T>(mut T val) where T : IFace
		{
			return val.Get();
		}

		[Test]
		public static void TestBasics()
		{
			StructA valA = .();
			Object obj0 = valA;
			IFace iface0 = (IFace)obj0;
			Test.Assert(GetFromIFace(mut valA) == 1100);
			Test.Assert(iface0.Get() == 1100);
			Test.Assert(GetFromIFace(iface0) == 2100);
			Test.Assert(valA.mA == 1100); // This should copy values

			StructB valB = .();
			IFace iface1 = valB;
			Test.Assert(GetFromIFace(mut valB) == 1100);
			Test.Assert(iface1.Get() == 1100);
			Test.Assert(GetFromIFace(iface1) == 2100);
			Test.Assert(valB.mA == 1100); // This should copy values

			StructC valC = .();

			var boxedVal = scope box valA;
			iface0 = boxedVal;

#unwarn
			var boxedStr = scope box "Test";
			IHashable ihash = boxedStr;

			Variant saVariant = .Create(valA);
			var saObj = saVariant.GetBoxed().Value;
			delete saObj;
			saVariant.Dispose();

			Variant sbVariant = .Create(valB);
			var scObj = sbVariant.GetBoxed().Value;
			IHashable ih = scObj;
			Test.Assert(ih.GetHashCode() == 200);
			delete scObj;
			sbVariant.Dispose();

			Variant scVariant = .Create(valC);
			var scObjResult = scVariant.GetBoxed();
			Test.Assert(scObjResult case .Err);
			scVariant.Dispose();

			List<int> l = scope .();
			IEnumerator<int> e = (l != null) ? (.)null : l.GetEnumerator();
		}

		[Test]
		public static void TestPtr()
		{
			StructA* valA = scope .();
			Object obj0 = valA;
			IFace iface0 = (IFace)obj0;
			Test.Assert(GetFromIFace(mut valA) == 1100);
			Test.Assert(iface0.Get() == 2100);
			Test.Assert(GetFromIFace(iface0) == 3100);
			Test.Assert(valA.mA == 3100); // This should copy values

			StructB* valB = scope .();
			IFace iface1 = valB;
			Test.Assert(GetFromIFace(mut valB) == 1100);
			Test.Assert(iface1.Get() == 2100);
			Test.Assert(GetFromIFace(iface1) == 3100);
			Test.Assert(valB.mA == 3100); // This should copy values
		}

		public static int GetHash<T>(T val) where T : IHashable
		{
			return val.GetHashCode();
		}

		[Test]
		public static void TestPtrHash()
		{
			StructA* valA = scope .();
			StructB* valB = scope .();
			StructC* valC = scope .();

			IHashable ihA = valA;
			IHashable ihB = valB;
			IHashable ihC = valC;

			Test.Assert(ihA.GetHashCode() == (int)(void*)valA);
			Test.Assert(ihB.GetHashCode() == (int)(void*)valB);
			Test.Assert(ihC.GetHashCode() == (int)(void*)valC);

			Test.Assert(GetHash(ihA) == (int)(void*)valA);
			Test.Assert(GetHash(ihB) == (int)(void*)valB);
			Test.Assert(GetHash(ihC) == (int)(void*)valC);
		}
	}
}
