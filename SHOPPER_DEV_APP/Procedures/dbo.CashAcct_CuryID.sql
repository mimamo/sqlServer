USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[CashAcct_CuryID]    Script Date: 12/16/2015 15:55:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.CashAcct_CuryID    Script Date: 4/7/98 12:49:20 PM ******/
Create Proc [dbo].[CashAcct_CuryID] as
    select distinct Cashacct.curyid, currncy.descr from CashAcct, Currncy where cashacct.curyid = currncy.curyid
     order by CashAcct.CuryID desc
GO
