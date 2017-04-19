
{*******************************************************}
{                                                       }
{       OPCtypes.pas                                    }
{                                                       }
{       Standard type definitions shared across         }
{       multiple OPC specifications                     }
{                                                       }
{*******************************************************}

unit OPCtypes;

interface

uses
  Windows, ActiveX;

type
  TOleEnum          = type Integer;

  OPCHANDLE         = DWORD;
  POPCHANDLE        = ^OPCHANDLE;
  OPCHANDLEARRAY    = array[0..65535] of OPCHANDLE;
  POPCHANDLEARRAY   = ^OPCHANDLEARRAY;

  PVarType          = ^TVarType;
  TVarTypeList      = array[0..65535] of TVarType;
  PVarTypeList      = ^TVarTypeList;

  POleVariant       = ^OleVariant;
  OleVariantArray   = array[0..65535] of OleVariant;
  POleVariantArray  = ^OleVariantArray;

  PLCID             = ^TLCID;

  DWORDARRAY        = array[0..65535] of DWORD;
  PDWORDARRAY       = ^DWORDARRAY;

  TFileTimeArray    = array[0..65535] of TFileTime;
  PFileTimeArray    = ^TFileTimeArray;

implementation

end.
{*******************************************************}
{                                                       }
{       OPCtypes.pas                                    }
{                                                       }
{       Standard type definitions shared across         }
{       multiple OPC specifications                     }
{                                                       }
{*******************************************************}

unit OPCtypes;

interface

uses
  Windows, ActiveX;

type
  TOleEnum          = type Integer;

  OPCHANDLE         = DWORD;
  POPCHANDLE        = ^OPCHANDLE;
  OPCHANDLEARRAY    = array[0..65535] of OPCHANDLE;
  POPCHANDLEARRAY   = ^OPCHANDLEARRAY;

  PVarType          = ^TVarType;
  TVarTypeList      = array[0..65535] of TVarType;
  PVarTypeList      = ^TVarTypeList;

  POleVariant       = ^OleVariant;
  OleVariantArray   = array[0..65535] of OleVariant;
  POleVariantArray  = ^OleVariantArray;

  PLCID             = ^TLCID;

  DWORDARRAY        = array[0..65535] of DWORD;
  PDWORDARRAY       = ^DWORDARRAY;

  TFileTimeArray    = array[0..65535] of TFileTime;
  PFileTimeArray    = ^TFileTimeArray;

implementation

end.