USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[POAddress_Delete]    Script Date: 12/21/2015 16:13:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.POAddress_Delete    Script Date: 4/7/98 12:19:55 PM ******/
Create Procedure [dbo].[POAddress_Delete] @parm1 varchar ( 255) as
Delete from POAddress where POAddress.Vendid = @parm1
GO
