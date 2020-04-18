// File: SSecurityCommon.pas
// Version: 1.3
// Author: Spider13

unit SSecurityCommon;

interface

uses Classes, SysUtils, SSecurityErrors;

type
  THideMethod = (hmEnabled, hmVisible);

type
  TLoginEvent = procedure (_Sender: TObject) of object;
  TLogoutEvent = procedure (_Sender: TObject) of object;

const
  BitsPerByte = 8;

const
  MaxByteArray = 65536;

type
  PByteArray = ^TByteArray;
  TByteArray = array[0..MaxByteArray - 1] of Byte;

type
  TSBits = class(TObject)
  private
    FSize: Longint;
    FData: PByteArray;
  protected
    function CalcMemSize(_Size: Longint): Longint;
    function GetBit(_Index: Longint): Boolean;
    procedure SetBit(_Index: Longint; _Value: Boolean);
    procedure SetSize(_Value: Longint);
    function GetDataSize: Longint;
    procedure BitsOutOfRange;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Assign(_Bits: TSBits);
    property Bits[_Index: Longint]: Boolean read GetBit write SetBit; default;
    property Size: Longint read FSize write SetSize;
    property Data: PByteArray read FData;
    property DataSize: Longint read GetDataSize;
  end;

type
  TSSecurityAccess = class(TObject)
  private
    FBits: TSBits;
    FLocked: Boolean;
  protected
    function GetSize: Longint;
    procedure SetSize(_Value: Longint);
    function GetAccess(_Index: Longint): Boolean;
    procedure SetAccess(_Index: Longint; _Value: Boolean);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Assign(_Access: TSSecurityAccess);
    procedure Lock;
    procedure Unlock;
    property Size: Longint read GetSize write SetSize;
    property Access[_Index: Longint]: Boolean read GetAccess write SetAccess;
    property Bits: TSBits read FBits;
    property Locked: Boolean read FLocked;
  end;

implementation

function Min(_Value1: Longint; _Value2: Longint): Longint;
begin
  if _Value1 > _Value2 then
    Result:= _Value2
  else
    Result:= _Value1;
end;

// TSBits //

function TSBits.CalcMemSize(_Size: Integer): Longint;
begin
  if (_Size mod BitsPerByte) = 0 then
    Result:= _Size div BitsPerByte
  else
    Result:= (_Size + BitsPerByte) div BitsPerByte;
end;

constructor TSBits.Create;
begin
  inherited Create;
  FSize:= 0;
  FData:= nil;
end;

destructor TSBits.Destroy;
begin
  Size:= 0;
  inherited Destroy;
end;

procedure TSBits.Assign(_Bits: TSBits);
begin
  Size:= _Bits.Size;
  Move(_Bits.Data^, Data^, _Bits.DataSize);
end;

procedure TSBits.BitsOutOfRange;
begin
  raise Exception.Create(SEBitsOutOfRange);
end;

function TSBits.GetBit(_Index: Longint): Boolean; assembler;
asm
  CMP _Index, [EAX].FSize
  JAE TSBits.BitsOutOfRange
  MOV EAX, [EAX].FData
  BT [EAX], _Index
  SBB EAX, EAX
  AND EAX, 1
end;

function TSBits.GetDataSize: Longint;
begin
  Result:= CalcMemSize(FSize);
end;

procedure TSBits.SetBit(_Index: Longint; _Value: Boolean); assembler;
asm
  CMP _Index, [EAX].FSize
  JAE TSBits.BitsOutOfRange
@@1:
  MOV EAX, [EAX].FData
  OR _Value, _Value
  JZ @@2
  BTS [EAX], _Index
  RET
@@2:
  BTR [EAX], _Index
  RET
end;

procedure TSBits.SetSize(_Value: Longint);
var
  OldMemSize: Longint;
  NewMemSize: Longint;
  NewData: PByteArray;
begin
  if _Value <> FSize then
  begin
    OldMemSize:= CalcMemSize(FSize);
    NewMemSize:= CalcMemSize(_Value);
    if OldMemSize <> NewMemSize then
    begin
      NewData:= nil;
      if NewMemSize > 0 then
      begin
        GetMem(NewData, NewMemSize);
        if NewData = nil then
          raise Exception.Create(SECannotSetNewSize);
      end;
      if (NewMemSize > 0) and (OldMemSize > 0) then
        Move(FData^, NewData^, Min(OldMemSize, NewMemSize));
      FreeMem(FData);
      FData:= NewData;
      FSize:= _Value;
    end;
  end;
end;

// TSSecurityAccess //

procedure TSSecurityAccess.Assign(_Access: TSSecurityAccess);
begin
  FBits.Assign(_Access.Bits);
  FLocked:= _Access.Locked;
end;

constructor TSSecurityAccess.Create;
begin
  FBits:= TSBits.Create;
  FLocked:= False;
end;

destructor TSSecurityAccess.Destroy;
begin
  FBits.Free;
  inherited Destroy;
end;

function TSSecurityAccess.GetAccess(_Index: Integer): Boolean;
begin
  Result:= FBits.Bits[_Index];
end;

function TSSecurityAccess.GetSize: Longint;
begin
  Result:= FBits.Size;
end;

procedure TSSecurityAccess.Lock;
begin
  FLocked:= True;
end;

procedure TSSecurityAccess.SetAccess(_Index: Integer; _Value: Boolean);
begin
  if FLocked then
    raise Exception.Create(SEBlocked);
  FBits.Bits[_Index]:= _Value;
end;

procedure TSSecurityAccess.SetSize(_Value: Integer);
begin
  if FLocked then
    raise Exception.Create(SEBlocked);
  if _Value <> FBits.Size then
  begin
    FBits.Size:= _Value;
  end;
end;

procedure TSSecurityAccess.Unlock;
begin
  FLocked:= False;
end;

end.

