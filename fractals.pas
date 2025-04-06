unit fractals;

interface

uses GraphABC;

// Рисует линию от (x, y) до (x1, y1), округляя координаты до целых
procedure RLine(x, y, x1, y1: real);

// Возвращает угол между двумя точками (в градусах)
function GetAngle(x, y, x2, y2: real): real;

// Возвращает расстояние между двумя точками
function Distance(x, y, x1, y1: real): real;

// Основная рекурсивная процедура, рисующая фрактал
procedure Draw(x, y, x1, y1: real);

// Глобальные переменные
var
  m: integer;        // глубина рекурсии
  scale: real;       // масштаб изображения
  x, y, x1, y1: integer; // координаты начальной линии

implementation

// Рисует линию с округлением координат
procedure RLine(x, y, x1, y1: real);
begin
  Line(Round(x), Round(y), Round(x1), Round(y1));
end;

// Вычисляет угол между точками в градусах (0–360)
function GetAngle(x, y, x2, y2: real): real;
begin
  var angle := Abs(RadToDeg(ArcTan((y2 - y) / (x2 - x))));
  if (x2 = x) and (y2 = y) then
    Result := 0
  else if x2 > x then
    if y2 > y then Result := angle else Result := 360 - angle
  else if y2 > y then Result := 180 - angle else Result := 180 + angle;
end;

// Вычисляет расстояние между точками
function Distance(x, y, x1, y1: real): real;
begin
  Result := Sqrt(Sqr(x1 - x) + Sqr(y1 - y));
end;

// Рекурсивная процедура рисования кривой Минковского
procedure Draw(x, y, x1, y1: real);
begin
  var r := Distance(x, y, x1, y1); // Вычисляем расстояние между точками

  // Базовый случай рекурсии: если отрезок слишком короткий, просто рисуем его
  if r < 4**m then
    RLine(x, y, x1, y1)
  else
  begin
    var angle := GetAngle(x, y, x1, y1); // Угол направления отрезка
    var angleP := DegToRad(angle + 90); // Угол для выступа вверх
    var angleM := DegToRad(angle - 90); // Угол для выступа вниз

    r /= 4; // делим длину отрезка на 4

    // Вычисляем смещение по x и y для одной четверти отрезка
    var dx := (x1 - x) / 4;
    var dy := (y1 - y) / 4;

    // Промежуточные точки деления отрезка на 4 части
    var xA := x + dx;
    var yA := y + dy;
    var xB := xA + dx;
    var yB := yA + dy;
    var xC := xB + dx;
    var yC := yB + dy;

    // Выступы вверх (x2, x3) и вниз (x4, x5) от основной линии
    var x2 := xA + r * Cos(angleP);
    var y2 := yA + r * Sin(angleP);
    var x3 := xB + r * Cos(angleP);
    var y3 := yB + r * Sin(angleP);
    var x4 := xB + r * Cos(angleM);
    var y4 := yB + r * Sin(angleM);
    var x5 := xC + r * Cos(angleM);
    var y5 := yC + r * Sin(angleM);

    // Рекурсивно рисуем 8 отрезков, заменяющих исходный:
    Draw(x, y, xA, yA);             // первая четверть
    Draw(xA, yA, x2, y2);           // вниз
    Draw(x2, y2, x3, y3);           // горизонталь внизу
    Draw(x3, y3, xB, yB);           // вверх
    Draw(xB, yB, x4, y4);           // вверх
    Draw(x4, y4, x5, y5);           // горизонталь вверху
    Draw(x5, y5, xC, yC);           // вниз
    Draw(xC, yC, x1, y1);           // последняя четверть
  end;
end;

end.
