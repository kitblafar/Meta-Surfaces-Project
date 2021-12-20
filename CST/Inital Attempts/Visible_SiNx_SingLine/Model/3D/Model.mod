'# MWS Version: Version 2021.1 - Nov 10 2020 - ACIS 30.0.1 -

'# length = nm
'# frequency = PHz
'# time = ps
'# frequency range: fmin = (CLight * 1e-06)/(lambda+0.001) fmax = (CLight * 1e-06)/(lambda-0.001)
'# created = '[VERSION]2021.0|30.0.1|20200908[/VERSION]


'@ new component: component1

'[VERSION]2021.0|30.0.1|20200908[/VERSION]
Component.New "component1"

'@ define brick: component1:Substrate

'[VERSION]2021.0|30.0.1|20200908[/VERSION]
With Brick
     .Reset 
     .Name "Substrate" 
     .Component "component1" 
     .Material "Vacuum" 
     .Xrange "-s/2", "s/2" 
     .Yrange "-s/2", "s/2" 
     .Zrange "-h2", "0" 
     .Create
End With

'@ define units

'[VERSION]2021.0|30.0.1|20200908[/VERSION]
With Units 
     .Geometry "nm" 
     .Frequency "THz" 
     .Time "ps" 
     .TemperatureUnit "Kelvin" 
     .Voltage "V" 
     .Current "A" 
     .Resistance "Ohm" 
     .Conductance "Siemens" 
     .Capacitance "PikoF" 
     .Inductance "NanoH" 
     .SetResultUnit "frequency", "frequency", "" 
End With

'@ define cylinder: component1:Pillar

'[VERSION]2021.0|30.0.1|20200908[/VERSION]
With Cylinder 
     .Reset 
     .Name "Pillar" 
     .Component "component1" 
     .Material "Vacuum" 
     .OuterRadius "r0" 
     .InnerRadius "0" 
     .Axis "z" 
     .Zrange "0", "h1" 
     .Xcenter "0" 
     .Ycenter "0" 
     .Segments "0" 
     .Create 
End With

'@ define material: fused silica

'[VERSION]2021.0|30.0.1|20200908[/VERSION]
With Material
     .Reset
     .Name "fused silica"
     .Folder ""
     .Rho "0"
     .ThermalType "Normal"
     .ThermalConductivity "0"
     .SpecificHeat "0", "J/K/kg"
     .DynamicViscosity "0"
     .Emissivity "0"
     .MetabolicRate "0"
     .VoxelConvection "0"
     .BloodFlow "0"
     .MechanicsType "Unused"
     .FrqType "all"
     .Type "Normal"
     .MaterialUnit "Frequency", "THz"
     .MaterialUnit "Geometry", "nm"
     .MaterialUnit "Time", "ps"
     .MaterialUnit "Temperature", "Kelvin"
     .Epsilon "2.12"
     .Mu "1"
     .Sigma "0"
     .TanD "0.0"
     .TanDFreq "0.0"
     .TanDGiven "False"
     .TanDModel "ConstTanD"
     .SetConstTanDStrategyEps "AutomaticOrder"
     .ConstTanDModelOrderEps "1"
     .DjordjevicSarkarUpperFreqEps "0"
     .SetElParametricConductivity "False"
     .ReferenceCoordSystem "Global"
     .CoordSystemType "Cartesian"
     .SigmaM "0"
     .TanDM "0.0"
     .TanDMFreq "0.0"
     .TanDMGiven "False"
     .TanDMModel "ConstTanD"
     .SetConstTanDStrategyMu "AutomaticOrder"
     .ConstTanDModelOrderMu "1"
     .DjordjevicSarkarUpperFreqMu "0"
     .SetMagParametricConductivity "False"
     .DispModelEps  "None"
     .DispModelMu "None"
     .DispersiveFittingSchemeEps "Nth Order"
     .MaximalOrderNthModelFitEps "10"
     .ErrorLimitNthModelFitEps "0.1"
     .DispersiveFittingSchemeMu "Nth Order"
     .MaximalOrderNthModelFitMu "10"
     .ErrorLimitNthModelFitMu "0.1"
     .UseGeneralDispersionEps "False"
     .UseGeneralDispersionMu "False"
     .NLAnisotropy "False"
     .NLAStackingFactor "1"
     .NLADirectionX "1"
     .NLADirectionY "0"
     .NLADirectionZ "0"
     .Colour "1", "0.501961", "1" 
     .Wireframe "False" 
     .Reflection "False" 
     .Allowoutline "True" 
     .Transparentoutline "False" 
     .Transparency "0" 
     .Create
End With

'@ define material: Silicon Nitride

