USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[BankTran_ImportRef]    Script Date: 12/16/2015 15:55:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.BankTran_ImportRef    Script Date: 4/7/98 12:49:20 PM ******/
Create Proc [dbo].[BankTran_ImportRef] @parm1 varchar ( 20) as
Select * from BankTran
where ImportRef like @parm1
GO
