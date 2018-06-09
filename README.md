# matlab-din461
Applies the DIN 461 style to a 2D plot in MATLAB.


# Usage
* Basic usage:
```matlab
t = linspace(0, 40, 100);
u = 325*sin(2*pi*t/20);

set_default_plot_properties();
plot(t, u, 'b');
din461('$t$', '$u$', 'ms', 'V');
```

* Replace the penultimate number with the unit label instead of placing the unit label between the last and the penultimate number:
```matlab
din461('$t$', '$u$', 'ms', 'V', 'replacePenultimate', [1 1]);
```

* Vertical y label instead of horizontal y label:
```matlab
din461('$t$', '$u$', 'ms', 'V', 'verticalYLabel', 1);
```

* For subplots use the function subaxes instead of subplot.

# Examples
![Example 1](/screenshots/example1.png?raw=true)
![Example 2](/screenshots/example2.png?raw=true)