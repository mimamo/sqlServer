USE [SHOPPERAPP]
GO
/****** Object:  View [dbo].[vr_ShareMonthList]    Script Date: 12/21/2015 16:12:45 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[vr_ShareMonthList] AS

   SELECT Mon = "01"
   UNION
   SELECT Mon = "02"
   UNION
   SELECT Mon = "03"
   UNION
   SELECT Mon = "04"
   UNION
   SELECT Mon = "05"
   UNION
   SELECT Mon = "06"
   UNION
   SELECT Mon = "07"
   UNION
   SELECT Mon = "08"
   UNION
   SELECT Mon = "09"
   UNION
   SELECT Mon = "10"
   UNION
   SELECT Mon = "11"
   UNION
   SELECT Mon = "12"
   UNION
   SELECT Mon = "13"
GO
