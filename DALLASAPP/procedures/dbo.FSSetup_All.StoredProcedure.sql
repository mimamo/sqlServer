USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[FSSetup_All]    Script Date: 12/21/2015 13:44:55 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.FSSetup_All    Script Date: 4/7/98 12:45:04 PM ******/
Create Proc [dbo].[FSSetup_All] as
     Select * from FSSetup
GO
