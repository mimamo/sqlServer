USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Delete_POACosts_PONbr]    Script Date: 12/21/2015 13:35:38 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Delete_POACosts_PONbr    Script Date: 4/16/98 7:50:25 PM ******/
Create Procedure [dbo].[Delete_POACosts_PONbr] @parm1 varchar ( 10) As
Delete from POACosts Where PONbr = @parm1
GO
