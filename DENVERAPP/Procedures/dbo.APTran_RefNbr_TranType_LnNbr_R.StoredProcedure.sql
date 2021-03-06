USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[APTran_RefNbr_TranType_LnNbr_R]    Script Date: 12/21/2015 15:42:42 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.APTran_RefNbr_TranType_LnNbr_R    Script Date: 4/7/98 12:19:55 PM ******/
Create Procedure [dbo].[APTran_RefNbr_TranType_LnNbr_R]
@parm1 varchar ( 10), @parm2beg smallint, @parm2end smallint as
Select * from APTran where RefNbr = @parm1
and TranType = 'RC'
and LineNbr between @parm2beg and @parm2end
Order by RefNbr, TranType, LineNbr
GO
