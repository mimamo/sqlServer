USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[CMSetup_All]    Script Date: 12/21/2015 13:44:47 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.CMSetup_All    Script Date: 4/7/98 12:43:41 PM ******/
Create Proc [dbo].[CMSetup_All] as
    Select * from CMSetup order by SetupID
GO
