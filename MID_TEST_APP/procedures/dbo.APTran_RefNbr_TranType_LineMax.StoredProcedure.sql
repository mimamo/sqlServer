USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[APTran_RefNbr_TranType_LineMax]    Script Date: 12/21/2015 15:49:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.APTran_RefNbr_TranType_LineMax    Script Date: 4/7/98 12:19:55 PM ******/
Create Procedure [dbo].[APTran_RefNbr_TranType_LineMax]
@parm1 varchar ( 10), @parm2beg smallint, @parm2end smallint as
Select MAX(LineNbr) from APTran where RefNbr = @parm1
and (((TranType = 'AC' or TranType = 'VO') and DrCr = 'D')
or (TranType = 'AD' and DrCr = 'C'))
and LineNbr between @parm2beg and @parm2end
GO
