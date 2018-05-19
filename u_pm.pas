unit u_pm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, EditBtn, u_functions;

type

  { Tf_pm }

  Tf_pm = class(TForm)
    np_action: TLabel;
    np_btn_sel_folder: TLabel;
    np_folder: TLabeledEdit;
    Label1: TLabel;
    np_name: TLabeledEdit;
    left_panel: TScrollBox;
    np_settings: TLabel;
    Panel1: TPanel;
    right_panel: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure np_actionClick(Sender: TObject);
    procedure np_btn_sel_folderClick(Sender: TObject);
    procedure create_project_item(pr_all:array of string);
    procedure np_settingsClick(Sender: TObject);

    procedure on_click(Sender: TObject);
    procedure On_Mouse_Enter(Sender: TObject);
    procedure On_Mouse_Leave(Sender: TObject);

  private

  public


  end;

  { TPathButton }
  TPathButton = class(TLabel)
    public
      path:String;
      act:String;
      _name:String;
  end;

var
  f_pm: Tf_pm;

implementation

uses
  u_editor, u_settings;

{$R *.lfm}

{ Tf_pm }

// dynamic procedures //////////////////////////////////////////////////

procedure Tf_pm.on_click (Sender: TObject);
var b:TPathButton;
		list:TStringList;
    i:Integer;
begin
  b:=(Sender as TPathButton);

	if b.act = 'run' then begin
		nw_run(b.path);
  end else if b.act = 'edit' then begin
    if f_editor.Visible then begin
			f_editor.ShowModal;
      Exit;
    end;
		current_name:=b._name;
    current_path:=b.path;
    f_editor.Show;
    f_editor.WindowState:=wsMaximized;
  end else if b.act = 'delete' then begin
		list:=TStringList.Create;
		list.LoadFromFile('./data/projects');

    for i:= 2 to list.Count - 1 do begin
      if list.Strings[i] = '' then Continue;
			if list.Strings[i].Split('|')[0] = b.path then begin
        list.Delete(i);
        Break;
      end;
    end;

		DeleteFile('./data/projects_conf/'+b.path);

    list.SaveToFile('./data/projects');
    list.Free;
    b.parent.parent.Free;
  end;

end;

procedure Tf_pm.On_Mouse_Enter(Sender: TObject);
begin
  TGraphicControl(Sender).Color:=gl_settings.gui_btn_color_entered;
end;

procedure Tf_pm.On_Mouse_Leave(Sender: TObject);
begin
  TGraphicControl(Sender).Color:=gl_settings.gui_btn_color;
end;

procedure Tf_pm.create_project_item(pr_all:array of string);
var
  // Components
	pr_panel:TPanel;
	pr_label:TLabel;
  pr_path:TLabel;
  pr_btn_panel:TPanel;
  pr_btn:TPathButton;
