
%======== Input ========
filename_input = input('Input file : ', 's');
fid_in = fopen(filename_input, 'r');
if fid_in == -1
    fprintf('File %s not found.\n', filename_input);
    return
end

Area = fscanf(fid_in, '%*s%*s%f', 1); fgetl(fid_in);   %Inside area: 600 in^2
Gap  = fscanf(fid_in, '%*s%f', 1);    fgetl(fid_in);   %Gap: 2 in
Amin = fscanf(fid_in, '%*s%f', 1);    fgetl(fid_in);   %Amin: 10 in
Amax = fscanf(fid_in, '%*s%f', 1);    fgetl(fid_in);   %Amax: 120 in
Ainc = fscanf(fid_in, '%*s%f', 1);    fgetl(fid_in);   %Ainc: 0.1 in
fclose(fid_in);

%======== Calculations ========
a = (Amin:Ainc:Amax)';         %base values
h = 2*Area./a;                 %height from fixed inner area
l = sqrt((a/2).^2 + h.^2);     %slant side of inner triangle
s = (a + 2*l)/2;                %semiperimeter of inner triangle
r = Area./s;                    %inradius of inner triangle
k = 1 + Gap./r;                 %scale factor to outer triangle
A_out = k.*a;                   %outer base
H_out = k.*h;                   %outer height
S = 0.5*A_out.*H_out;           %overall sign area

[S_min, idx] = min(S);
a_min = a(idx);
h_min = h(idx);

%======== Output ========
filename_output = input('Output file : ', 's');
fid_out = fopen(filename_output, 'w');
if fid_out == -1
    fprintf('File %s not found.\n', filename_output);
    return
end

fprintf(fid_out, 'Gap : %.4f in\n', Gap);
fprintf(fid_out, 'Inside Area : %.4f in^2\n', Area);
fprintf(fid_out, 'For minimum outside area :\n');
fprintf(fid_out, 'a : %.4f in\n', a_min);
fprintf(fid_out, 'h = %.4f in\n', h_min);
fprintf(fid_out, 'area = %.4f in\n', S_min);
fprintf(fid_out, '%15s%15s%15s\n', 'a', 'h', 'outside Area');
fprintf(fid_out, '%15.4f%15.4f%15.4f\n', [a, h, S]');
fclose(fid_out);