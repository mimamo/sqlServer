USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[GLSetup_All]    Script Date: 12/16/2015 15:55:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.GLSetup_All    Script Date: 4/7/98 12:38:58 PM ******/
Create Proc [dbo].[GLSetup_All] as
Select * from GLSetup
GO
