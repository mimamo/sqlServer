USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Cashflow_All]    Script Date: 12/21/2015 13:35:37 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Cashflow_All    Script Date: 4/7/98 12:49:20 PM ******/
Create Proc [dbo].[Cashflow_All]  @parm1 varchar ( 2), @parm2beg smalldatetime, @parm2end smalldatetime, @parm3 varchar ( 30), @parm4 varchar(10), @parm5 varchar ( 10), @parm6 varchar ( 24) as
    Select * from Cashflow, Currncy where casenbr like @parm1  and rcptdisbdate between @parm2beg and @parm2end and cashflow.descr like @parm3 and cpnyid like @parm4 and bankacct like @parm5 and banksub like @parm6 and cashflow.curyid = currncy.curyid
    Order by Casenbr, Rcptdisbdate, cashflow.Descr, CpnyID, Bankacct, Banksub
GO
