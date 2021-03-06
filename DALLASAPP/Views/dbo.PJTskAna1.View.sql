USE [DALLASAPP]
GO
/****** Object:  View [dbo].[PJTskAna1]    Script Date: 12/21/2015 13:44:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[PJTskAna1] AS

   SELECT 
      
      Project               = h.project,
      Task                  = h.pjt_entity,
      FiscYear              = h.fsyear_num,
      PeriodPost            = (h.fsyear_num + v.Mon),
      FiscPeriod            = v.Mon,
      MTDHrs                =  CAST(sum(CASE WHEN A.Acct_type = 'EX' and a.id5_sw = 'L' THEN
                               CASE
                               v.Mon
                                 WHEN '01' THEN h.Units_01 
                                 WHEN '02' THEN h.Units_02 
                                 WHEN '03' THEN h.Units_03 
                                 WHEN '04' THEN h.Units_04 
                                 WHEN '05' THEN h.Units_05 
                                 WHEN '06' THEN h.Units_06 
                                 WHEN '07' THEN h.Units_07 
                                 WHEN '08' THEN h.Units_08 
                                 WHEN '09' THEN h.Units_09 
                                 WHEN '10' THEN h.Units_10 
                                 WHEN '11' THEN h.Units_11 
                                 WHEN '12' THEN h.Units_12 
                                 WHEN '13' THEN h.Units_13 
	                      ELSE 0 END
                              ELSE 0 END) AS DEC(28,2)),
     MTDRev                =  CAST(sum(CASE WHEN A.Acct_type = 'RV' and a.id5_sw <> 'A' THEN
                               CASE
                               v.Mon
                                 WHEN '01' THEN h.Amount_01 
                                 WHEN '02' THEN h.Amount_02 
                                 WHEN '03' THEN h.Amount_03 
                                 WHEN '04' THEN h.Amount_04 
                                 WHEN '05' THEN h.Amount_05 
                                 WHEN '06' THEN h.Amount_06 
                                 WHEN '07' THEN h.Amount_07 
                                 WHEN '08' THEN h.Amount_08 
                                 WHEN '09' THEN h.Amount_09 
                                 WHEN '10' THEN h.Amount_10 
                                 WHEN '11' THEN h.Amount_11 
                                 WHEN '12' THEN h.Amount_12 
                                 WHEN '13' THEN h.Amount_13 
	                      ELSE 0 END
                              ELSE 0 END) AS DEC(28,2)),
      MTDRevAdj             =  CAST(sum(CASE WHEN A.Acct_type = 'RV' and a.id5_sw = 'A' THEN
                               CASE
                               v.Mon
                                 WHEN '01' THEN h.Amount_01 
                                 WHEN '02' THEN h.Amount_02 
                                 WHEN '03' THEN h.Amount_03 
                                 WHEN '04' THEN h.Amount_04 
                                 WHEN '05' THEN h.Amount_05 
                                 WHEN '06' THEN h.Amount_06 
                                 WHEN '07' THEN h.Amount_07 
                                 WHEN '08' THEN h.Amount_08 
                                 WHEN '09' THEN h.Amount_09 
                                 WHEN '10' THEN h.Amount_10 
                                 WHEN '11' THEN h.Amount_11 
                                 WHEN '12' THEN h.Amount_12 
                                 WHEN '13' THEN h.Amount_13 
	                      ELSE 0 END
                              ELSE 0 END) AS DEC(28,2)),
      MTDLabor              =  CAST(sum(CASE WHEN A.Acct_type = 'EX' and a.id5_sw = 'L' THEN
                               CASE
                               v.Mon
                                 WHEN '01' THEN h.Amount_01 
                                 WHEN '02' THEN h.Amount_02 
                                 WHEN '03' THEN h.Amount_03 
                                 WHEN '04' THEN h.Amount_04 
                                 WHEN '05' THEN h.Amount_05 
                                 WHEN '06' THEN h.Amount_06 
                                 WHEN '07' THEN h.Amount_07 
                                 WHEN '08' THEN h.Amount_08 
                                 WHEN '09' THEN h.Amount_09 
                                 WHEN '10' THEN h.Amount_10 
                                 WHEN '11' THEN h.Amount_11 
                                 WHEN '12' THEN h.Amount_12 
                                 WHEN '13' THEN h.Amount_13 
	                      ELSE 0 END
                              ELSE 0 END) AS DEC(28,2)),
      MTDExp                =  CAST(sum(CASE WHEN A.Acct_type = 'EX' and a.id5_sw <> 'L' THEN
                               CASE
                               v.Mon
                                 WHEN '01' THEN h.Amount_01 
                                 WHEN '02' THEN h.Amount_02 
                                 WHEN '03' THEN h.Amount_03 
                                 WHEN '04' THEN h.Amount_04 
                                 WHEN '05' THEN h.Amount_05 
                                 WHEN '06' THEN h.Amount_06 
                                 WHEN '07' THEN h.Amount_07 
                                 WHEN '08' THEN h.Amount_08 
                                 WHEN '09' THEN h.Amount_09 
                                 WHEN '10' THEN h.Amount_10 
                                 WHEN '11' THEN h.Amount_11 
                                 WHEN '12' THEN h.Amount_12 
                                 WHEN '13' THEN h.Amount_13 
	                      ELSE 0 END
                              ELSE 0 END) AS DEC(28,2)),
      YTDHrs                =  CAST(sum(CASE WHEN A.Acct_type = 'EX' and a.id5_sw = 'L' THEN
                               CASE
                               v.Mon
                                 WHEN '01' THEN h.Units_01 
                                 WHEN '02' THEN h.Units_01 + h.Units_02 
                                 WHEN '03' THEN h.Units_01 + h.Units_02 + h.Units_03 
                                 WHEN '04' THEN h.Units_01 + h.Units_02 + h.Units_03 + h.Units_04 
                                 WHEN '05' THEN h.Units_01 + h.Units_02 + h.Units_03 + h.Units_04 + h.Units_05 
                                 WHEN '06' THEN h.Units_01 + h.Units_02 + h.Units_03 + h.Units_04 + h.Units_05 + h.Units_06 
                                 WHEN '07' THEN h.Units_01 + h.Units_02 + h.Units_03 + h.Units_04 + h.Units_05 + h.Units_06 + h.Units_07 
                                 WHEN '08' THEN h.Units_01 + h.Units_02 + h.Units_03 + h.Units_04 + h.Units_05 + h.Units_06 + h.Units_07 + h.Units_08 
                                 WHEN '09' THEN h.Units_01 + h.Units_02 + h.Units_03 + h.Units_04 + h.Units_05 + h.Units_06 + h.Units_07 + h.Units_08 + h.Units_09 
                                 WHEN '10' THEN h.Units_01 + h.Units_02 + h.Units_03 + h.Units_04 + h.Units_05 + h.Units_06 + h.Units_07 + h.Units_08 + h.Units_09 + h.Units_10 
                                 WHEN '11' THEN h.Units_01 + h.Units_02 + h.Units_03 + h.Units_04 + h.Units_05 + h.Units_06 + h.Units_07 + h.Units_08 + h.Units_09 + h.Units_10 + h.Units_11 
                                 WHEN '12' THEN h.Units_01 + h.Units_02 + h.Units_03 + h.Units_04 + h.Units_05 + h.Units_06 + h.Units_07 + h.Units_08 + h.Units_09 + h.Units_10 + h.Units_11 + h.Units_12 
                                 WHEN '13' THEN h.Units_01 + h.Units_02 + h.Units_03 + h.Units_04 + h.Units_05 + h.Units_06 + h.Units_07 + h.Units_08 + h.Units_09 + h.Units_10 + h.Units_11 + h.Units_12 + h.Units_13 
	                      ELSE 0 END
                              ELSE 0 END) AS DEC(28,2)),
      YTDRev                =  CAST(sum(CASE WHEN A.Acct_type = 'RV' and a.id5_sw <> 'A' THEN
                               CASE
                               v.Mon
                                 WHEN '01' THEN h.Amount_01  
                                 WHEN '02' THEN h.Amount_01 + h.Amount_02  
                                 WHEN '03' THEN h.Amount_01 + h.Amount_02 + h.Amount_03  
                                 WHEN '04' THEN h.Amount_01 + h.Amount_02 + h.Amount_03 + h.Amount_04  
                                 WHEN '05' THEN h.Amount_01 + h.Amount_02 + h.Amount_03 + h.Amount_04 + h.Amount_05  
                                 WHEN '06' THEN h.Amount_01 + h.Amount_02 + h.Amount_03 + h.Amount_04 + h.Amount_05 + h.Amount_06  
                                 WHEN '07' THEN h.Amount_01 + h.Amount_02 + h.Amount_03 + h.Amount_04 + h.Amount_05 + h.Amount_06 + h.Amount_07  
                                 WHEN '08' THEN h.Amount_01 + h.Amount_02 + h.Amount_03 + h.Amount_04 + h.Amount_05 + h.Amount_06 + h.Amount_07 + h.Amount_08  
                                 WHEN '09' THEN h.Amount_01 + h.Amount_02 + h.Amount_03 + h.Amount_04 + h.Amount_05 + h.Amount_06 + h.Amount_07 + h.Amount_08 + h.Amount_09  
                                 WHEN '10' THEN h.Amount_01 + h.Amount_02 + h.Amount_03 + h.Amount_04 + h.Amount_05 + h.Amount_06 + h.Amount_07 + h.Amount_08 + h.Amount_09 + h.Amount_10  
                                 WHEN '11' THEN h.Amount_01 + h.Amount_02 + h.Amount_03 + h.Amount_04 + h.Amount_05 + h.Amount_06 + h.Amount_07 + h.Amount_08 + h.Amount_09 + h.Amount_10 + h.Amount_11  
                                 WHEN '12' THEN h.Amount_01 + h.Amount_02 + h.Amount_03 + h.Amount_04 + h.Amount_05 + h.Amount_06 + h.Amount_07 + h.Amount_08 + h.Amount_09 + h.Amount_10 + h.Amount_11 + h.Amount_12  
                                 WHEN '13' THEN h.Amount_01 + h.Amount_02 + h.Amount_03 + h.Amount_04 + h.Amount_05 + h.Amount_06 + h.Amount_07 + h.Amount_08 + h.Amount_09 + h.Amount_10 + h.Amount_11 + h.Amount_12 + h.Amount_13 
	                      ELSE 0 END
                              ELSE 0 END) AS DEC(28,2)),
      YTDRevAdj             =  CAST(sum(CASE WHEN A.Acct_type = 'RV' and a.id5_sw = 'A'  THEN
                               CASE
                               v.Mon
                                 WHEN '01' THEN h.Amount_01  
                                 WHEN '02' THEN h.Amount_01 + h.Amount_02  
                                 WHEN '03' THEN h.Amount_01 + h.Amount_02 + h.Amount_03  
                                 WHEN '04' THEN h.Amount_01 + h.Amount_02 + h.Amount_03 + h.Amount_04  
                                 WHEN '05' THEN h.Amount_01 + h.Amount_02 + h.Amount_03 + h.Amount_04 + h.Amount_05  
                                 WHEN '06' THEN h.Amount_01 + h.Amount_02 + h.Amount_03 + h.Amount_04 + h.Amount_05 + h.Amount_06  
                                 WHEN '07' THEN h.Amount_01 + h.Amount_02 + h.Amount_03 + h.Amount_04 + h.Amount_05 + h.Amount_06 + h.Amount_07  
                                 WHEN '08' THEN h.Amount_01 + h.Amount_02 + h.Amount_03 + h.Amount_04 + h.Amount_05 + h.Amount_06 + h.Amount_07 + h.Amount_08  
                                 WHEN '09' THEN h.Amount_01 + h.Amount_02 + h.Amount_03 + h.Amount_04 + h.Amount_05 + h.Amount_06 + h.Amount_07 + h.Amount_08 + h.Amount_09  
                                 WHEN '10' THEN h.Amount_01 + h.Amount_02 + h.Amount_03 + h.Amount_04 + h.Amount_05 + h.Amount_06 + h.Amount_07 + h.Amount_08 + h.Amount_09 + h.Amount_10  
                                 WHEN '11' THEN h.Amount_01 + h.Amount_02 + h.Amount_03 + h.Amount_04 + h.Amount_05 + h.Amount_06 + h.Amount_07 + h.Amount_08 + h.Amount_09 + h.Amount_10 + h.Amount_11  
                                 WHEN '12' THEN h.Amount_01 + h.Amount_02 + h.Amount_03 + h.Amount_04 + h.Amount_05 + h.Amount_06 + h.Amount_07 + h.Amount_08 + h.Amount_09 + h.Amount_10 + h.Amount_11 + h.Amount_12  
                                 WHEN '13' THEN h.Amount_01 + h.Amount_02 + h.Amount_03 + h.Amount_04 + h.Amount_05 + h.Amount_06 + h.Amount_07 + h.Amount_08 + h.Amount_09 + h.Amount_10 + h.Amount_11 + h.Amount_12 + h.Amount_13 
	                      ELSE 0 END
                              ELSE 0 END) AS DEC(28,2)),
      YTDLabor              =  CAST(sum(CASE WHEN A.Acct_type = 'EX' and a.id5_sw = 'L'  THEN
                               CASE
                               v.Mon
                                 WHEN '01' THEN h.Amount_01  
                                 WHEN '02' THEN h.Amount_01 + h.Amount_02  
                                 WHEN '03' THEN h.Amount_01 + h.Amount_02 + h.Amount_03  
                                 WHEN '04' THEN h.Amount_01 + h.Amount_02 + h.Amount_03 + h.Amount_04  
                                 WHEN '05' THEN h.Amount_01 + h.Amount_02 + h.Amount_03 + h.Amount_04 + h.Amount_05  
                                 WHEN '06' THEN h.Amount_01 + h.Amount_02 + h.Amount_03 + h.Amount_04 + h.Amount_05 + h.Amount_06  
                                 WHEN '07' THEN h.Amount_01 + h.Amount_02 + h.Amount_03 + h.Amount_04 + h.Amount_05 + h.Amount_06 + h.Amount_07  
                                 WHEN '08' THEN h.Amount_01 + h.Amount_02 + h.Amount_03 + h.Amount_04 + h.Amount_05 + h.Amount_06 + h.Amount_07 + h.Amount_08  
                                 WHEN '09' THEN h.Amount_01 + h.Amount_02 + h.Amount_03 + h.Amount_04 + h.Amount_05 + h.Amount_06 + h.Amount_07 + h.Amount_08 + h.Amount_09  
                                 WHEN '10' THEN h.Amount_01 + h.Amount_02 + h.Amount_03 + h.Amount_04 + h.Amount_05 + h.Amount_06 + h.Amount_07 + h.Amount_08 + h.Amount_09 + h.Amount_10  
                                 WHEN '11' THEN h.Amount_01 + h.Amount_02 + h.Amount_03 + h.Amount_04 + h.Amount_05 + h.Amount_06 + h.Amount_07 + h.Amount_08 + h.Amount_09 + h.Amount_10 + h.Amount_11  
                                 WHEN '12' THEN h.Amount_01 + h.Amount_02 + h.Amount_03 + h.Amount_04 + h.Amount_05 + h.Amount_06 + h.Amount_07 + h.Amount_08 + h.Amount_09 + h.Amount_10 + h.Amount_11 + h.Amount_12  
                                 WHEN '13' THEN h.Amount_01 + h.Amount_02 + h.Amount_03 + h.Amount_04 + h.Amount_05 + h.Amount_06 + h.Amount_07 + h.Amount_08 + h.Amount_09 + h.Amount_10 + h.Amount_11 + h.Amount_12 + h.Amount_13 
	                      ELSE 0 END
                              ELSE 0 END) AS DEC(28,2)),
      YTDExp                  =  CAST(sum(CASE WHEN A.Acct_type = 'EX' and a.id5_sw <> 'L'  THEN
                               CASE
                               v.Mon
                                 WHEN '01' THEN h.Amount_01  
                                 WHEN '02' THEN h.Amount_01 + h.Amount_02  
                                 WHEN '03' THEN h.Amount_01 + h.Amount_02 + h.Amount_03  
                                 WHEN '04' THEN h.Amount_01 + h.Amount_02 + h.Amount_03 + h.Amount_04  
                                 WHEN '05' THEN h.Amount_01 + h.Amount_02 + h.Amount_03 + h.Amount_04 + h.Amount_05  
                                 WHEN '06' THEN h.Amount_01 + h.Amount_02 + h.Amount_03 + h.Amount_04 + h.Amount_05 + h.Amount_06  
                                 WHEN '07' THEN h.Amount_01 + h.Amount_02 + h.Amount_03 + h.Amount_04 + h.Amount_05 + h.Amount_06 + h.Amount_07  
                                 WHEN '08' THEN h.Amount_01 + h.Amount_02 + h.Amount_03 + h.Amount_04 + h.Amount_05 + h.Amount_06 + h.Amount_07 + h.Amount_08  
                                 WHEN '09' THEN h.Amount_01 + h.Amount_02 + h.Amount_03 + h.Amount_04 + h.Amount_05 + h.Amount_06 + h.Amount_07 + h.Amount_08 + h.Amount_09  
                                 WHEN '10' THEN h.Amount_01 + h.Amount_02 + h.Amount_03 + h.Amount_04 + h.Amount_05 + h.Amount_06 + h.Amount_07 + h.Amount_08 + h.Amount_09 + h.Amount_10  
                                 WHEN '11' THEN h.Amount_01 + h.Amount_02 + h.Amount_03 + h.Amount_04 + h.Amount_05 + h.Amount_06 + h.Amount_07 + h.Amount_08 + h.Amount_09 + h.Amount_10 + h.Amount_11  
                                 WHEN '12' THEN h.Amount_01 + h.Amount_02 + h.Amount_03 + h.Amount_04 + h.Amount_05 + h.Amount_06 + h.Amount_07 + h.Amount_08 + h.Amount_09 + h.Amount_10 + h.Amount_11 + h.Amount_12  
                                 WHEN '13' THEN h.Amount_01 + h.Amount_02 + h.Amount_03 + h.Amount_04 + h.Amount_05 + h.Amount_06 + h.Amount_07 + h.Amount_08 + h.Amount_09 + h.Amount_10 + h.Amount_11 + h.Amount_12 + h.Amount_13 
	                      ELSE 0 END
                              ELSE 0 END) AS DEC(28,2)),
      PTDHrs                =  CAST(sum(CASE WHEN A.Acct_type = 'EX' and a.id5_sw = 'L'  THEN
                               CASE
                               v.Mon
                                 WHEN '01' THEN h.units_bf + h.Units_01 
                                 WHEN '02' THEN h.units_bf + h.Units_01 + h.Units_02 
                                 WHEN '03' THEN h.units_bf + h.Units_01 + h.Units_02 + h.Units_03 
                                 WHEN '04' THEN h.units_bf + h.Units_01 + h.Units_02 + h.Units_03 + h.Units_04 
                                 WHEN '05' THEN h.units_bf + h.Units_01 + h.Units_02 + h.Units_03 + h.Units_04 + h.Units_05 
                                 WHEN '06' THEN h.units_bf + h.Units_01 + h.Units_02 + h.Units_03 + h.Units_04 + h.Units_05 + h.Units_06 
                                 WHEN '07' THEN h.units_bf + h.Units_01 + h.Units_02 + h.Units_03 + h.Units_04 + h.Units_05 + h.Units_06 + h.Units_07 
                                 WHEN '08' THEN h.units_bf + h.Units_01 + h.Units_02 + h.Units_03 + h.Units_04 + h.Units_05 + h.Units_06 + h.Units_07 + h.Units_08 
                                 WHEN '09' THEN h.units_bf + h.Units_01 + h.Units_02 + h.Units_03 + h.Units_04 + h.Units_05 + h.Units_06 + h.Units_07 + h.Units_08 + h.Units_09 
                                 WHEN '10' THEN h.units_bf + h.Units_01 + h.Units_02 + h.Units_03 + h.Units_04 + h.Units_05 + h.Units_06 + h.Units_07 + h.Units_08 + h.Units_09 + h.Units_10 
                                 WHEN '11' THEN h.units_bf + h.Units_01 + h.Units_02 + h.Units_03 + h.Units_04 + h.Units_05 + h.Units_06 + h.Units_07 + h.Units_08 + h.Units_09 + h.Units_10 + h.Units_11 
                                 WHEN '12' THEN h.units_bf + h.Units_01 + h.Units_02 + h.Units_03 + h.Units_04 + h.Units_05 + h.Units_06 + h.Units_07 + h.Units_08 + h.Units_09 + h.Units_10 + h.Units_11 + h.Units_12 
                                 WHEN '13' THEN h.units_bf + h.Units_01 + h.Units_02 + h.Units_03 + h.Units_04 + h.Units_05 + h.Units_06 + h.Units_07 + h.Units_08 + h.Units_09 + h.Units_10 + h.Units_11 + h.Units_12 + h.Units_13 
	                      ELSE 0 END
                              ELSE 0 END) AS DEC(28,2)),
      PTDRev                =  CAST(sum(CASE WHEN A.Acct_type = 'RV' and a.id5_sw <> 'A'  THEN
                               CASE
                               v.Mon
                                 WHEN '01' THEN h.Amount_bf + h.Amount_01  
                                 WHEN '02' THEN h.Amount_bf + h.Amount_01 + h.Amount_02  
                                 WHEN '03' THEN h.Amount_bf + h.Amount_01 + h.Amount_02 + h.Amount_03  
                                 WHEN '04' THEN h.Amount_bf + h.Amount_01 + h.Amount_02 + h.Amount_03 + h.Amount_04  
                                 WHEN '05' THEN h.Amount_bf + h.Amount_01 + h.Amount_02 + h.Amount_03 + h.Amount_04 + h.Amount_05  
                                 WHEN '06' THEN h.Amount_bf + h.Amount_01 + h.Amount_02 + h.Amount_03 + h.Amount_04 + h.Amount_05 + h.Amount_06  
                                 WHEN '07' THEN h.Amount_bf + h.Amount_01 + h.Amount_02 + h.Amount_03 + h.Amount_04 + h.Amount_05 + h.Amount_06 + h.Amount_07  
                                 WHEN '08' THEN h.Amount_bf + h.Amount_01 + h.Amount_02 + h.Amount_03 + h.Amount_04 + h.Amount_05 + h.Amount_06 + h.Amount_07 + h.Amount_08  
                                 WHEN '09' THEN h.Amount_bf + h.Amount_01 + h.Amount_02 + h.Amount_03 + h.Amount_04 + h.Amount_05 + h.Amount_06 + h.Amount_07 + h.Amount_08 + h.Amount_09  
                                 WHEN '10' THEN h.Amount_bf + h.Amount_01 + h.Amount_02 + h.Amount_03 + h.Amount_04 + h.Amount_05 + h.Amount_06 + h.Amount_07 + h.Amount_08 + h.Amount_09 + h.Amount_10  
                                 WHEN '11' THEN h.Amount_bf + h.Amount_01 + h.Amount_02 + h.Amount_03 + h.Amount_04 + h.Amount_05 + h.Amount_06 + h.Amount_07 + h.Amount_08 + h.Amount_09 + h.Amount_10 + h.Amount_11  
                                 WHEN '12' THEN h.Amount_bf + h.Amount_01 + h.Amount_02 + h.Amount_03 + h.Amount_04 + h.Amount_05 + h.Amount_06 + h.Amount_07 + h.Amount_08 + h.Amount_09 + h.Amount_10 + h.Amount_11 + h.Amount_12  
                                 WHEN '13' THEN h.Amount_bf + h.Amount_01 + h.Amount_02 + h.Amount_03 + h.Amount_04 + h.Amount_05 + h.Amount_06 + h.Amount_07 + h.Amount_08 + h.Amount_09 + h.Amount_10 + h.Amount_11 + h.Amount_12 + h.Amount_13 
	                      ELSE 0 END
                              ELSE 0 END) AS DEC(28,2)),
      PTDRevAdj             =  CAST(sum(CASE WHEN A.Acct_type = 'RV' and a.id5_sw = 'A'  THEN
                               CASE
                               v.Mon
                                 WHEN '01' THEN h.Amount_bf + h.Amount_01  
                                 WHEN '02' THEN h.Amount_bf + h.Amount_01 + h.Amount_02  
                                 WHEN '03' THEN h.Amount_bf + h.Amount_01 + h.Amount_02 + h.Amount_03  
                                 WHEN '04' THEN h.Amount_bf + h.Amount_01 + h.Amount_02 + h.Amount_03 + h.Amount_04  
                                 WHEN '05' THEN h.Amount_bf + h.Amount_01 + h.Amount_02 + h.Amount_03 + h.Amount_04 + h.Amount_05  
                                 WHEN '06' THEN h.Amount_bf + h.Amount_01 + h.Amount_02 + h.Amount_03 + h.Amount_04 + h.Amount_05 + h.Amount_06  
                                 WHEN '07' THEN h.Amount_bf + h.Amount_01 + h.Amount_02 + h.Amount_03 + h.Amount_04 + h.Amount_05 + h.Amount_06 + h.Amount_07  
                                 WHEN '08' THEN h.Amount_bf + h.Amount_01 + h.Amount_02 + h.Amount_03 + h.Amount_04 + h.Amount_05 + h.Amount_06 + h.Amount_07 + h.Amount_08  
                                 WHEN '09' THEN h.Amount_bf + h.Amount_01 + h.Amount_02 + h.Amount_03 + h.Amount_04 + h.Amount_05 + h.Amount_06 + h.Amount_07 + h.Amount_08 + h.Amount_09  
                                 WHEN '10' THEN h.Amount_bf + h.Amount_01 + h.Amount_02 + h.Amount_03 + h.Amount_04 + h.Amount_05 + h.Amount_06 + h.Amount_07 + h.Amount_08 + h.Amount_09 + h.Amount_10  
                                 WHEN '11' THEN h.Amount_bf + h.Amount_01 + h.Amount_02 + h.Amount_03 + h.Amount_04 + h.Amount_05 + h.Amount_06 + h.Amount_07 + h.Amount_08 + h.Amount_09 + h.Amount_10 + h.Amount_11  
                                 WHEN '12' THEN h.Amount_bf + h.Amount_01 + h.Amount_02 + h.Amount_03 + h.Amount_04 + h.Amount_05 + h.Amount_06 + h.Amount_07 + h.Amount_08 + h.Amount_09 + h.Amount_10 + h.Amount_11 + h.Amount_12  
                                 WHEN '13' THEN h.Amount_bf + h.Amount_01 + h.Amount_02 + h.Amount_03 + h.Amount_04 + h.Amount_05 + h.Amount_06 + h.Amount_07 + h.Amount_08 + h.Amount_09 + h.Amount_10 + h.Amount_11 + h.Amount_12 + h.Amount_13 

	                      ELSE 0 END
                              ELSE 0 END) AS DEC(28,2)),
      PTDLabor              =  CAST(sum(CASE WHEN A.Acct_type = 'EX' and a.id5_sw = 'L'  THEN
                               CASE
                               v.Mon
                                 WHEN '01' THEN h.Amount_bf + h.Amount_01  
                                 WHEN '02' THEN h.Amount_bf + h.Amount_01 + h.Amount_02  
                                 WHEN '03' THEN h.Amount_bf + h.Amount_01 + h.Amount_02 + h.Amount_03  
                                 WHEN '04' THEN h.Amount_bf + h.Amount_01 + h.Amount_02 + h.Amount_03 + h.Amount_04  
                                 WHEN '05' THEN h.Amount_bf + h.Amount_01 + h.Amount_02 + h.Amount_03 + h.Amount_04 + h.Amount_05  
                                 WHEN '06' THEN h.Amount_bf + h.Amount_01 + h.Amount_02 + h.Amount_03 + h.Amount_04 + h.Amount_05 + h.Amount_06  
                                 WHEN '07' THEN h.Amount_bf + h.Amount_01 + h.Amount_02 + h.Amount_03 + h.Amount_04 + h.Amount_05 + h.Amount_06 + h.Amount_07  
                                 WHEN '08' THEN h.Amount_bf + h.Amount_01 + h.Amount_02 + h.Amount_03 + h.Amount_04 + h.Amount_05 + h.Amount_06 + h.Amount_07 + h.Amount_08  
                                 WHEN '09' THEN h.Amount_bf + h.Amount_01 + h.Amount_02 + h.Amount_03 + h.Amount_04 + h.Amount_05 + h.Amount_06 + h.Amount_07 + h.Amount_08 + h.Amount_09  
                                 WHEN '10' THEN h.Amount_bf + h.Amount_01 + h.Amount_02 + h.Amount_03 + h.Amount_04 + h.Amount_05 + h.Amount_06 + h.Amount_07 + h.Amount_08 + h.Amount_09 + h.Amount_10  
                                 WHEN '11' THEN h.Amount_bf + h.Amount_01 + h.Amount_02 + h.Amount_03 + h.Amount_04 + h.Amount_05 + h.Amount_06 + h.Amount_07 + h.Amount_08 + h.Amount_09 + h.Amount_10 + h.Amount_11  
                                 WHEN '12' THEN h.Amount_bf + h.Amount_01 + h.Amount_02 + h.Amount_03 + h.Amount_04 + h.Amount_05 + h.Amount_06 + h.Amount_07 + h.Amount_08 + h.Amount_09 + h.Amount_10 + h.Amount_11 + h.Amount_12  
                                 WHEN '13' THEN h.Amount_bf + h.Amount_01 + h.Amount_02 + h.Amount_03 + h.Amount_04 + h.Amount_05 + h.Amount_06 + h.Amount_07 + h.Amount_08 + h.Amount_09 + h.Amount_10 + h.Amount_11 + h.Amount_12 + h.Amount_13 

	                      ELSE 0 END
                              ELSE 0 END) AS DEC(28,2)),
      PTDExp                =  CAST(sum(CASE WHEN A.Acct_type = 'EX' and a.id5_sw <> 'L'  THEN
                               CASE
                               v.Mon
                                 WHEN '01' THEN h.Amount_bf + h.Amount_01  
                                 WHEN '02' THEN h.Amount_bf + h.Amount_01 + h.Amount_02  
                                 WHEN '03' THEN h.Amount_bf + h.Amount_01 + h.Amount_02 + h.Amount_03  
                                 WHEN '04' THEN h.Amount_bf + h.Amount_01 + h.Amount_02 + h.Amount_03 + h.Amount_04  
                                 WHEN '05' THEN h.Amount_bf + h.Amount_01 + h.Amount_02 + h.Amount_03 + h.Amount_04 + h.Amount_05  
                                 WHEN '06' THEN h.Amount_bf + h.Amount_01 + h.Amount_02 + h.Amount_03 + h.Amount_04 + h.Amount_05 + h.Amount_06  
                                 WHEN '07' THEN h.Amount_bf + h.Amount_01 + h.Amount_02 + h.Amount_03 + h.Amount_04 + h.Amount_05 + h.Amount_06 + h.Amount_07  
                                 WHEN '08' THEN h.Amount_bf + h.Amount_01 + h.Amount_02 + h.Amount_03 + h.Amount_04 + h.Amount_05 + h.Amount_06 + h.Amount_07 + h.Amount_08  
                                 WHEN '09' THEN h.Amount_bf + h.Amount_01 + h.Amount_02 + h.Amount_03 + h.Amount_04 + h.Amount_05 + h.Amount_06 + h.Amount_07 + h.Amount_08 + h.Amount_09  
                                 WHEN '10' THEN h.Amount_bf + h.Amount_01 + h.Amount_02 + h.Amount_03 + h.Amount_04 + h.Amount_05 + h.Amount_06 + h.Amount_07 + h.Amount_08 + h.Amount_09 + h.Amount_10  
                                 WHEN '11' THEN h.Amount_bf + h.Amount_01 + h.Amount_02 + h.Amount_03 + h.Amount_04 + h.Amount_05 + h.Amount_06 + h.Amount_07 + h.Amount_08 + h.Amount_09 + h.Amount_10 + h.Amount_11  
                                 WHEN '12' THEN h.Amount_bf + h.Amount_01 + h.Amount_02 + h.Amount_03 + h.Amount_04 + h.Amount_05 + h.Amount_06 + h.Amount_07 + h.Amount_08 + h.Amount_09 + h.Amount_10 + h.Amount_11 + h.Amount_12  
                                 WHEN '13' THEN h.Amount_bf + h.Amount_01 + h.Amount_02 + h.Amount_03 + h.Amount_04 + h.Amount_05 + h.Amount_06 + h.Amount_07 + h.Amount_08 + h.Amount_09 + h.Amount_10 + h.Amount_11 + h.Amount_12 + h.Amount_13 

	                      ELSE 0 END
                              ELSE 0 END) AS DEC(28,2))

FROM PJActSum h INNER JOIN PJAcct            a (NOLOCK)  ON h.Acct = a.Acct 
                CROSS JOIN vr_ShareMonthList v
                CROSS JOIN GLSetup           s (NOLOCK)
--Only return records for the number of periods configured in GLSetup.
WHERE (CONVERT(INT, v.Mon) <= s.NbrPer)
GROUP BY project, h.pjt_entity, fsyear_num, (h.fsyear_num + v.Mon), v.Mon
GO
