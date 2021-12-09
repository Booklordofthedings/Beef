#pragma warning disable 168

using System;
using System.Collections;

namespace System
{
	extension Array1<T>
	{
		public static Self operator+(Self lhs, Self rhs) where T : IDisposable
		{
			return lhs;
		}
	}
}

namespace IDETest
{
	class Generics
	{
		public void Method1<T>(T val) where T : Array
		{

		}

		public void Method2<T, T2>(T val, T2 val2)
		{
			Method1(val2); //FAIL 'T', declared to be 'T2'
		}

		public void Method3<TFoo>(ref TFoo[] val)
		{
			var res = val + val; //FAIL
		}

		public void Method4<TFoo>(ref TFoo[] val) where TFoo : IDisposable
		{
			var res = val + val;
		}

		interface IFaceA<T>
		{
			public void MethodA<M1>(T val, M1 val2, delegate T (M1 arg) val3);
		}

		class ClassA<T1, T2> : IFaceA<(T1, T2)> //FAIL 'IDETest.Generics.ClassA<T1, T2>' does not implement interface member 'IDETest.Generics.IFaceA<(T1, T2)>.MethodA<M1>((T1, T2) val, M1 val2, delegate (T1, T2)(M1 arg) val3)'
		{
			void MethodA<M>(int a)
			{

			}

			void MethodB()
			{
				function void() f = => MethodA<T2>; //FAIL Method 'IDETest.Generics.ClassA<T1, T2>.MethodA<T2>(int a)' does not match function 'function void()'
			}
		}

		static void Method5<A, B>() where A : IEnumerable<B>
		{

		}

		static void Method6<C, D, E, F>()
		{
			Method5<E, F>(); //FAIL Generic argument 'A', declared to be 'E' for 'IDETest.Generics.Method5<E, F>()', must implement 'System.Collections.IEnumerable<F>'
		}

		interface IFaceB<T>
		{
			void MethodA0();
		}

		extension IFaceB<T>
		{
			void MethodA1();
		}

		class ClassB<T> : IFaceB<T> //FAIL 'IDETest.Generics.ClassB<T>' does not implement interface member 'IDETest.Generics.IFaceB<T>.MethodA0()'
		{

		}

		extension ClassB<T>
		{

		}

		public static void TestGen<T, TItem>(T val)
			where T : IEnumerator<TItem>
			where TItem : var
		{
			Console.WriteLine(typeof(decltype(val)).ToString(.. scope .()));
		}

		public static void TestPreGen<T>()
		{
			T a = default;
			TestGen(a); //FAIL Unable to determine generic argument 'TItem'
		}

		public static void TestGenBug()
		{
			TestPreGen<List<int>>();
		}
	}
}
