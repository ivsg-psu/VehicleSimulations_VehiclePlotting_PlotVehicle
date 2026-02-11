% script_test_fcn_PlotTire_plotTireOverheadWithTread
% Block tread with 48 blocks: 
fcn_PlotTire_plotTireOverheadWithTread(0.205,0.315,'Pattern','block','NumElements',48,'BlockDepth',0.012)
% Circumferential grooves: 
fcn_PlotTire_plotTireOverheadWithTread(0.205,0.315,'Pattern','circumferential','NumElements',60,'GrooveWidth',0.002)
% Chevron directional pattern rotated 30°: 
fcn_PlotTire_plotTireOverheadWithTread(0.205,0.315,'Pattern','chevron','NumElements',36,'OrientAngle',30)
