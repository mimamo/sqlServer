USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PIDetail_Delete_CX]    Script Date: 12/21/2015 14:06:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.PIDetail_Delete_CX    Script Date: 4/17/98 10:58:19 AM ******/
Create Proc [dbo].[PIDetail_Delete_CX] @parm1 varchar (6) as
    Delete From Pidetail
	From Piheader Where PIHeader.PIID = PiDetail.PIID
	AND (PIHeader.Status = 'X' OR PIHeader.Status = 'C')
	And  PIHeader.PerClosed <= @Parm1
GO
