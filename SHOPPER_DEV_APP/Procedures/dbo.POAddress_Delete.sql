USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[POAddress_Delete]    Script Date: 12/16/2015 15:55:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.POAddress_Delete    Script Date: 4/7/98 12:19:55 PM ******/
Create Procedure [dbo].[POAddress_Delete] @parm1 varchar ( 255) as
Delete from POAddress where POAddress.Vendid = @parm1
GO
