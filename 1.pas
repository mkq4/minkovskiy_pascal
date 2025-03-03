uses GraphABC;

// Процедура для рисования линии с округлением координат
procedure RLine(x, y, x1, y1: real) := Line(Round(x), Round(y), Round(x1), Round(y1));

// Функция для вычисления угла между двумя точками
function GetAngle(x, y, x2, y2: real): real;
begin
  var angle := Abs(RadToDeg(ArcTan((y2 - y) / (x2 - x))));
  if (x2 = x) and (y2 = y) then
    Result := 0
  else
  if x2 > x then
    if y2 > y then Result := angle else Result := 360 - angle
    else
  if y2 > y then Result := 180 - angle else Result := 180 + angle;
end;

// Функция для вычисления расстояния между двумя точками
function Distance(x, y, x1, y1: real) := Sqrt(Sqr(x1 - x) + Sqr(y1 - y)); 

// Глобальные переменные
var m: integer; // Глубина рекурсии
var scale: real := 1.0; // Масштаб

// Процедура для рекурсивного рисования линии
procedure Draw(x, y, x1, y1: real);
begin
  var r := Distance(x, y, x1, y1);
  if r < 4**m then
    RLine(x, y, x1, y1)
  else
  begin
    var angle := GetAngle(x, y, x1, y1);
    var angleP := DegToRad(angle + 90);
    var angleM := DegToRad(angle - 90);
    r /= 4;
    var dx := (x1 - x) / 4;
    var dy := (y1 - y) / 4;
    var xA := x + dx;
    var yA := y + dy;
    var xB := xA + dx;
    var yB := yA + dy;
    var xC := xB + dx;
    var yC := yB + dy;
    var x2 := xA + r * Cos(angleP);
    var y2 := yA + r * Sin(angleP);
    var x3 := xB + r * Cos(angleP);
    var y3 := yB + r * Sin(angleP);
    var x4 := xB + r * Cos(angleM);
    var y4 := yB + r * Sin(angleM);
    var x5 := xC + r * Cos(angleM);
    var y5 := yC + r * Sin(angleM);
    Draw(x, y, xA, yA);
    Draw(xA, yA, x2, y2);
    Draw(x2, y2, x3, y3);
    Draw(x3, y3, xB, yB);
    Draw(xB, yB, x4, y4);
    Draw(x4, y4, x5, y5);
    Draw(x5, y5, xC, yC);
    Draw(xC, yC, x1, y1);
  end;
end;

// Глобальные переменные для координат линии
var x, y, x1, y1: integer;

// Процедура для обработки нажатий клавиш
procedure KeyDown(key: integer);
begin
  case key of
    VK_Up: begin y := y - 5; y1 := y1 - 5 end; // Вверх
    VK_Down: begin y += 5; y1 += 5 end; // Вниз
    VK_Left: begin x := x - 5; x1 := x1 - 5 end; // Влево
    VK_Right: begin x := x + 5; x1 := x1 + 5 end; // Вправо
    VK_A: scale := scale * 1.1; // Увеличить масштаб
    Vk_Z: scale := scale / 1.1; // Уменьшить масштаб
    vk_s: if m > 0 then m -= 1; // Уменьшить глубину рекурсии
    vk_x: if m < 4 then m += 1; // Увеличить глубину рекурсии
  end; 
  Window.Clear; 
  draw(x * scale, y * scale, x1 * scale, y1 * scale); // Применить масштаб
  redraw;
end;

// Основной блок программы
begin
  LockDrawing; // Включаем оптимизацию отрисовки
  x := 100; // Начальная координата X
  y := 200; // Начальная координата Y
  x1 := 400; // Конечная координата X
  y1 := 200; // Конечная координата Y
  m := 2; // Начальная глубина рекурсии
  scale := 1.0; // Начальный масштаб
  draw(x, y, x1, y1); // Рисуем начальную линию
  redraw; // Обновляем экран
  onKeyDown += keydown; // Назначаем обработчик событий клавиатуры
end.
