USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARTran_Bat_Drcr_Type]    Script Date: 12/16/2015 15:55:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ARTran_Bat_Drcr_Type    Script Date: 4/7/98 12:49:19 PM ******/
Create Procedure [dbo].[ARTran_Bat_Drcr_Type] @parm1 varchar ( 10), @parm2 varchar ( 10), @parm3 varchar ( 24), @parm4 varchar ( 10) as
select * from ARTran where
BatNbr = @parm1
and Acct  = @parm2
and Sub = @parm3
and DrCr = 'D'
and TranType = 'PA'
and cpnyid = @parm4
GO
