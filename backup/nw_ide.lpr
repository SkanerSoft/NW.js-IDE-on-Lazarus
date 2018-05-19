program nw_ide;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$DEFINE UseCThreads}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, u_pm, u_editor, u_functions, u_frame_editor, u_debug, u_settings
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Initialize;
  Application.CreateForm(Tf_pm, f_pm);
  Application.CreateForm(Tf_editor, f_editor);
  Application.CreateForm(Tf_debug, f_debug);
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

