USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[CATran_RecurId]    Script Date: 12/16/2015 15:55:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.CATran_RecurId    Script Date: 4/7/98 12:49:20 PM ******/
create Proc [dbo].[CATran_RecurId] @parm1 varchar ( 10), @parm2 varchar(10) as
  Select * from CATran
  Where RecurId like @parm1
  and BankCpnyID like @parm2
  and batnbr = recurid
Order by RecurId, BankCpnyID, linenbr
GO