'[VERSION]2021.0|30.0.1|20200908[/VERSION]
With Material
     .Reset
     .Name "Silicon Nitride"
     .Folder ""
     .Rho "0"
     .ThermalType "Normal"
     .ThermalConductivity "0"
     .SpecificHeat "0", "J/K/kg"
     .DynamicViscosity "0"
     .Emissivity "0"
     .MetabolicRate "0"
     .VoxelConvection "0"
     .BloodFlow "0"
     .MechanicsType "Unused"
     .FrqType "all"
     .Type "Normal"
     .MaterialUnit "Frequency", "THz"
     .MaterialUnit "Geometry", "nm"
     .MaterialUnit "Time", "ps"
     .MaterialUnit "Temperature", "Kelvin"
     .Epsilon "4.2000000000000002"
     .Mu "1"
     .Sigma "0"
     .TanD "0.0"
     .TanDFreq "0.0"
     .TanDGiven "False"
     .TanDModel "ConstTanD"
     .SetConstTanDStrategyEps "AutomaticOrder"
     .ConstTanDModelOrderEps "1"
     .DjordjevicSarkarUpperFreqEps "0"
     .SetElParametricConductivity "False"
     .ReferenceCoordSystem "Global"
     .CoordSystemType "Cartesian"
     .SigmaM "0"
     .TanDM "0.0"
     .TanDMFreq "0.0"
     .TanDMGiven "False"
     .TanDMModel "ConstTanD"
     .SetConstTanDStrategyMu "AutomaticOrder"
     .ConstTanDModelOrderMu "1"
     .DjordjevicSarkarUpperFreqMu "0"
     .SetMagParametricConductivity "False"
     .DispModelEps  "None"
     .DispModelMu "None"
     .DispersiveFittingSchemeEps "Nth Order"
     .MaximalOrderNthModelFitEps "10"
     .ErrorLimitNthModelFitEps "0.1"
     .DispersiveFittingSchemeMu "Nth Order"
     .MaximalOrderNthModelFitMu "10"
     .ErrorLimitNthModelFitMu "0.1"
     .UseGeneralDispersionEps "False"
     .UseGeneralDispersionMu "False"
     .NonlinearMeasurementError "1e-1"
     .NLAnisotropy "False"
     .NLAStackingFactor "1"
     .NLADirectionX "1"
     .NLADirectionY "0"
     .NLADirectionZ "0"
     .Colour "0", "1", "1" 
     .Wireframe "False" 
     .Reflection "False" 
     .Allowoutline "True" 
     .Transparentoutline "False" 
     .Transparency "0" 
     .Create
End With

'@ change material and color: component1:Pillar to: Silicon Nitride

'[VERSION]2021.0|30.0.1|20200908[/VERSION]
Solid.ChangeMaterial "component1:Pillar", "Silicon Nitride" 
Solid.SetUseIndividualColor "component1:Pillar", 1
Solid.ChangeIndividualColor "component1:Pillar", "128", "128", "192"

'@ change material and color: component1:Substrate to: fused silica

'[VERSION]2021.0|30.0.1|20200908[/VERSION]
Solid.ChangeMaterial "component1:Substrate", "fused silica" 
Solid.SetUseIndividualColor "component1:Substrate", 1
Solid.ChangeIndividualColor "component1:Substrate", "0", "128", "64"

'@ change solver type

'[VERSION]2021.0|30.0.1|20200908[/VERSION]
ChangeSolverType "HF Frequency Domain"

'@ define boundaries

'[VERSION]2021.0|30.0.1|20200908[/VERSION]
With Boundary
     .Xmin "unit cell"
     .Xmax "unit cell"
     .Ymin "unit cell"
     .Ymax "unit cell"
     .Zmin "expanded open"
     .Zmax "expanded open"
     .Xsymmetry "none"
     .Ysymmetry "none"
     .Zsymmetry "none"
     .ApplyInAllDirections "False"
     .OpenAddSpaceFactor "0.5"
     .XPeriodicShift "0.0"
     .YPeriodicShift "0.0"
     .ZPeriodicShift "0.0"
     .PeriodicUseConstantAngles "False"
     .SetPeriodicBoundaryAngles "0.0", "0.0"
     .SetPeriodicBoundaryAnglesDirection "outward"
     .UnitCellFitToBoundingBox "True"
     .UnitCellDs1 "0.0"
     .UnitCellDs2 "0.0"
     .UnitCellAngle "90.0"
End With

'@ define frequency range

'[VERSION]2021.0|30.0.1|20200908[/VERSION]
Solver.FrequencyRange "lambda-0.001", "lambda+0.001"

'@ define units

'[VERSION]2021.0|30.0.1|20200908[/VERSION]
With Units 
     .Geometry "nm" 
     .Frequency "THz" 
     .Time "ps" 
     .TemperatureUnit "Kelvin" 
     .Voltage "V" 
     .Current "A" 
     .Resistance "Ohm" 
     .Conductance "Siemens" 
     .Capacitance "PikoF" 
     .Inductance "NanoH" 
     .SetResultUnit "frequency", "wavelength", "nm" 
End With

'@ define frequency range

'[VERSION]2021.0|30.0.1|20200908[/VERSION]
Solver.FrequencyRange "lambda-0.001", "lambda+0.001"

'@ change problem type

