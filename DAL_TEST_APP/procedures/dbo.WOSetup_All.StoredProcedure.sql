USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOSetup_All]    Script Date: 12/21/2015 13:57:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOSetup_All]
AS
   SELECT      *
   FROM        WOSetup
   ORDER BY    SetUpID
GO
