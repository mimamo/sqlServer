USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Vend_OneTime_Delete]    Script Date: 12/16/2015 15:55:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Vend_OneTime_Delete    Script Date: 4/7/98 12:19:55 PM ******/
Create Procedure [dbo].[Vend_OneTime_Delete] @parm1 varchar(15) as
Delete from Vendor where
Vendor.Vendid = @parm1 and
Vendor.Status = 'O'
GO