'[VERSION]2021.0|30.0.1|20200908[/VERSION]
ChangeProblemType "Optical"

'@ define frequency range

'[VERSION]2021.0|30.0.1|20200908[/VERSION]
Solver.WavelengthRange "lambda-0.001", "lambda+0.001"

'@ define units

'[VERSION]2021.0|30.0.1|20200908[/VERSION]
With Units 
     .Geometry "nm" 
     .Frequency "PHz" 
     .Time "ps" 
     .TemperatureUnit "Kelvin" 
     .Voltage "V" 
     .Current "A" 
     .Resistance "Ohm" 
     .Conductance "Siemens" 
     .Capacitance "PikoF" 
     .Inductance "NanoH" 
     .SetResultUnit "frequency", "wavelength", "nm" 
End With

'@ define frequency domain solver parameters

'[VERSION]2021.0|30.0.1|20200908[/VERSION]
Mesh.SetCreator "High Frequency" 

With FDSolver
     .Reset 
     .SetMethod "Tetrahedral", "General purpose" 
     .OrderTet "Second" 
     .OrderSrf "First" 
     .Stimulation "All+Floquet", "All" 
     .ResetExcitationList 
     .AutoNormImpedance "False" 
     .NormingImpedance "50" 
     .ModesOnly "False" 
     .ConsiderPortLossesTet "True" 
     .SetShieldAllPorts "False" 
     .AccuracyHex "1e-6" 
     .AccuracyTet "1e-4" 
     .AccuracySrf "1e-3" 
     .LimitIterations "False" 
     .MaxIterations "0" 
     .SetCalcBlockExcitationsInParallel "True", "True", "" 
     .StoreAllResults "False" 
     .StoreResultsInCache "False" 
     .UseHelmholtzEquation "True" 
     .LowFrequencyStabilization "True" 
     .Type "Auto" 
     .MeshAdaptionHex "False" 
     .MeshAdaptionTet "True" 
     .AcceleratedRestart "True" 
     .FreqDistAdaptMode "Distributed" 
     .NewIterativeSolver "True" 
     .TDCompatibleMaterials "False" 
     .ExtrudeOpenBC "False" 
     .SetOpenBCTypeHex "Default" 
     .SetOpenBCTypeTet "Default" 
     .AddMonitorSamples "True" 
     .CalcPowerLoss "True" 
     .CalcPowerLossPerComponent "False" 
     .StoreSolutionCoefficients "True" 
     .UseDoublePrecision "False" 
     .UseDoublePrecision_ML "True" 
     .MixedOrderSrf "False" 
     .MixedOrderTet "False" 
     .PreconditionerAccuracyIntEq "0.15" 
     .MLFMMAccuracy "Default" 
     .MinMLFMMBoxSize "0.3" 
     .UseCFIEForCPECIntEq "True" 
     .UseFastRCSSweepIntEq "false" 
     .UseSensitivityAnalysis "False" 
     .RemoveAllStopCriteria "Hex"
     .AddStopCriterion "All S-Parameters", "0.01", "2", "Hex", "True"
     .AddStopCriterion "Reflection S-Parameters", "0.01", "2", "Hex", "False"
     .AddStopCriterion "Transmission S-Parameters", "0.01", "2", "Hex", "False"
     .RemoveAllStopCriteria "Tet"
     .AddStopCriterion "All S-Parameters", "0.01", "2", "Tet", "True"
     .AddStopCriterion "Reflection S-Parameters", "0.01", "2", "Tet", "False"
     .AddStopCriterion "Transmission S-Parameters", "0.01", "2", "Tet", "False"
     .AddStopCriterion "All Probes", "0.05", "2", "Tet", "True"
     .RemoveAllStopCriteria "Srf"
     .AddStopCriterion "All S-Parameters", "0.01", "2", "Srf", "True"
     .AddStopCriterion "Reflection S-Parameters", "0.01", "2", "Srf", "False"
     .AddStopCriterion "Transmission S-Parameters", "0.01", "2", "Srf", "False"
     .SweepMinimumSamples "3" 
     .SetNumberOfResultDataSamples "1001" 
     .SetResultDataSamplingMode "Automatic" 
     .SweepWeightEvanescent "1.0" 
     .AccuracyROM "1e-4" 
     .AddSampleInterval "", "", "1", "Automatic", "True" 
     .AddSampleInterval "", "", "", "Automatic", "False" 
     .MPIParallelization "False"
     .UseDistributedComputing "False"
     .NetworkComputingStrategy "RunRemote"
     .NetworkComputingJobCount "3"
     .UseParallelization "True"
     .MaxCPUs "1024"
     .MaximumNumberOfCPUDevices "2"
End With

With IESolver
     .Reset 
     .UseFastFrequencySweep "True" 
     .UseIEGroundPlane "False" 
     .SetRealGroundMaterialName "" 
     .CalcFarFieldInRealGround "False" 
     .RealGroundModelType "Auto" 
     .PreconditionerType "Auto" 
     .ExtendThinWireModelByWireNubs "False" 
     .ExtraPreconditioning "False" 
