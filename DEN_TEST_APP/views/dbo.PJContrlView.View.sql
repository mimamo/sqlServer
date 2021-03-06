USE [DEN_TEST_APP]
GO
/****** Object:  View [dbo].[PJContrlView]    Script Date: 12/21/2015 14:10:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[PJContrlView] AS

SELECT control_code FieldType, control_type ControlType,
       CAST(LEFT(control_data,1)  AS smallint) NbrofSegments,
       SUBSTRING(control_data,2,16) Caption,
       SUBSTRING(control_data,18,1) Deliminiter,

       SUBSTRING(control_data,19,12) SegCaption00,
       CAST (CASE WHEN SUBSTRING(control_data,31,2) = ' ' 
                  THEN '0' 
                  ELSE CASE WHEN SUBSTRING(control_data,31,1) = '0'
                            THEN SUBSTRING(control_data,32,1)
                            ELSE SUBSTRING(control_data,31,2) 
                            END
                  END AS smallint)  SegLength00,
       SUBSTRING(control_data,33,1) SegMask00,
       SUBSTRING(control_data,34,4) SegCodeType00,
       SUBSTRING(control_data,38,20)SegValue00,

       SUBSTRING(control_data,58,12) SegCaption01,
       CAST (CASE WHEN SUBSTRING(control_data,70,2) = ' ' 
                  THEN '0' 
                  ELSE CASE WHEN SUBSTRING(control_data,70,1) = '0'
                            THEN SUBSTRING(control_data,71,1)
                            ELSE SUBSTRING(control_data,70,2) 
                            END 
                  END AS SmallInt) SegLength01,
       SUBSTRING(control_data,72,1) SegMask01,
       SUBSTRING(control_data,73,4) SegCodeType01,
       SUBSTRING(control_data,77,20) SegValue01,

       SUBSTRING(control_data,97,12) SegCaption02,
       CAST (CASE WHEN SUBSTRING(control_data,109,2) = ' ' 
                  THEN '0' 
                  ELSE CASE WHEN SUBSTRING(control_data,109,1) = '0'
                            THEN SUBSTRING(control_data,110,1)
                            ELSE SUBSTRING(control_data,109,2) 
                            END  
                  END AS smallint) SegLength02,
       SUBSTRING(control_data,111,1) SegMask02,
       SUBSTRING(control_data,112,4) SegCodeType02,
       SUBSTRING(control_data,116,20) SegValue02,

       SUBSTRING(control_data,136,12) SegCaption03,
       CAST (CASE WHEN SUBSTRING(control_data,148,2) = ' ' 
                  THEN '0' 
                  ELSE CASE WHEN SUBSTRING(control_data,148,1) = '0'
                            THEN SUBSTRING(control_data,149,1)
                            ELSE SUBSTRING(control_data,148,2) 
                            END 
                  END AS smallint) SegLength03,
       SUBSTRING(control_data,150,1) SegMask03,
       SUBSTRING(control_data,151,4) SegCodeType03,
       SUBSTRING(control_data,155,20) SegValue03,

       SUBSTRING(control_data,175,12) SegCaption04,
       CAST (CASE WHEN SUBSTRING(control_data,187,2) = ' ' 
                  THEN '0'
                  ELSE CASE WHEN SUBSTRING(control_data,187,1) = '0'
                            THEN SUBSTRING(control_data,188,1)
                            ELSE SUBSTRING(control_data,187,2) 
                            END 
                  END AS smallint) SegLength04,
       SUBSTRING(control_data,189,1) SegMask04,
       SUBSTRING(control_data,190,4) SegCodeType04,
       SUBSTRING(control_data,194,20) SegValue04,

       SUBSTRING(control_data,214,12) SegCaption05,
       CAST (CASE WHEN SUBSTRING(control_data,226,2) = ' '
                  THEN '0'
                  ELSE CASE WHEN SUBSTRING(control_data,226,1) = '0'
                            THEN SUBSTRING(control_data,227,1)
                            ELSE SUBSTRING(control_data,226,2) 
                            END 
                  END AS smallint) SegLength05,   
       SUBSTRING(control_data,228,1) SegMask05,
       SUBSTRING(control_data,229,4) SegCodeType05,
       SUBSTRING(control_data,233,20) SegValue05,
       MaxFieldLen = 0
from PJCONTRL
where control_type = 'FK'
GO