begin
  // create panel
  pr_panel:=TPanel.Create(f_pm);
  pr_panel.Align:=alTop;
  pr_panel.Height:=100;
  pr_panel.BevelOuter:=bvNone;
  pr_panel.BorderWidth:=0;
  pr_panel.ParentFont:=True;
  pr_panel.BorderSpacing.Bottom:=5;
  pr_panel.Color:=gl_settings.project_item_fill;
  pr_panel.Parent:=left_panel;

  // create buttons panel
  pr_btn_panel:=TPanel.create(f_pm);
  pr_btn_panel.Align:=alBottom;
  pr_btn_panel.Height:=30;
  pr_btn_panel.BorderSpacing.Around:=5;
  pr_btn_panel.ParentColor:=True;
  pr_btn_panel.Parent:=pr_panel;
  pr_btn_panel.BevelOuter:=bvNone;

  // create label name
  pr_label:=TLabel.Create(f_pm);
  pr_label.Top:=15;
  pr_label.Left:=15;
  pr_label.Caption:=pr_all[0];
  pr_label.ParentFont:=true;
  pr_label.Parent:=pr_panel;

  // create label path
  pr_path:=TLabel.Create(f_pm);
  pr_path.Top:=40;
  pr_path.Left:=15;
  pr_path.Caption:=pr_all[1];
  pr_path.ParentFont:=true;
  pr_path.Parent:=pr_panel;

  // create button run
  pr_btn:=TPathButton.Create(f_pm);

	if not(FileExists(nw_path)) then
    pr_btn.Enabled:=false;

  pr_btn.Layout:=tlCenter;
  pr_btn.AutoSize:=False;
  pr_btn.Alignment:=taCenter;
  pr_btn.act:='run';
  pr_btn.path:=pr_all[1];
  pr_btn.Align:=alRight;
  pr_btn.Caption:='Запустить';
  pr_btn.Width:=100;
  pr_btn.BorderSpacing.Around:=2;
  pr_btn.Color:=np_settings.Color;

  pr_btn.OnClick:=@on_click;
	pr_btn.OnMouseEnter:=@On_Mouse_Enter;
	pr_btn.OnMouseLeave:=@On_Mouse_Leave;

  pr_btn.Cursor:=crHandPoint;
  pr_btn.Parent:=pr_btn_panel;

  // create button delete
  pr_btn:=TPathButton.Create(f_pm);
  pr_btn.Layout:=tlCenter;
  pr_btn.Alignment:=taCenter;
  pr_btn.AutoSize:=False;
  pr_btn.act:='delete';
  pr_btn.path:=pr_all[0];
  pr_btn.Align:=alRight;
  pr_btn.Caption:='Удалить';
  pr_btn.Width:=100;
  pr_btn.Color:=np_settings.Color;
  pr_btn.BorderSpacing.Around:=2;

  pr_btn.OnClick:=@on_click;
	pr_btn.OnMouseEnter:=@On_Mouse_Enter;
	pr_btn.OnMouseLeave:=@On_Mouse_Leave;

  pr_btn.Cursor:=crHandPoint;
  pr_btn.Parent:=pr_btn_panel;

  // create button edit
  pr_btn:=TPathButton.Create(f_pm);
  pr_btn.Layout:=tlCenter;
  pr_btn.AutoSize:=False;
  pr_btn.Alignment:=taCenter;
  pr_btn.act:='edit';
  pr_btn._name:=pr_all[0];
  pr_btn.path:=pr_all[1];
  pr_btn.Align:=alRight;
  pr_btn.Caption:='Редактировать';
  pr_btn.Width:=150;
  pr_btn.Color:=np_settings.Color;
  pr_btn.BorderSpacing.Around:=2;

  pr_btn.OnClick:=@on_click;
	pr_btn.OnMouseEnter:=@On_Mouse_Enter;
	pr_btn.OnMouseLeave:=@On_Mouse_Leave;

  pr_btn.Cursor:=crHandPoint;
  pr_btn.Parent:=pr_btn_panel;
end;

procedure Tf_pm.np_settingsClick(Sender: TObject);
begin
  f_settings.ShowInTaskBar:=stNever;
  f_settings.ShowModal;
end;

//////////////////////////////////////////////////////////////////////////////

procedure Tf_pm.np_actionClick(Sender: TObject);
var start_package:String = '';
    start_html:String = '';
begin

  // package.json text
  start_package:=
  '{'+#13+
  '	"main" : "index.html",'+#13+
  '	"name" : "'+np_name.Text+'"'+#13+

	'}';

  start_html:= '<h1>Hello, World!</h1>';

	if (np_name.Text <> '') and (np_folder.Text <> '') then begin
		if DirectoryExists(np_folder.Text) then begin
			// create new project /////////////////////
      if not(FileExists(np_folder.Text+'/package.json')) then write_file(np_folder.Text+'/package.json', start_package);
      if not(FileExists(np_folder.Text+'/index.html')) then write_file(np_folder.Text+'/index.html', start_html);
			append_file('./data/projects', #13+np_name.Text+'|'+np_folder.Text);
      create_project_item([np_name.Text, np_folder.Text]);
      np_folder.Text:='';
      np_name.Text:='';
      ///////////////////////////////////////////
    end else ShowMessage('Папка проекта не найдена');
  end else ShowMessage('Не заполнены обязательные поля!');
end;

procedure Tf_pm.FormCreate(Sender: TObject);
var d:TStringList;
  	i:Integer;
    pr_all:array of string;
begin
	init_color_theme();


	//////////////////////////////////////////////////////////////////////////////
  d:=TStringList.Create;

  // init folders
	if not(DirectoryExists('./data')) then begin
    CreateDir('./data');
    CreateDir('./data/projects_conf');
  end;



  // load prrojects
  if FileExists('./data/projects') then begin
		d.LoadFromFile('./data/projects');
  end;

	if d.Text <> '' then begin
  	// NW Path
   	nw_path:=get_line(d, 0);

    // Projects Path
    all_projects:=get_line(d, 1);

		// Create Project list
    if d.Count > 2 then begin
      sleep(2000);
			for i:=2 to d.Count - 1 do begin
        if d.Strings[i].Trim = '' then Continue;

        // parse string
				pr_all:=d.Strings[i].Split('|');

        create_project_item(pr_all);
      end;
    end;

  end;


end;

procedure Tf_pm.np_btn_sel_folderClick(Sender: TObject);
var dial:TSelectDirectoryDialog;
begin
	dial:=TSelectDirectoryDialog.Create(nil);
	dial.Title:='Выбрать папку проекта';
	dial.InitialDir:=all_projects;
	dial.Execute;
  np_folder.Text:=dial.FileName;
  dial.Free;
end;

end.

