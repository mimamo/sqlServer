USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[WOSetup_All]    Script Date: 12/21/2015 15:43:13 ******/
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
