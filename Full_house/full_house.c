#include<stdio.h>

void full_ROWs(int *i);
void full_COLUMNs(int *i);
void full_BOXes(int *i);


int main()
{
int cell[9][9],cell2[9][9],i,j,k,x;
printf("Enter the numbers in left to right and top to bottom order. Enter 0(zero) for empty cells\n");


for(i=0;i<9;i++)
{
  for(j=0;j<9;++j)
scanf("%1d",&cell[i][j]);
}


x=1;
while(x!=0)
{
x=0;
for(i=0;i<9;i++)
{
  for(j=0;j<9;++j)
cell2[i][j]=cell[i][j];
}
for(i=0;i<9;++i)
full_ROWs(cell[i]);
for(i=0;i<9;++i)
full_COLUMNs(cell[0]+i);
for(i=0;i<3;++i)
{
for(j=0;j<3;j++)
full_BOXes(&cell[3*i][3*j]);
}
for(i=0;i<9;i++)
{
  for(j=0;j<9;++j)
{
if(cell[i][j]!=cell2[i][j])
x=x+1;
}
}


}


printf("\n");
for(i=0;i<9;i++)
{
  for(j=0;j<9;++j)
printf("%1d ",cell[i][j]);
printf("\n");
}


return 0;
}


void full_ROWs(int *i)
{
int *j,*k,x,sum;
for(j=i,x=0,sum=0;j<(i+9);++j)
{
if(*j==0)
{
x=x+1;
k=j;
}
sum=sum+*j;
}
if(x==1)
*k=45-sum;
return;
}


void full_COLUMNs(int *i)
{
int *j,*k,x,sum;
for(j=i,x=0,sum=0;j<(i+9*9);j=j+9)
{
if(*j==0)
{
x=x+1;
k=j;
}
sum=sum+*j;
}
if(x==1)
*k=45-sum;
return;
}


void full_BOXes(int *i)
{
int *j,*m,*k,x,sum;
for(j=i,x=0,sum=0;j<(i+9*3);j=j+9)
{
for(m=j;m<(j+3);m++)
{
if(*m==0)
{
x=x+1;
k=m;
}
sum=sum+*m;
}
}
if(x==1)
*k=45-sum;
return;
}
