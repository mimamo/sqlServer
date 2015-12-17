USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[APTran_RefNbr_TranType_LineNbr]    Script Date: 12/16/2015 15:55:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.APTran_RefNbr_TranType_LineNbr    Script Date: 4/7/98 12:19:55 PM ******/
Create Procedure [dbo].[APTran_RefNbr_TranType_LineNbr]
@parm1 varchar ( 10), @parm2beg smallint, @parm2end smallint as
Select * from APTran where RefNbr = @parm1
and (((TranType = 'AC' or TranType = 'VO' or TranType = 'PV' OR TranType = 'PP' OR TranType = 'VM' OR LineType = 'P') and DrCr = 'D')
or ((TranType = 'AD' OR LineType = 'P') and DrCr = 'C'))
and LineNbr between @parm2beg and @parm2end
Order by LineNbr
GO
