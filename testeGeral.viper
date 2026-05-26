int I;
I = 0;
switch(I) {
  case 0:
    print(0);
    break;
  case 1:
    print(1);
    break;
}

while(I<5) {
  print(2);
  I = I+1;
  if(I==4){
    break;
  }
}