USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[Vend_OneTime_Delete]    Script Date: 12/21/2015 16:07:22 ******/
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