End With

With IESolver
     .SetFMMFFCalcStopLevel "0" 
     .SetFMMFFCalcNumInterpPoints "6" 
     .UseFMMFarfieldCalc "True" 
     .SetCFIEAlpha "0.500000" 
     .LowFrequencyStabilization "False" 
     .LowFrequencyStabilizationML "True" 
     .Multilayer "False" 
     .SetiMoMACC_I "0.0001" 
     .SetiMoMACC_M "0.0001" 
     .DeembedExternalPorts "True" 
     .SetOpenBC_XY "True" 
     .OldRCSSweepDefintion "False" 
     .SetRCSOptimizationProperties "True", "100", "0.00001" 
     .SetAccuracySetting "Custom" 
     .CalculateSParaforFieldsources "True" 
     .ModeTrackingCMA "True" 
     .NumberOfModesCMA "3" 
     .StartFrequencyCMA "-1.0" 
     .SetAccuracySettingCMA "Default" 
     .FrequencySamplesCMA "0" 
     .SetMemSettingCMA "Auto" 
     .CalculateModalWeightingCoefficientsCMA "True" 
End With

'@ define Floquet port boundaries

'[VERSION]2021.0|30.0.1|20200908[/VERSION]
With FloquetPort
     .Reset
     .SetDialogTheta "0" 
     .SetDialogPhi "0" 
     .SetPolarizationIndependentOfScanAnglePhi "0.0", "False"  
     .SetSortCode "+beta/pw" 
     .SetCustomizedListFlag "False" 
     .Port "Zmin" 
     .SetNumberOfModesConsidered "6" 
     .SetDistanceToReferencePlane "0.0" 
     .SetUseCircularPolarization "False" 
     .Port "Zmax" 
     .SetNumberOfModesConsidered "6" 
     .SetDistanceToReferencePlane "1000" 
     .SetUseCircularPolarization "False" 
End With

'@ set mesh properties (Tetrahedral)

'[VERSION]2021.5|30.0.1|20210628[/VERSION]
With Mesh 
     .MeshType "Tetrahedral" 
     .SetCreator "High Frequency"
End With 
With MeshSettings 
     .SetMeshType "Tet" 
     .Set "Version", 1%
     'MAX CELL - WAVELENGTH REFINEMENT 
     .Set "StepsPerWaveNear", "4" 
     .Set "StepsPerWaveFar", "4" 
     .Set "PhaseErrorNear", "0.02" 
     .Set "PhaseErrorFar", "0.02" 
     .Set "CellsPerWavelengthPolicy", "automatic" 
     'MAX CELL - GEOMETRY REFINEMENT 
     .Set "StepsPerBoxNear", "7" 
     .Set "StepsPerBoxFar", "2" 
     .Set "ModelBoxDescrNear", "maxedge" 
     .Set "ModelBoxDescrFar", "maxedge" 
     'MIN CELL 
     .Set "UseRatioLimit", "0" 
     .Set "RatioLimit", "100" 
     .Set "MinStep", "0" 
     'MESHING METHOD 
     .SetMeshType "Unstr" 
     .Set "Method", "0" 
End With 
With MeshSettings 
     .SetMeshType "Tet" 
     .Set "CurvatureOrder", "1" 
     .Set "CurvatureOrderPolicy", "automatic" 
     .Set "CurvRefinementControl", "NormalTolerance" 
     .Set "NormalTolerance", "22.5" 
     .Set "SrfMeshGradation", "1.5" 
     .Set "SrfMeshOptimization", "1" 
End With 
With MeshSettings 
     .SetMeshType "Unstr" 
     .Set "UseMaterials",  "1" 
     .Set "MoveMesh", "0" 
End With 
With MeshSettings 
     .SetMeshType "All" 
     .Set "AutomaticEdgeRefinement",  "0" 
End With 
With MeshSettings 
     .SetMeshType "Tet" 
     .Set "UseAnisoCurveRefinement", "1" 
     .Set "UseSameSrfAndVolMeshGradation", "1" 
     .Set "VolMeshGradation", "1.5" 
     .Set "VolMeshOptimization", "1" 
End With 
With MeshSettings 
     .SetMeshType "Unstr" 
     .Set "SmallFeatureSize", "0" 
     .Set "CoincidenceTolerance", "1e-06" 
     .Set "SelfIntersectionCheck", "1" 
     .Set "OptimizeForPlanarStructures", "0" 
End With 
With Mesh 
     .SetParallelMesherMode "Tet", "maximum" 
     .SetMaxParallelMesherThreads "Tet", "1" 
End With

'@ define monitors (using linear samples)

