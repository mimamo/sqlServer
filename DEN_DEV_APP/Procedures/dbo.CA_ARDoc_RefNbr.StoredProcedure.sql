USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[CA_ARDoc_RefNbr]    Script Date: 12/21/2015 14:05:58 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create Proc [dbo].[CA_ARDoc_RefNbr] @parm1 varchar ( 10), @parm2 varchar(10), @parm3 varchar ( 24), @parm4 varchar ( 10) as
Select * from ardoc
Where cpnyid = @parm1
and bankacct = @parm2
and banksub = @parm3
and refnbr = @parm4
GO
