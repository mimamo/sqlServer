USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[POAddress_VendId]    Script Date: 12/16/2015 15:55:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.POAddress_VendId    Script Date: 4/7/98 12:19:55 PM ******/
Create Procedure [dbo].[POAddress_VendId] @parm1 varchar ( 15), @parm2 varchar ( 10) as
Select * from POAddress where VendId = @parm1
and OrdFromId like @parm2
Order by VendId, OrdFromId
GO