'[VERSION]2021.5|30.0.1|20210628[/VERSION]
With Monitor
          .Reset 
          .Domain "Wavelength"
          .FieldType "Efield"
          .Dimension "Volume" 
          .UseSubvolume "False" 
          .Coordinates "Structure" 
          .SetSubvolume "-205", "205", "-205", "205", "-1000", "695" 
          .SetSubvolumeOffset "0.0", "0.0", "0.0", "0.0", "0.0", "0.0" 
          .SetSubvolumeInflateWithOffset "False" 
          .CreateUsingLinearSamples "560.999", "561.001", "11"
End With

'@ define frequency domain solver parameters

'[VERSION]2021.5|30.0.1|20210628[/VERSION]
Mesh.SetCreator "High Frequency" 

With FDSolver
     .Reset 
     .SetMethod "Tetrahedral", "General purpose" 
     .OrderTet "Second" 
     .OrderSrf "First" 
     .Stimulation "All+Floquet", "All" 
     .ResetExcitationList 
     .AutoNormImpedance "False" 
     .NormingImpedance "50" 
     .ModesOnly "False" 
     .ConsiderPortLossesTet "True" 
     .SetShieldAllPorts "False" 
     .AccuracyHex "1e-6" 
     .AccuracyTet "1e-4" 
     .AccuracySrf "1e-3" 
     .LimitIterations "False" 
     .MaxIterations "0" 
     .SetCalcBlockExcitationsInParallel "True", "True", "" 
     .StoreAllResults "False" 
     .StoreResultsInCache "False" 
     .UseHelmholtzEquation "True" 
     .LowFrequencyStabilization "True" 
     .Type "Auto" 
     .MeshAdaptionHex "False" 
     .MeshAdaptionTet "True" 
     .AcceleratedRestart "True" 
     .FreqDistAdaptMode "Distributed" 
     .NewIterativeSolver "True" 
     .TDCompatibleMaterials "False" 
     .ExtrudeOpenBC "False" 
     .SetOpenBCTypeHex "Default" 
     .SetOpenBCTypeTet "Default" 
     .AddMonitorSamples "True" 
     .CalcPowerLoss "True" 
     .CalcPowerLossPerComponent "False" 
     .StoreSolutionCoefficients "True" 
     .UseDoublePrecision "False" 
     .UseDoublePrecision_ML "True" 
     .MixedOrderSrf "False" 
     .MixedOrderTet "False" 
     .PreconditionerAccuracyIntEq "0.15" 
     .MLFMMAccuracy "Default" 
     .MinMLFMMBoxSize "0.3" 
     .UseCFIEForCPECIntEq "True" 
     .UseFastRCSSweepIntEq "false" 
     .UseSensitivityAnalysis "False" 
     .RemoveAllStopCriteria "Hex"
     .AddStopCriterion "All S-Parameters", "0.01", "2", "Hex", "True"
     .AddStopCriterion "Reflection S-Parameters", "0.01", "2", "Hex", "False"
     .AddStopCriterion "Transmission S-Parameters", "0.01", "2", "Hex", "False"
     .RemoveAllStopCriteria "Tet"
     .AddStopCriterion "All S-Parameters", "0.01", "2", "Tet", "True"
     .AddStopCriterion "Reflection S-Parameters", "0.01", "2", "Tet", "False"
     .AddStopCriterion "Transmission S-Parameters", "0.01", "2", "Tet", "False"
     .AddStopCriterion "All Probes", "0.05", "2", "Tet", "True"
     .RemoveAllStopCriteria "Srf"
     .AddStopCriterion "All S-Parameters", "0.01", "2", "Srf", "True"
     .AddStopCriterion "Reflection S-Parameters", "0.01", "2", "Srf", "False"
     .AddStopCriterion "Transmission S-Parameters", "0.01", "2", "Srf", "False"
     .SweepMinimumSamples "3" 
     .SetNumberOfResultDataSamples "1001" 
     .SetResultDataSamplingMode "Automatic" 
     .SweepWeightEvanescent "1.0" 
     .AccuracyROM "1e-4" 
     .AddSampleInterval "", "", "1", "Automatic", "True" 
     .AddSampleInterval "", "", "", "Automatic", "False" 
     .MPIParallelization "False"
     .UseDistributedComputing "False"
     .NetworkComputingStrategy "RunRemote"
     .NetworkComputingJobCount "3"
     .UseParallelization "True"
     .MaxCPUs "1024"
     .MaximumNumberOfCPUDevices "2"
End With

With IESolver
     .Reset 
     .UseFastFrequencySweep "True" 
     .UseIEGroundPlane "False" 
     .SetRealGroundMaterialName "" 
     .CalcFarFieldInRealGround "False" 
     .RealGroundModelType "Auto" 
     .PreconditionerType "Auto" 
     .ExtendThinWireModelByWireNubs "False" 
     .ExtraPreconditioning "False" 
End With

