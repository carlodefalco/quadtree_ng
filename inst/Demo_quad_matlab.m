%% Demo Quadtree - Matlab Version

qt = quadtree_matlab(1, 1, 10);
qt.refine (1); qt.refresh ();
qt.refine (2); qt.refresh ();
qt.refine (3); qt.refresh ();
qt.refine (4); qt.refresh ();
qt.refine (8); qt.refresh ();
qt.refine (13); qt.refresh ();
qt.refine (qt.num_quadrants ()); qt.refresh ();
qt.refine (qt.num_quadrants ()); qt.refresh ();
qt.refine (qt.num_quadrants ()); qt.refresh ();
qt.refine (12); qt.refresh ();
qt.refine (12); qt.refresh ();
qt.refine (12); qt.refresh ();
qt.refine (12); qt.refresh ();
qt.paint ();