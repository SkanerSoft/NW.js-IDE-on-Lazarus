unit u_editor;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, SynEdit, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls, ShellCtrls, u_functions, u_frame_editor;

type

  { TCPageControl }

  TCPageControl = class(TPageControl)
    private
			custom_olor:TColor;

    public
      procedure set_color(clr:TColor);
  end;

	{ TEditor }
  TEditor = class(TTabSheet)
  public
    	path:String;
      frame:Tf_frame_editor;
  end;

  { Tf_editor }

  Tf_editor = class(TForm)
    btn_debug: TLabel;
    btn_save: TLabel;
    btn_close: TLabel;
    fs_back: TLabel;
    left_panel: TPanel;
    center_panel: TPanel;
    files: TShellListView;
    pages: TCPageControl;
    Panel1: TPanel;
    Panel2: TPanel;
    procedure btn_closeClick(Sender: TObject);
    procedure btn_debugClick(Sender: TObject);
    procedure On_Mouse_Move(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure filesDblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btn_saveClick(Sender: TObject);
    procedure fs_backClick(Sender: TObject);
    procedure add_tab(p: String; is_add: Boolean);
    procedure pagesChange(Sender: TObject);
    procedure pagesCloseTabClicked(Sender: TObject);

    procedure On_Mouse_Enter(Sender: TObject);
    procedure On_Mouse_Leave(Sender: TObject);

  private

  public

  end;

var
  f_editor: Tf_editor;

  // open files
  open_files:TStringList;

  // mouse position
	mouseX, mouseY:Integer;

implementation

uses
  u_pm, u_debug;

{$R *.lfm}

{ TCPageControl }

procedure TCPageControl.set_color(clr: TColor);
begin
  custom_olor:=clr;
  Color:=clr;
  BorderStyle:=bsNone;
  BorderWidth:=0;
end;

{ Tf_editor }

procedure Tf_editor.FormShow(Sender: TObject);
var i:Integer;
begin
  f_editor.Caption:='Редактор проекта - '+current_name;
  files.Root:=current_path;

  if pages.PageCount > 0 then begin
	  for i:=0 to pages.PageCount-1 do begin
      pages.Pages[0].Free;
    end;
  end;

  if FileExists('./data/projects_conf/'+current_name) then begin
    open_files.LoadFromFile('./data/projects_conf/'+current_name);
    if open_files.Count > 0 then begin
      for i:=0 to open_files.Count - 1 do begin
        add_tab(open_files.Strings[i], False);
      end;
    end;
  end;
end;

procedure Tf_editor.btn_saveClick(Sender: TObject);
var ed:TEditor;
begin
  ed:=TEditor(pages.ActivePage);

  // save active tab
  ed.frame.syn_editor.Lines.SaveToFile(ed.path);
end;

procedure Tf_editor.fs_backClick(Sender: TObject);
var path:TStringList;
		path_str:String;
begin
	if files.Root = current_path then Exit;

  path:=TStringList.Create;
  path.LineBreak:='/';
  path.Text:= files.Root;
  path.Delete(path.Count-1);
	path_str:=path.Text;
  path.Free;

  path_str:=path_str.TrimRight('/');
	files.Root:=path_str;
end;

// ADD TAB FUNCTION ////////////////////////////////////////////////////////////
procedure Tf_editor.add_tab(p: String; is_add: Boolean);
var ed_frame:Tf_frame_editor;
		ed:TEditor;
    ex:String;
    i:Integer;
    alr:Boolean = False;
    n:String;
begin

	for i:=0 to pages.PageCount -1 do begin
    if TEditor(pages.Page[i]).path = p then begin
      pages.ActivePageIndex:=i;
			alr:=True;
      Break;
    end;
  end;

	if alr then exit;

	n:=get_name_from_path(p);
  ex:=get_ex_from_path(p);

  if is_add then begin
	  open_files.Add(p);
    open_files.SaveToFile('./data/projects_conf/'+current_name);
  end;

	ed:=TEditor.Create(f_editor);
	ed.Caption:=n;
  ed.path:=p;

  ed_frame:=Tf_frame_editor.Create(pages);
  ed_frame.Align:=alClient;
  ed_frame.Name:='';
  ed_frame.set_path(p);
  ed_frame.init();

	// associate files
  if ex = 'js' then
    ed_frame.syn_editor.Highlighter:=ed_frame.hl_JavaScript;

	ed_frame.syn_editor.Lines.LoadFromFile(p);

	ed_frame.Parent:=ed;
  ed.frame:=ed_frame;
  ed.Parent:=pages;

  pages.ActivePageIndex:=pages.PageCount-1;
end;
////////////////////////////////////////////////////////////////////////////////


procedure Tf_editor.pagesChange(Sender: TObject);
begin
	TEditor(pages.ActivePage).frame.syn_editor.Focused;
end;

procedure Tf_editor.pagesCloseTabClicked(Sender: TObject);
var
    i:Integer;
begin
  Sender.Free;

	open_files.Clear;
	for i:=0 to pages.PageCount -1 do begin
    open_files.Add(TEditor(pages.Page[i]).path);
  end;

  open_files.SaveToFile('./data/projects_conf/'+current_name);
end;

procedure Tf_editor.On_Mouse_Enter(Sender: TObject);
begin
  TGraphicControl(Sender).Color:=gl_settings.gui_btn_color_entered;
end;

procedure Tf_editor.On_Mouse_Leave(Sender: TObject);
begin
  TGraphicControl(Sender).Color:=gl_settings.gui_btn_color;
end;

procedure Tf_editor.FormHide(Sender: TObject);
begin
  f_pm.Show;
  f_debug._STOP;
end;

procedure Tf_editor.filesDblClick(Sender: TObject);
var path:String;
begin
  if files.SelCount < 0 then Exit;

  path:=files.Root+'/'+files.Selected.Caption;

  if DirectoryExists(path) then
  	files.Root:=path
  else
    add_tab(path, True);

end;

procedure Tf_editor.btn_debugClick(Sender: TObject);
begin
  if f_debug.running then
    f_debug._STOP
  else
    f_debug.Show;
end;

procedure Tf_editor.On_Mouse_Move(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  mouseX:=X;
  mouseY:=Y;
end;

procedure Tf_editor.btn_closeClick(Sender: TObject);
var
    i:Integer;
begin
  pages.ActivePage.Free;
  open_files.Clear;
  for i:=0 to pages.PageCount -1 do begin
    open_files.Add(TEditor(pages.Page[i]).path);
  end;

  open_files.SaveToFile('./data/projects_conf/'+current_name);
end;

procedure Tf_editor.FormCreate(Sender: TObject);
begin
	pages:=TCPageControl.Create(f_editor);
	pages.Align:=alClient;
  pages.set_color(gl_settings.project_item_fill);

  pages.OnMouseMove:=@On_Mouse_Move;

	pages.Font.Color:=gl_settings.base_font_color;

  pages.OnCloseTabClicked:=@pagesCloseTabClicked;
  pages.OnChange:=@pagesChange;

  pages.Parent:=center_panel;


  open_files:=TStringList.Create;
  files.Columns[2].Visible:=false;

  files.sel

end;

end.

