unit u_settings;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, EditBtn, FileCtrl, ComCtrls;

type

  { Tf_settings }

  Tf_settings = class(TForm)
    btn_sel_projects: TLabel;
    Label1: TLabel;
    btn_sel_nw: TLabel;
    fill: TPanel;
    Panel2: TPanel;
    s_nw_path: TLabeledEdit;
    pages: TPageControl;
    Panel1: TPanel;
    nw_settings: TTabSheet;
    code_editor_settings: TTabSheet;
    s_projects: TLabeledEdit;

    procedure btn_sel_nwClick(Sender: TObject);
    procedure btn_sel_projectsClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Label1Click(Sender: TObject);
  procedure On_Mouse_Enter(Sender: TObject);
    procedure On_Mouse_Leave(Sender: TObject);
  private

  public

  end;

var
  f_settings: Tf_settings;

implementation

uses
  u_functions;

{$R *.lfm}

{ Tf_settings }

procedure Tf_settings.On_Mouse_Enter(Sender: TObject);
begin
  TGraphicControl(Sender).Color:=gl_settings.gui_btn_color_entered;
end;

procedure Tf_settings.btn_sel_nwClick(Sender: TObject);
var dial:TOpenDialog;
begin
	dial:=TOpenDialog.Create(nil);
	dial.Title:='Выбрать путь к NW.js';
	dial.Execute;
  s_nw_path.Text:=dial.FileName;
  dial.Free;
end;

procedure Tf_settings.btn_sel_projectsClick(Sender: TObject);
var dial:TSelectDirectoryDialog;
begin
	dial:=TSelectDirectoryDialog.Create(nil);
	dial.Title:='Выбрать папку с проектами';
	dial.InitialDir:=all_projects;
	dial.Execute;
  s_projects.Text:=dial.FileName;
  dial.Free;
end;

procedure Tf_settings.FormCreate(Sender: TObject);
begin
  s_nw_path.Text:=nw_path;
  s_projects.Text:=all_projects;
end;

procedure Tf_settings.Label1Click(Sender: TObject);
var sett:TStringList;
begin
	nw_path:=s_nw_path.Text;
  all_projects:=s_projects.Text;

	sett:=TStringList.Create;
	sett.LoadFromFile('./data/projects');

	sett.Strings[0]:=s_nw_path.Text;
	sett.Strings[1]:=s_projects.Text;

  sett.SaveToFile('./data/projects');
  sett.Free;
  f_settings.Close;
end;

procedure Tf_settings.On_Mouse_Leave(Sender: TObject);
begin
  TGraphicControl(Sender).Color:=gl_settings.gui_btn_color;
end;

end.

