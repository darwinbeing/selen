int main()
{
	volatile int a=1, b =3;
	for (int i=0; i< 4; i++)	
		a= b+1; 
	return a;
}
