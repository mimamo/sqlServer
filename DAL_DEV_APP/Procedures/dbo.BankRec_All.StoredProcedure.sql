USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[BankRec_All]    Script Date: 12/21/2015 13:35:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.BankRec_All    Script Date: 4/7/98 12:49:19 PM ******/
Create Proc [dbo].[BankRec_All] @parm1 varchar ( 10), @parm2 varchar(10), @Parm3 varchar ( 24) as
    Select * from BankRec where cpnyid like @parm1 and bankacct Like @parm2 and banksub like @parm3
    Order by  CpnyID, BankAcct, Banksub
GO
