USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ShipVia_Desc]    Script Date: 12/21/2015 15:43:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ShipVia_Desc                                             ******/
Create Proc [dbo].[ShipVia_Desc] @Parm1 VarChar(30) as
	Select Descr from ShipVia Where ShipViaID = @Parm1
GO
