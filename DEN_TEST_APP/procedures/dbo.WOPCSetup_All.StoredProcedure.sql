USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOPCSetup_All]    Script Date: 12/21/2015 15:37:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[WOPCSetup_All]

AS
   SELECT      *
   FROM        PCSetUp
   ORDER BY    SetUpID
GO
