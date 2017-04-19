unit Types;

interface

uses
  Classes, Graphics;

const
 TrendsColors : array[1..16] of TColor =
  (
    clBlack,    //1
    $008000FF,  //2
    clNavy,     //3
    $000080FF,  //4
    clBlue,     //5
    clMaroon,   //6
    clPurple,   //7
    $00C08080,  //8
    clFuchsia,  //9
    clGreen,    //10
    $00808040,  //11
    clLime,     //12
    clAqua,     //13
    $00FF8080,  //14
    clOlive,    //15
    $00FF8000   //16
  );

type
  TState = (stOk, stNetErr, stSenErr, stNotMnt);
          //stOk - ошибок нет
          //stNetErr - неисправность сети
          //stSenErr - неисправность датчика
          //stNotMnt - прибор не установлен

implementation


end.
unit Types;

interface

uses
  Classes, Graphics;

const
 TrendsColors : array[1..16] of TColor =
  (
    clBlack,    //1
    $008000FF,  //2
    clNavy,     //3
    $000080FF,  //4
    clBlue,     //5
    clMaroon,   //6
    clPurple,   //7
    $00C08080,  //8
    clFuchsia,  //9
    clGreen,    //10
    $00808040,  //11
    clLime,     //12
    clAqua,     //13
    $00FF8080,  //14
    clOlive,    //15
    $00FF8000   //16
  );

type
  TState = (stOk, stNetErr, stSenErr, stNotMnt);
          //stOk - ошибок нет
          //stNetErr - неисправность сети
          //stSenErr - неисправность датчика
          //stNotMnt - прибор не установлен

implementation


end.
