USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[APTranDT_RefNbr_LineNbr]    Script Date: 12/21/2015 16:00:48 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.APTranDT_RefNbr_LineNbr    Script Date: 4/7/98 12:19:55 PM ******/
Create Procedure [dbo].[APTranDT_RefNbr_LineNbr] @parm1 varchar ( 10), @parm2 varchar (05), @parm3beg smallint, @parm3end smallint As
	Select * from APTranDT where
		RefNbr = @parm1 And
		APLineRef = @parm2 And
	        LineNbr between @parm3beg and @parm3end
	Order By RefNbr, APLineRef, LineNbr
GO
