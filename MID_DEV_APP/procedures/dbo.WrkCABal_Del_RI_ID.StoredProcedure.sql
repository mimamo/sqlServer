USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[WrkCABal_Del_RI_ID]    Script Date: 12/21/2015 14:18:02 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.WrkCABal_Del_RI_ID    Script Date: 4/7/98 12:49:20 PM ******/
create Proc [dbo].[WrkCABal_Del_RI_ID] @parm1 smallint as
Delete wrkcabalances from WrkCABalances where RI_ID = @parm1
GO
