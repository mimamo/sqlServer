USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[WrkCABAl_RI_ID]    Script Date: 12/16/2015 15:55:37 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.WrkCABAl_RI_ID    Script Date: 4/7/98 12:49:20 PM ******/
create Proc [dbo].[WrkCABAl_RI_ID] @parm1 smallint as
Select *  from WrkCABalances where RI_ID = @parm1
Order by RI_ID, CpnyID, BankAcct, Banksub
GO
