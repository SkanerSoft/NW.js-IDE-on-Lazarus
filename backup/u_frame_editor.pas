unit u_frame_editor;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, SynEdit, SynHighlighterJScript, Forms, Controls,
  ExtCtrls, StdCtrls, SynEditKeyCmds, LCLType, SynEditMarkupHighAll, Graphics;

type

  { Tf_frame_editor }

  Tf_frame_editor = class(TFrame)
    hl_JavaScript: TSynJScriptSyn;
    menu_cut: TLabel;
    menu_box: TScrollBox;
    menu_paste: TLabel;
    menu_copy: TLabel;
    syn_editor: TSynEdit;

    procedure menu_pasteClick(Sender: TObject);
    procedure menu_copyClick(Sender: TObject);
    procedure menu_cutClick(Sender: TObject);
    procedure menu_cutMouseEnter(Sender: TObject);
    procedure menu_cutMouseLeave(Sender: TObject);
    procedure set_path(p:String);
    procedure init();
    procedure syn_editorCommandProcessed(Sender: TObject;
      var Command: TSynEditorCommand; var AChar: TUTF8Char; Data: pointer);
    procedure syn_editorMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private

  public

  end;

var
  path:String;

implementation

uses
  u_functions;

{$R *.lfm}


{ Tf_frame_editor }

procedure Tf_frame_editor.set_path(p: String);
begin
	path:=p;
end;

procedure Tf_frame_editor.menu_cutMouseEnter(Sender: TObject);
begin
  TLabel(Sender).Color:=gl_settings.gui_btn_color_entered;
end;

procedure Tf_frame_editor.menu_cutClick(Sender: TObject);
begin
  syn_editor.CutToClipboard;
  menu_box.Visible:=False;
end;

procedure Tf_frame_editor.menu_copyClick(Sender: TObject);
begin
  syn_editor.CopyToClipboard;
  menu_box.Visible:=False;
end;

procedure Tf_frame_editor.menu_pasteClick(Sender: TObject);
begin
  syn_editor.PasteFromClipboard;
  menu_box.Visible:=False;
end;

procedure Tf_frame_editor.menu_cutMouseLeave(Sender: TObject);
begin
  TLabel(Sender).Color:=gl_settings.gui_btn_color;
end;

procedure Tf_frame_editor.init();
var SynMarkup: TSynEditMarkupHighlightAllCaret;
begin
  SynMarkup := TSynEditMarkupHighlightAllCaret(syn_editor.MarkupByClass[TSynEditMarkupHighlightAllCaret]);

  SynMarkup.MarkupInfo.FrameColor := $AAAAAA;
  //SynMarkup.MarkupInfo.Background := $FFFFFF;
  SynMarkup.WaitTime := 500;
  SynMarkup.Trim := True;
  SynMarkup.FullWord := True;
  SynMarkup.IgnoreKeywords := False;
end;

procedure Tf_frame_editor.syn_editorCommandProcessed(Sender: TObject;
  var Command: TSynEditorCommand; var AChar: TUTF8Char; Data: pointer);
begin
	if Command = ecUserDefinedFirst then begin
    syn_editor.Lines.SaveToFile(path);
  end;
end;

procedure Tf_frame_editor.syn_editorMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbRight then begin

		menu_cut.Enabled:=syn_editor.SelText <> '';
		menu_copy.Enabled:=syn_editor.SelText <> '';

		menu_box.Left:=X - 10;
    menu_box.Top:=Y - 10;

    if menu_box.Left+menu_box.Width > syn_editor.Left+syn_editor.Width then
    	menu_box.Left:=syn_editor.Left+syn_editor.Width-menu_box.Width;

    if menu_box.Top+menu_box.Height > syn_editor.Top+syn_editor.Height then
    	menu_box.Top:=syn_editor.Top+syn_editor.Height-menu_box.Height;

    menu_box.Visible:=True;
  end else
  	menu_box.Visible:=False;
end;

end.

