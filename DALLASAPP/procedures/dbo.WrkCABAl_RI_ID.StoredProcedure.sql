USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[WrkCABAl_RI_ID]    Script Date: 12/21/2015 13:45:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.WrkCABAl_RI_ID    Script Date: 4/7/98 12:49:20 PM ******/
create Proc [dbo].[WrkCABAl_RI_ID] @parm1 smallint as
Select *  from WrkCABalances where RI_ID = @parm1
Order by RI_ID, CpnyID, BankAcct, Banksub
GO
