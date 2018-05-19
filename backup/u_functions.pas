unit u_functions;

{$mode objfpc}{$H+}

interface


uses
  Classes, SysUtils, process, Controls, Graphics, Forms;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
// SETTINGS VARS ///////////////////////////////////////////////////////////////
type

  TGlobal_settings = record
    gui_btn_color, gui_btn_color_entered,
    project_item_fill, base_font_color:TColor;

  end;

var

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
// NW VARS /////////////////////////////////////////////////////////////////////

nw_path:String = '';
all_projects:String = '';

current_path:String = '';
current_name:String = '';

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////// NAMESPACE ///////////////////////////////////////////////////////////////

gl_settings : TGlobal_settings;

// funxtions namespace
function get_line(obj:TStringList; index:Integer):String;

// files
procedure write_file(path:String; data:String);
procedure append_file(path:String; data:String);
function get_ex_from_path(p:String):String;
function get_name_from_path(p: String): String;

// NW.js
procedure nw_run(path:String);

// Settings
procedure init_color_theme;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
implementation
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
// funxtions ///////////////////////////////////////////////////////////////////

function get_line(obj:TStringList; index:Integer):String;
begin
  if index < obj.Count then
		get_line:=obj.Strings[index]
  else
  	get_line:='';
end;

procedure write_file(path: String; data: String);
var f:TextFile;
begin
	AssignFile(f, path);
	Rewrite(f);
	Write(f, data);
	CloseFile(f);
end;

procedure append_file(path: String; data: String);
var f:TextFile;
begin
	AssignFile(f, path);
	Append(f);
	Write(f, data);
	CloseFile(f);
end;

function get_ex_from_path(p: String): String;
var arr:array of String;
		ex:String;
begin
	arr:=p.Split('/');
	ex:=arr[Length(arr)-1];
	arr:=ex.Split('.');
	get_ex_from_path:=arr[Length(arr)-1];
end;

function get_name_from_path(p: String): String;
var arr:array of String;
		ex:String;
begin
	arr:=p.Split('/');
	get_name_from_path:=arr[Length(arr)-1];
end;

procedure nw_run(path: String);
var pr:TProcess;
begin
  // create process
	pr:=TProcess.Create(nil);

	// argiments
  pr.Parameters.Add(path);

  // NW.js
	pr.Executable:=nw_path;

	// run
  pr.Execute;

  // delete process
  pr.Free;
end;

procedure init_color_theme;
begin
  // init settings /////////////////////////////////////////////////////////////
	gl_settings.gui_btn_color:=$5C5C5C;
  gl_settings.gui_btn_color_entered:=$999999;
  gl_settings.project_item_fill:=$777777;
  gl_settings.base_font_color:=$CCCCCC;
  //////////////////////////////////////////////////////////////////////////////
end;


end.
