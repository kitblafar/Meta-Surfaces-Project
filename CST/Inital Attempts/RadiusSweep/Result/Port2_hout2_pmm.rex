<?xml version="1.0" encoding="UTF-8"?>
<MetaResultFile version="20200629" creator="FE Port mode solver">
  <MetaGeometryFile filename="" lod="1"/>
  <SimulationProperties fieldname="Zmax Out h2" fieldtype="H-Field" frequency="0" encoded_unit="&amp;U:A^1.:m^-1" quantity="h-field" fieldscaling="PEAK" dB_Amplitude="20"/>
  <ResultDataType vector="1" complex="1" timedomain="0"/>
  <SimulationDomain min="0 0 0" max="0 0 0"/>
  <PlotSettings Plot="1" ignore_symmetry="0" deformation="0" enforce_culling="0" default_arrow_type="ARROWS">
    <Plane normal="0 0 1" distance="292.5"/>
  </PlotSettings>
  <Source type="SOLVER"/>
  <SpecialMaterials>
    <Background type="NORMAL"/>
  </SpecialMaterials>
  <AuxGeometryFile/>
  <AuxResultFile/>
  <FieldFreeNodes/>
  <SurfaceFieldCoefficients/>
  <UnitCell/>
  <SubVolume/>
  <Units>
    <Quantity name="Length" unit="nm" factor="1.0000000000000001e-09"/>
    <Quantity name="Time" unit="ps" factor="9.9999999999999998e-13"/>
    <Quantity name="Frequency" unit="PHz" factor="1000000000000000"/>
    <Quantity name="Temperature" unit="K" factor="1"/>
  </Units>
  <ResultGroups num_steps="3" transformation="1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1">
    <Frame index="0" characteristic="0.46121987572288597">
      <FieldResultFile filename="Port2_hout2(#0000).sct" type="sct" meshname="Port2.slim"/>
    </Frame>
    <Frame index="1" characteristic="0.46121845658699001">
      <FieldResultFile filename="Port2_hout2(#0001).sct" type="sct" meshname="Port2.slim"/>
    </Frame>
    <Frame index="2" characteristic="0.4612191661549378">
      <FieldResultFile filename="Port2_hout2(#0002).sct" type="sct" meshname="Port2.slim"/>
    </Frame>
  </ResultGroups>
</MetaResultFile>
