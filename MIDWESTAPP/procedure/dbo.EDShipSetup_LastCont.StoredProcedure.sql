USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDShipSetup_LastCont]    Script Date: 12/21/2015 15:55:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[EDShipSetup_LastCont] As Select LastSerContainer From EDShipSetup Order BY SetupId
GO
