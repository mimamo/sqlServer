USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[WrkCAForecast_RI_ID]    Script Date: 12/21/2015 14:18:02 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.WrkCAForecast_RI_ID    Script Date: 4/7/98 12:49:20 PM ******/
create Proc [dbo].[WrkCAForecast_RI_ID] @parm1 smallint as
Select *  from WrkCAForecast where RI_ID = @parm1
Order by RI_ID, CpnyID, BankAcct, Banksub
GO
