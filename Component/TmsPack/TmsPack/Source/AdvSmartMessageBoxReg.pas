{*************************************************************************}
{ TMS AdvSmartMessageBox component                                        }
{ for Delphi & C++Builder                                                 }
{ version 1.0                                                             }
{                                                                         }
{ written by TMS Software                                                 }
{           copyright �  2007                                             }
{           Email : info@tmssoftware.com                                  }
{           Web : http://www.tmssoftware.com                              }
{                                                                         }
{ The source code is given as is. The author is not responsible           }
{ for any possible damage done due to the use of this code.               }
{ The component can be freely used in any application. The complete       }
{ source code remains property of the author and may not be distributed,  }
{ published, given or sold in any form as such. No parts of the source    }
{ code can be included in any other component or application without      }
{ written authorization of the author.                                    }
{*************************************************************************}

unit AdvSmartMessageBoxReg;

interface
{$I TMSDEFS.INC}

uses
  Classes, AdvSmartMessageBox;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('TMS', [TAdvSmartMessageBox]);
end;

end.

