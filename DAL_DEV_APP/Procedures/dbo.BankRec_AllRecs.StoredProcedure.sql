USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[BankRec_AllRecs]    Script Date: 12/21/2015 13:35:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.BankRec_AllRecs    Script Date: 4/7/98 12:49:19 PM ******/
Create Proc [dbo].[BankRec_AllRecs] @parm1 varchar ( 10), @parm2 varchar(10), @parm3 varchar ( 24)  as
    Select * from BankRec where CpnyID like @parm1 and Bankacct like @parm2 and Banksub like @parm3
    Order by CpnyID, BankAcct, Banksub, stmtdate
GO