With IESolver
     .SetFMMFFCalcStopLevel "0" 
     .SetFMMFFCalcNumInterpPoints "6" 
     .UseFMMFarfieldCalc "True" 
     .SetCFIEAlpha "0.500000" 
     .LowFrequencyStabilization "False" 
     .LowFrequencyStabilizationML "True" 
     .Multilayer "False" 
     .SetiMoMACC_I "0.0001" 
     .SetiMoMACC_M "0.0001" 
     .DeembedExternalPorts "True" 
     .SetOpenBC_XY "True" 
     .OldRCSSweepDefintion "False" 
     .SetRCSOptimizationProperties "True", "100", "0.00001" 
     .SetAccuracySetting "Custom" 
     .CalculateSParaforFieldsources "True" 
     .ModeTrackingCMA "True" 
     .NumberOfModesCMA "3" 
     .StartFrequencyCMA "-1.0" 
     .SetAccuracySettingCMA "Default" 
     .FrequencySamplesCMA "0" 
     .SetMemSettingCMA "Auto" 
     .CalculateModalWeightingCoefficientsCMA "True" 
End With

'@ change solver type

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
ChangeSolverType "HF Frequency Domain"

'@ paste structure data: 1

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With SAT 
     .Reset 
     .FileName "*1.cby" 
     .SubProjectScaleFactor "1e-09" 
     .ImportToActiveCoordinateSystem "True" 
     .ScaleToUnit "True" 
     .Curves "False" 
     .Read 
End With

'@ delete component: component1_1

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Component.Delete "component1_1"

'@ transform: translate component1:Substrate

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Transform 
     .Reset 
     .Name "component1:Substrate" 
     .Vector "410", "0", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "5" 
     .MultipleSelection "False" 
     .Destination "" 
     .Material "" 
     .Transform "Shape", "Translate" 
End With

'@ transform: translate component1:Substrate

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Transform 
     .Reset 
     .Name "component1:Substrate" 
     .Vector "-410", "0", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "5" 
     .MultipleSelection "False" 
     .Destination "" 
     .Material "" 
     .Transform "Shape", "Translate" 
End With

'@ new component: component2

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Component.New "component2"

'@ new component: component3

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Component.New "component3"

'@ new component: component4

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Component.New "component4"

'@ new component: component5

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Component.New "component5"

'@ new component: component6

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Component.New "component6"

'@ new component: component7

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Component.New "component7"

'@ new component: component8

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Component.New "component8"

'@ new component: component9

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Component.New "component9"

'@ new component: component10

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Component.New "component10"

'@ new component: component11

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Component.New "component11"

'@ change component: component1:Substrate_1 to: component2:Substrate_1

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.ChangeComponent "component1:Substrate_1", "component2"

'@ change component: component1:Substrate_2 to: component3:Substrate_2

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.ChangeComponent "component1:Substrate_2", "component3"

'@ change component: component1:Substrate_4 to: component4:Substrate_4

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.ChangeComponent "component1:Substrate_4", "component4"

'@ change component: component2:Substrate_1 to: component1:Substrate_1

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.ChangeComponent "component2:Substrate_1", "component1"

'@ new component: component0

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Component.New "component0"

'@ delete component: component11

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Component.Delete "component11"

'@ change component: component1:Pillar to: component0:Pillar

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.ChangeComponent "component1:Pillar", "component0"

'@ change component: component1:Substrate to: component0:Substrate

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.ChangeComponent "component1:Substrate", "component0"

'@ change component: component1:Substrate_3 to: component3:Substrate_3

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.ChangeComponent "component1:Substrate_3", "component3"

'@ change component: component3:Substrate_2 to: component2:Substrate_2

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.ChangeComponent "component3:Substrate_2", "component2"

'@ change component: component1:Substrate_5 to: component5:Substrate_5

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.ChangeComponent "component1:Substrate_5", "component5"

'@ change component: component1:Substrate_6 to: component6:Substrate_6

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.ChangeComponent "component1:Substrate_6", "component6"

'@ change component: component1:Substrate_7 to: component7:Substrate_7

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.ChangeComponent "component1:Substrate_7", "component7"

'@ change component: component1:Substrate_8 to: component8:Substrate_8

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.ChangeComponent "component1:Substrate_8", "component8"

'@ change component: component1:Substrate_9 to: component9:Substrate_9

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.ChangeComponent "component1:Substrate_9", "component9"

'@ change component: component1:Substrate_10 to: component10:Substrate_10

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.ChangeComponent "component1:Substrate_10", "component10"

'@ clear picks

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.ClearAllPicks

'@ pick face

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickFaceFromId "component1:Substrate_1", "1"

'@ define cylinder: component1:solid1

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Cylinder 
     .Reset 
     .Name "solid1" 
     .Component "component1" 
     .Material "Silicon Nitride" 
     .OuterRadius "r1" 
     .InnerRadius "0.0" 
     .Axis "z" 
     .Zrange "0", "h1" 
     .Xcenter "410" 
     .Ycenter "0" 
     .Segments "0" 
     .Create 
End With

'@ clear picks

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.ClearAllPicks

'@ rename block: component1:solid1 to: component1:Pillar_1

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Rename "component1:solid1", "Pillar_1"

'@ clear picks

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.ClearAllPicks

