% script_test_fcn_PlotTire_plotTireOverhead
% Use section width as radial thickness:
fcn_PlotTire_plotTireOverhead(0.205, 0.315, 'UseSectionAsRadial', true)
% Provide actual rim radius:
fcn_PlotTire_plotTireOverhead(0.205, 0.315, 'RimRadius', 0.115)
% Change visual mapping:
fcn_PlotTire_plotTireOverhead(0.205, 0.315, 'WidthToRadialScale', 0.4, 'FaceColor', [0.2 0.2 0.2])