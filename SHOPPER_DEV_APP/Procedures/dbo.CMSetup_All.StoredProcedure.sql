USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[CMSetup_All]    Script Date: 12/21/2015 14:34:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.CMSetup_All    Script Date: 4/7/98 12:43:41 PM ******/
Create Proc [dbo].[CMSetup_All] as
    Select * from CMSetup order by SetupID
GO
