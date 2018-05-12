# matlab-din461
Applies the DIN 461 style to a 2D plot in MATLAB.


# Usage
* basic usage:
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

din461('$t$', '$u$', 'ms', 'V');
```

* replace the penultimate number with the unit label instead of placing the unit label between the last and the penultimate number:
```matlab
din461('$t$', '$u$', 'ms', 'V', 'replacePenultimate', [1 1]);
```

* vertical y label instead of horizontal y label:
```matlab
din461('$t$', '$u$', 'ms', 'V', 'verticalYLabel', 1);
```

# Examples
![Example 1](/screenshots/example1.png?raw=true)
![Example 2](/screenshots/example2.png?raw=true)