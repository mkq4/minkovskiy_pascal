uses GraphABC, fractals;


procedure KeyDown(key: integer); // обрабатываем кнопки
begin
  case key of
    VK_Up: begin y := y - 5; y1 := y1 - 5 end; // вверх
    VK_Down: begin y += 5; y1 += 5 end; // вниз
    VK_Left: begin x := x - 5; x1 := x1 - 5 end; // влево
    VK_Right: begin x := x + 5; x1 := x1 + 5 end; // вправо
    VK_A: scale := scale * 1.1; // масштаб +
    Vk_Z: scale := scale / 1.1; // масштаб -
    vk_s: if m > 0 then m -= 1; // глубинa рекурсии +
    vk_x: if m < 4 then m += 1; // глубинa рекурсии -
  end; 
  Window.Clear; 
  Draw(x * scale, y * scale, x1 * scale, y1 * scale); // применить масштаб
  Redraw;
end;


begin
  LockDrawing; // оптимизация отрисовки
  x := 100; // X start
  y := 200; // Y start
  x1 := 400; // X end
  y1 := 200; // Y end
  m := 3; // глубина рекурсии start
  scale := 1.0; // масштаб start
  Draw(x, y, x1, y1); // линия 1
  Redraw; // обновляем экран
  OnKeyDown += KeyDown; // обработчик событий клавиатуры start
end.