'@ pick face

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickFaceFromId "component2:Substrate_2", "1"

'@ define cylinder: component1:Pillar_2

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Cylinder 
     .Reset 
     .Name "Pillar_2" 
     .Component "component1" 
     .Material "Silicon Nitride" 
     .OuterRadius "r2" 
     .InnerRadius "0.0" 
     .Axis "z" 
     .Zrange "0", "h1" 
     .Xcenter "820" 
     .Ycenter "0" 
     .Segments "0" 
     .Create 
End With

'@ clear picks

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.ClearAllPicks

'@ pick face

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickFaceFromId "component3:Substrate_3", "1"

'@ define cylinder: component1:Pillar_3

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Cylinder 
     .Reset 
     .Name "Pillar_3" 
     .Component "component1" 
     .Material "Silicon Nitride" 
     .OuterRadius "r3" 
     .InnerRadius "0.0" 
     .Axis "z" 
     .Zrange "0", "h1" 
     .Xcenter "1230" 
     .Ycenter "0" 
     .Segments "0" 
     .Create 
End With

'@ change component: component1:Pillar_2 to: component2:Pillar_2

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.ChangeComponent "component1:Pillar_2", "component2"

'@ change component: component1:Pillar_3 to: component3:Pillar_3

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.ChangeComponent "component1:Pillar_3", "component3"

'@ clear picks

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.ClearAllPicks

'@ pick face

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickFaceFromId "component4:Substrate_4", "1"

'@ define cylinder: component4:Pillar_4

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Cylinder 
     .Reset 
     .Name "Pillar_4" 
     .Component "component4" 
     .Material "Silicon Nitride" 
     .OuterRadius "r4" 
     .InnerRadius "0.0" 
     .Axis "z" 
     .Zrange "0", "h1" 
     .Xcenter "1640" 
     .Ycenter "0" 
     .Segments "0" 
     .Create 
End With

'@ clear picks

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.ClearAllPicks

'@ pick face

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickFaceFromId "component5:Substrate_5", "1"

'@ define cylinder: component5:Pillar_5

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Cylinder 
     .Reset 
     .Name "Pillar_5" 
     .Component "component5" 
     .Material "fused silica" 
     .OuterRadius "r5" 
     .InnerRadius "0.0" 
     .Axis "z" 
     .Zrange "0", "h1" 
     .Xcenter "2050" 
     .Ycenter "0" 
     .Segments "0" 
     .Create 
End With

'@ clear picks

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.ClearAllPicks

'@ pick face

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickFaceFromId "component6:Substrate_6", "1"

'@ define cylinder: component6:Pillar_6

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Cylinder 
     .Reset 
     .Name "Pillar_6" 
     .Component "component6" 
     .Material "Silicon Nitride" 
     .OuterRadius "r1" 
     .InnerRadius "0.0" 
     .Axis "z" 
     .Zrange "0", "h1" 
     .Xcenter "-410" 
     .Ycenter "0" 
     .Segments "0" 
     .Create 
End With

'@ clear picks

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.ClearAllPicks

'@ pick face

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickFaceFromId "component7:Substrate_7", "1"

'@ define cylinder: component7:Pillar_7

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Cylinder 
     .Reset 
     .Name "Pillar_7" 
     .Component "component7" 
     .Material "Silicon Nitride" 
     .OuterRadius "r2" 
     .InnerRadius "0.0" 
     .Axis "z" 
     .Zrange "0", "h1" 
     .Xcenter "-820" 
     .Ycenter "0" 
     .Segments "0" 
     .Create 
End With

'@ clear picks

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.ClearAllPicks

'@ pick face

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickFaceFromId "component8:Substrate_8", "1"

'@ define cylinder: component8:Pillar_8

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Cylinder 
     .Reset 
     .Name "Pillar_8" 
     .Component "component8" 
     .Material "Silicon Nitride" 
     .OuterRadius "r3" 
     .InnerRadius "0.0" 
     .Axis "z" 
     .Zrange "0", "h1" 
     .Xcenter "-1230" 
     .Ycenter "0" 
     .Segments "0" 
     .Create 
End With

'@ clear picks

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.ClearAllPicks

'@ delete shape: component5:Pillar_5

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Delete "component5:Pillar_5"

'@ pick face

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickFaceFromId "component5:Substrate_5", "1"

'@ define cylinder: component5:Pillar_5

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Cylinder 
     .Reset 
     .Name "Pillar_5" 
     .Component "component5" 
     .Material "Silicon Nitride" 
     .OuterRadius "r5" 
     .InnerRadius "0.0" 
     .Axis "z" 
     .Zrange "0", "h1" 
     .Xcenter "2050" 
     .Ycenter "0" 
     .Segments "0" 
     .Create 
End With

'@ clear picks

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.ClearAllPicks

'@ pick face

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickFaceFromId "component9:Substrate_9", "1"

