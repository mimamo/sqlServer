USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[GLSetup_All]    Script Date: 12/21/2015 16:13:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.GLSetup_All    Script Date: 4/7/98 12:38:58 PM ******/
Create Proc [dbo].[GLSetup_All] as
Select * from GLSetup
GO
