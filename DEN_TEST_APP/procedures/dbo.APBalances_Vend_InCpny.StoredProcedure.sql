USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[APBalances_Vend_InCpny]    Script Date: 12/21/2015 15:36:47 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[APBalances_Vend_InCpny] @parm1 varchar ( 15),  @parm2 varchar(47), @parm3 varchar(7), @parm4 varchar(1)
WITH EXECUTE AS '07718158D19D4f5f9D23B55DBF5DF1'
as
Select * from AP_Balances
where VendID = @parm1
and Cpnyid in

(select Cpnyid
 from vs_share_usercpny
   where userid = @parm2
   and screennumber = @parm3+"00"
   and seclevel >= @parm4)
GO
