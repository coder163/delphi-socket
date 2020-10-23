unit MainFrm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    GroupBox1: TGroupBox;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses UnitHelloFrm, UnitHello;
{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  HelloWorld('过程调用');
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  ShowMessage(GetHelloWorld('函数调用'));
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  var
  User := TUser.create();
  ShowMessage(User.Add(1, 2).ToString);
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  var
  FormHello := TFormHello.create(nil);

  FormHello.Visible := True;
end;

end.
