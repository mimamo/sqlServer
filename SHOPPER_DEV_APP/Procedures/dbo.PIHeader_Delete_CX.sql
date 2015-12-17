USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PIHeader_Delete_CX]    Script Date: 12/16/2015 15:55:25 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.PIHeader_Delete_CX    Script Date: 4/17/98 10:58:19 AM ******/
Create Proc [dbo].[PIHeader_Delete_CX] @parm1 varchar (6) as
    Delete From PIHeader
	Where (PIHeader.Status = 'X' OR PIHeader.Status = 'C')
	And  PIHeader.PerClosed <= @Parm1
GO
