USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[POSetup_All]    Script Date: 12/21/2015 16:13:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.POSetup_All    Script Date: 4/16/98 7:50:26 PM ******/
Create Proc [dbo].[POSetup_All] as
    Select * from POSetup
GO
