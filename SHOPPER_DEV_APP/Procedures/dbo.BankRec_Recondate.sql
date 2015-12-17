USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[BankRec_Recondate]    Script Date: 12/16/2015 15:55:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.BankRec_Recondate    Script Date: 4/7/98 12:49:20 PM ******/
Create Proc [dbo].[BankRec_Recondate] @parm1 varchar ( 10), @parm2 varchar ( 10), @parm3 varchar ( 24) as
Select * from BankRec
where cpnyid like @parm1
and Bankacct like @parm2
and Banksub like @parm3
Order by BankAcct DESC, Banksub DESC, ReconDate desc
GO
