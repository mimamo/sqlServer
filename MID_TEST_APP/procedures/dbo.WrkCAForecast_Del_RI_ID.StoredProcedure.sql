USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[WrkCAForecast_Del_RI_ID]    Script Date: 12/21/2015 15:49:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.WrkCAForecast_Del_RI_ID    Script Date: 4/7/98 12:49:20 PM ******/
create Proc [dbo].[WrkCAForecast_Del_RI_ID] @parm1 smallint as
Delete wrkcaforecast from WrkCAForeCast where RI_ID = @parm1
GO
