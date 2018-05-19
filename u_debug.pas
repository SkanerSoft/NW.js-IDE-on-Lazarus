unit u_debug;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, u_functions, process, eventlog;

type

  { TStateReader }

  TStateReader = class(TThread)
  protected
    text:String;

    procedure Execute; override;
  public
		procedure update;
    Constructor Create(CreateSuspended : boolean);
  end;

  { Tf_debug }

  Tf_debug = class(TForm)
    debug_log: TMemo;
    re_debug: TLabel;
    stop_debug: TLabel;
    top_panel: TPanel;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure On_Mouse_Enter(Sender: TObject);
    procedure On_Mouse_Leave(Sender: TObject);

  private

  public
		running:Boolean;
    exe:TProcess;

    procedure _STOP;
  end;

var
  f_debug: Tf_debug;

  log_reader:TStateReader;

implementation

uses
  u_editor;

{$R *.lfm}

{ TStateReader }

procedure TStateReader.Execute;
var log:TStringList;
begin
  log:=TStringList.Create;
  while f_debug.running do begin
		if f_debug.exe.Running then begin
			log.LoadFromStream(f_debug.exe.Output);
      if log.Text.Trim <> '' then begin
        text:=log.Text.Trim;
        Synchronize(@update);
      end;
    end else begin
      Break;
    end;
    Sleep(100);
  end;
  log.Free;
  Terminate;
  f_debug._STOP;
end;

procedure TStateReader.update;
begin
	f_debug.debug_log.Lines.Add(text);
end;

constructor TStateReader.Create(CreateSuspended: boolean);
begin
  FreeOnTerminate := True;
  inherited Create(CreateSuspended);
end;

{ Tf_debug }

procedure Tf_debug.FormShow(Sender: TObject);
begin
  f_debug.Left:=0;
  f_debug.Top:=Screen.Height - f_debug.Height;
  f_debug.Width:=Screen.Width;
  f_editor.btn_debug.Caption:='Стоп';
  running:=true;
  debug_log.Lines.Clear;

	exe:=TProcess.Create(nil);

	// settings
  exe.Options:=[poUsePipes, poStderrToOutPut, poNoConsole];

  // argiments
  exe.Parameters.Add(current_path);
	exe.Parameters.Add('--enable-logging=stderr');


  // NW.js
	exe.Executable:=nw_path;

	// run
  exe.Execute;

  // Create Thread
  log_reader := TStateReader.Create(False);
end;

procedure Tf_debug.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  f_editor.btn_debug.Caption:='Запуск';
  running:=false;
end;

procedure Tf_debug.On_Mouse_Enter(Sender: TObject);
begin
  TGraphicControl(Sender).Color:=gl_settings.gui_btn_color_entered;
end;

procedure Tf_debug.On_Mouse_Leave(Sender: TObject);
begin
  TGraphicControl(Sender).Color:=gl_settings.gui_btn_color;
end;

procedure Tf_debug._STOP;
begin
  if running then begin
    if exe.Running then
  	exe.Terminate(0);
  	log_reader.Terminate;
    exe.Free;
  end;
  f_debug.Close;
end;

end.

