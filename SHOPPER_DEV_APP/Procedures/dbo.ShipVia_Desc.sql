USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ShipVia_Desc]    Script Date: 12/16/2015 15:55:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ShipVia_Desc                                             ******/
Create Proc [dbo].[ShipVia_Desc] @Parm1 VarChar(30) as
	Select Descr from ShipVia Where ShipViaID = @Parm1
GO
