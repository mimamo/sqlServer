USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[CA_ARDoc_RefNbr_Date]    Script Date: 12/21/2015 16:00:51 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create Proc [dbo].[CA_ARDoc_RefNbr_Date] @parm1 varchar ( 10), @parm2 varchar(10), @parm3 varchar ( 24), @parm4 varchar ( 10), @parm5 smalldatetime as
Select * from ardoc
Where cpnyid = @parm1
and bankacct = @parm2
and banksub = @parm3
and refnbr = @parm4
and DocDate = @parm5
GO
