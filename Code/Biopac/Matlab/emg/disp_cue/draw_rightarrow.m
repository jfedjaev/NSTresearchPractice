function draw_rightarrow(hObj, eventdata)
X = [0.5 0.75];
Y = [0.5 0.5];
ar = annotation('arrow',X,Y);
ar.Color = 'red';
ar.LineWidth = 3;
end 