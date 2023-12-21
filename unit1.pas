unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Math;

type
  { TWaterMachine }
  TWaterMachine = class(TForm)
    larr_btn: TButton;
    rarr_btn: TButton;
    pull_btn: TButton;
    dot_btn: TButton;
    reset_btn: TButton;
    state_field: TEdit;
    timer: TTimer;

    procedure Reset;
    procedure reset_btnClick(Sender: TObject);

    procedure FormCreate(Sender: TObject);

    procedure ChooseState(Sender : TObject);
    procedure PayState(Sender : TObject);
    procedure PlaceState(Sender : TObject);
    procedure PullState(Sender : TObject);

    procedure TakeState(Sender : TObject);

    procedure SetState;
    procedure timerTimer(Sender: TObject);

  private

  public

  end;

var
  WaterMachine: TWaterMachine;
  state,tick : Integer; // состояние,текущий тик автомата
  paid,price : Integer; // количество денег в автомате,цена
implementation


{$R *.lfm}

{ TWaterMachine }

// Строковое описание состояний
procedure TWaterMachine.SetState;

var tmps : string; // строка для
    i : integer;
begin
    case state mod 6 of
        0:
          begin
          state_field.Text := IntToStr(price div 3) + 'л.';
          // костыль
          dot_btn.OnClick :=  @ChooseState;
          rarr_btn.OnClick := @ChooseState;
          larr_btn.OnClick := @ChooseState;
          pull_btn.OnClick := @ChooseState;

          end;
        1:
          begin
          state_field.Text := 'Добавьте ' + IntToStr(price - paid) +  ' деняг';

          // костыль
          dot_btn.OnClick :=  @PayState;
          rarr_btn.OnClick := @PayState;
          larr_btn.OnClick := @PayState;
          pull_btn.OnClick := @PayState;
          end;
        2:
          begin
          state_field.Text := 'Вставьте тару';

           // костыль
          dot_btn.OnClick :=  @PlaceState;
          rarr_btn.OnClick := @PlaceState;
          larr_btn.OnClick := @PlaceState;
          pull_btn.OnClick := @PlaceState;
          end;
        3:
          begin
          state_field.Text := 'Нажмите налить';

           // костыль
          dot_btn.OnClick :=  @PullState;
          rarr_btn.OnClick := @PullState;
          larr_btn.OnClick := @PullState;
          pull_btn.OnClick := @PullState;

          end;

        4:
          begin
          if timer.Enabled = false then timer.Enabled := true;;
          // красивые точки
          for i := 0 to tick mod 3 do
          begin
              tmps := tmps + '.';
          end;
          state_field.Text := 'Наливается' + tmps;

           // костыль
          dot_btn.OnClick :=  nil;
          rarr_btn.OnClick := nil;
          larr_btn.OnClick := nil;
          pull_btn.OnClick := nil;

          end;
        5:
          begin
          state_field.Text := 'Заберите тару';
          // костыль
          dot_btn.OnClick :=  @TakeState;
          rarr_btn.OnClick := @TakeState;
          larr_btn.OnClick := @TakeState;
          pull_btn.OnClick := @TakeState;

          end;
    else
        state_field.Text := 'Ошибка: неизвестное состояние';
    end;
end;




// Описание состояний

// Сброс в начальное состояние
procedure TWaterMachine.Reset;
begin
     state := 0;
     paid := 0;
     price := 15;
     tick := 0;
     SetState;
end;

// Вызывает метод Reset из TWaterMachine
procedure TWaterMachine.reset_btnClick(Sender: TObject);
begin
      Reset();
      MessageDlg('Все параметры сброшены', mtInformation, [mbOK], 0);  // DEBUG INFO
end;


// Описывает состояние выбора товара (состояние 0)
procedure TWaterMachine.ChooseState(Sender : TObject);
begin
   if Sender = larr_btn then
   begin
        price := Math.Max(15,price - 15);
   end
   else if Sender = rarr_btn then
   begin
        price := Math.Min(60,price + 15);
   end
   else if Sender = dot_btn then
   begin
        state := state + 1;
   end;
   SetState;
end;

// Описывает состояние внесения денег (состояние 1)
procedure TWaterMachine.PayState(Sender : TObject);
begin
      if Sender = larr_btn then
   begin
        paid := paid + 1;
   end
   else if Sender = rarr_btn then
   begin
        paid := paid + 10;
   end
   else if Sender = dot_btn then
   begin
        paid := paid + 5;
   end;
   if paid >= price then state := state + 1;
   SetState;
end;



// Описывает состояние установки тары (состояние 2)
procedure TWaterMachine.PlaceState(Sender : TObject);
begin
   if Sender = dot_btn then state := state + 1;
   SetState;
end;

// Описывает состояние старта (наливание воды, состояние 3)
procedure TWaterMachine.PullState(Sender : TObject);
begin
   if Sender = pull_btn then state := state + 1;
   SetState;
end;

// Описывает наливания воды (состояние 4)
procedure TWaterMachine.timerTimer(Sender: TObject);
begin
     tick := tick + 1;
     if tick >= 10 then
          begin
               timer.Enabled := false;
               state := state + 1;
          end;
     SetState;
end;



// Описывает состояние взятия "тары"  (состояние 5)
procedure TWaterMachine.TakeState(Sender : TObject);
begin
   if Sender = dot_btn then Reset();
   SetState;
end;

// Инициализация формы
procedure TWaterMachine.FormCreate(Sender: TObject);
begin
    Reset();
end;
end.

