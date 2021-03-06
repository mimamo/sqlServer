USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[AP1099Tran_RefNbr_]    Script Date: 12/21/2015 16:13:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.AP1099Tran_RefNbr_    Script Date: 4/7/98 12:19:54 PM ******/
Create Procedure [dbo].[AP1099Tran_RefNbr_] @parm1 varchar ( 10), @parm2beg smallint, @parm2end smallint as
Select * from APTran where RefNbr = @parm1
and (((TranType = 'AC' or TranType = 'VO') and DrCr = 'D')
or (TranType = 'AD' and DrCr = 'C'))
and BoxNbr <> ''
and LineNbr between @parm2beg and @parm2end
Order by RefNbr, TranType, LineNbr
GO
