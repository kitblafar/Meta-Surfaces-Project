<?xml version="1.0" encoding="UTF-8"?>
<MetaResultFile version="20200629" creator="FE Port mode solver">
  <MetaGeometryFile filename="" lod="1"/>
  <SimulationProperties fieldname="Zmin Out p2" fieldtype="Powerflow" frequency="0" encoded_unit="&amp;U:V^1.:A^1.:m^-2" quantity="powerflow" fieldscaling="TIME_AVERAGE" dB_Amplitude="10"/>
  <ResultDataType vector="1" complex="0" timedomain="0"/>
  <SimulationDomain min="0 0 0" max="0 0 0"/>
  <PlotSettings Plot="1" ignore_symmetry="0" deformation="0" enforce_culling="0" default_arrow_type="ARROWS">
    <Plane normal="0 0 1" distance="-1157.5"/>
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
    <Frame index="0" characteristic="0.47586179978063498">
      <FieldResultFile filename="Port1_pout2(#0000).sct" type="sct" meshname="Port1.slim"/>
    </Frame>
    <Frame index="1" characteristic="0.47586028911065198">
      <FieldResultFile filename="Port1_pout2(#0001).sct" type="sct" meshname="Port1.slim"/>
    </Frame>
    <Frame index="2" characteristic="0.47586104444564337">
      <FieldResultFile filename="Port1_pout2(#0002).sct" type="sct" meshname="Port1.slim"/>
    </Frame>
  </ResultGroups>
</MetaResultFile>
