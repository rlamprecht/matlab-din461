# matlab-din461
Applies the DIN 461 style to a 2D plot in MATLAB.


# Example 1: Usage
```matlab
t = linspace(0, 40, 100);
u = 325*sin(2*pi*t/20);

set(0,'defaultFigurePaperSize',[150 100]);
set(0,'defaultTextInterpreter','latex');
set(0,'defaultTextFontsize',12);
set(0,'defaultTextFontname','Times');
set(0,'defaultAxesGridColor','k');
set(0,'defaultAxesGridAlpha',0.5);
set(0,'defaultAxesGridLineStyle',':');
set(0,'defaultAxesFontsize',12);
set(0,'defaultAxesFontname','Times');
set(0,'defaultFigureColor','w');

plot(t, u, 'b');
grid on;

din461('$t$', '$u$', 'ms', 'V', [0 1]);
```

![Example 1](/screenshots/example1.png?raw=true)

# Example 2: Degree unit
![Example 2](/screenshots/example2.png?raw=true)