'@ define cylinder: component9:Pillar_9

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Cylinder 
     .Reset 
     .Name "Pillar_9" 
     .Component "component9" 
     .Material "Silicon Nitride" 
     .OuterRadius "r4" 
     .InnerRadius "0.0" 
     .Axis "z" 
     .Zrange "0", "h1" 
     .Xcenter "-1640" 
     .Ycenter "0" 
     .Segments "0" 
     .Create 
End With

'@ clear picks

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.ClearAllPicks

'@ pick face

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickFaceFromId "component10:Substrate_10", "1"

'@ define cylinder: component10:Pillar_10

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Cylinder 
     .Reset 
     .Name "Pillar_10" 
     .Component "component10" 
     .Material "Silicon Nitride" 
     .OuterRadius "r5" 
     .InnerRadius "0.0" 
     .Axis "z" 
     .Zrange "0", "h1" 
     .Xcenter "-2050" 
     .Ycenter "0" 
     .Segments "0" 
     .Create 
End With

'@ clear picks

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.ClearAllPicks

'@ pick face

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickFaceFromId "component0:Substrate", "3"

'@ pick face

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickFaceFromId "component6:Substrate_6", "3"

'@ pick face

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickFaceFromId "component7:Substrate_7", "3"

'@ pick face

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickFaceFromId "component8:Substrate_8", "3"

'@ pick face

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickFaceFromId "component9:Substrate_9", "3"

'@ pick face

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickFaceFromId "component10:Substrate_10", "3"

'@ new component: component11

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Component.New "component11"

'@ define brick: component11:solid1

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Brick
     .Reset 
     .Name "solid1" 
     .Component "component11" 
     .Material "Silicon Nitride" 
     .Xrange "-2255", "205" 
     .Yrange "-205", "-205" 
     .Zrange "-1000", "0" 
     .Create
End With

'@ clear picks

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.ClearAllPicks

'@ transform: translate component11

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Transform 
     .Reset 
     .Name "component11" 
     .Vector "0", "205", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Transform "Shape", "Translate" 
End With

'@ delete shape: component11:solid1

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Delete "component11:solid1"

'@ delete shapes

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Delete "component1:Pillar_1" 
Solid.Delete "component1:Substrate_1" 
Solid.Delete "component2:Pillar_2" 
Solid.Delete "component2:Substrate_2" 
Solid.Delete "component3:Pillar_3" 
Solid.Delete "component3:Substrate_3" 
Solid.Delete "component4:Pillar_4" 
Solid.Delete "component4:Substrate_4" 
Solid.Delete "component5:Pillar_5" 
Solid.Delete "component5:Substrate_5"

'@ pick face

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickFaceFromId "component10:Substrate_10", "3"

'@ pick face

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickFaceFromId "component9:Substrate_9", "3"

'@ pick face

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickFaceFromId "component8:Substrate_8", "3"

'@ delete shapes

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Component.Delete "component1" 
Component.Delete "component2" 
Component.Delete "component3" 
Component.Delete "component4" 
Component.Delete "component5"

'@ transform: translate component6

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Transform 
     .Reset 
     .Name "component6" 
     .Vector "820", "0", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Destination "" 
     .Material "" 
     .Transform "Shape", "Translate" 
End With

'@ transform: translate component7

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Transform 
     .Reset 
     .Name "component7" 
     .Vector "1640", "0", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Destination "" 
     .Material "" 
     .Transform "Shape", "Translate" 
End With

'@ transform: translate component8

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Transform 
     .Reset 
     .Name "component8" 
     .Vector "2460", "0", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Destination "" 
     .Material "" 
     .Transform "Shape", "Translate" 
End With

'@ transform: translate component9

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Transform 
     .Reset 
     .Name "component9" 
     .Vector "3280", "0", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Destination "" 
     .Material "" 
     .Transform "Shape", "Translate" 
End With

'@ transform: translate component10

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Transform 
     .Reset 
     .Name "component10" 
     .Vector "4100", "0", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Destination "" 
     .Material "" 
     .Transform "Shape", "Translate" 
End With

'@ switch bounding box

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Plot.DrawBox "True"

'@ define boundaries

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Boundary
     .Xmin "unit cell"
     .Xmax "unit cell"
     .Ymin "unit cell"
     .Ymax "unit cell"
     .Zmin "expanded open"
     .Zmax "expanded open"
     .Xsymmetry "none"
     .Ysymmetry "none"
     .Zsymmetry "none"
     .ApplyInAllDirections "False"
     .OpenAddSpaceFactor "0.5"
     .XPeriodicShift "0.0"
     .YPeriodicShift "0.0"
     .ZPeriodicShift "0.0"
     .PeriodicUseConstantAngles "False"
     .SetPeriodicBoundaryAngles "0.0", "0.0"
     .SetPeriodicBoundaryAnglesDirection "outward"
     .UnitCellFitToBoundingBox "True"
     .UnitCellDs1 "100"
     .UnitCellDs2 "100"
     .UnitCellAngle "90.0"
End With

