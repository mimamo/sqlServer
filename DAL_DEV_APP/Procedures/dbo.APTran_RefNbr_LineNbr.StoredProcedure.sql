USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[APTran_RefNbr_LineNbr]    Script Date: 12/21/2015 13:35:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.APTran_RefNbr_LineNbr    Script Date: 4/7/98 12:19:55 PM ******/
Create Procedure [dbo].[APTran_RefNbr_LineNbr] @parm1 varchar ( 10), @parm2beg smallint, @parm2end smallint as
Select * from APTran where RefNbr = @parm1
and LineNbr between @parm2beg and @parm2end
Order by BatNbr, LineNbr
GO
