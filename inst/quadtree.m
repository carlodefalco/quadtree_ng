## Copyright (C) 2020 Carlo de Falco
##
## This program is free software; you can redistribute it and/or modify it under
## the terms of the GNU General Public License as published by the Free Software
## Foundation; either version 3 of the License, or (at your option) any later
## version.
##
## This program is distributed in the hope that it will be useful, but WITHOUT
## ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
## FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
## details.
##
## You should have received a copy of the GNU General Public License along with
## this program; if not, see <http://www.gnu.org/licenses/>.

classdef quadtree < handle

  properties
    H = 1;
    W = 1;
    N = 512;
    S = sparse (512, 512);
    dx = 1/512;
    dy = 1/512;
    I=[];
    J=[];
    V=[];
    marker = [];
  endproperties

  methods

    function qt = quadtree (H, W, N)
      if (nargin > 0)
        N    = 2^N;
        qt.H = H;
        qt.W = W;
        qt.N = N;
        qt.S = sparse (N, N);
        qt.dx = W/N;
        qt.dy = H/N;
      endif
      qt.S(1,1) = qt.N;
      qt.refresh ();      
    endfunction

    function qt = refresh (qt)
      [qt.I, qt.J, qt.V] = find (qt.S);
      qt.marker = zeros (size (qt.V));
    endfunction
    
    function n = num_quadrants (qt)
      n = nnz (qt.S);
    endfunction

    function [x0, y0, x1, y1] = idx2coord (qt, i, j)
      x0 = (j-1) * qt.dx;
      y0 = (i-1) * qt.dy;
      if (nargout > 2)
        x1 = x0 + qt.S(i,j) * qt.dx;
        y1 = y0 + qt.S(i,j) * qt.dy;
      endif
    endfunction

    function [i, j] = num2idx (qt, k)
      [i, j] = deal (qt.I(k), qt.J(k));
    endfunction

    function refine (qt, k)
      [i, j] = num2idx (qt, k);
      s = qt.S(i,j);
      if s > 1
        s /= 2;
        qt.S(i, j) = s;
        qt.S(i+s, j) = s;
        qt.S(i, j+s) = s;
        qt.S(i+s, j+s) = s;
      endif
      
    endfunction

    function h = draw_quadrant (qt, k)
      [i, j, v] = deal (qt.I(k), qt.J(k), qt. V(k));
      [x0, y0, x1, y1] = idx2coord (qt, i, j);
      h = plot ([x0, x1, x1, x0, x0], [y0, y0, y1, y1, y0], 'k');
    endfunction    

    function draw (qt)
      for k = 1 : qt.num_quadrants ()
        draw_quadrant (qt, k);
        hold on
      endfor 
    endfunction

    function paint (qt)
      I = full (qt.S);
      I(qt.N+1,qt.N+1)=0;
      [x0, y0] = meshgrid (linspace (0, qt.W, qt.N+1),
                           linspace (0, qt.H, qt.N+1));
      for k = 1 : qt.num_quadrants ()
        [i, j, v] = deal (qt.I(k), qt.J(k), qt. V(k));        
        I(i-1+(1:v), j-1+(1:v)) = v;  
      endfor
      hold on
      h = pcolor (x0, y0, I);
      set (h, 'edgecolor', 'none');
      qt.draw ();
    endfunction

    function p = firstborn (qt, k)
      p = floor (log2 (k-1));
    endfunction
    
  endmethods
  
endclassdef

%!demo
%! qt = quadtree (1, 1, 10);
%! qt.refine (1); qt.refresh ();
%! qt.refine (2); qt.refresh ();
%! qt.refine (3); qt.refresh ();
%! qt.refine (4); qt.refresh ();
%! qt.refine (8); qt.refresh ();
%! qt.refine (13); qt.refresh ();
%! qt.refine (qt.num_quadrants ()); qt.refresh ();
%! qt.refine (qt.num_quadrants ()); qt.refresh ();
%! qt.refine (qt.num_quadrants ()); qt.refresh ();
%! qt.refine (12); qt.refresh ();
%! qt.refine (12); qt.refresh ();
%! qt.refine (12); qt.refresh ();
%! qt.refine (12); qt.refresh ();
%! qt.paint ();
