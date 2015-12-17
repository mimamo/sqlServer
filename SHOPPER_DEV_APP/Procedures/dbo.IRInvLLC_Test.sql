USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[IRInvLLC_Test]    Script Date: 12/16/2015 15:55:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Procedure [dbo].[IRInvLLC_Test] @DateFor smalldatetime As
  Select * from IRInvLLC where Crtd_Datetime Between DateAdd(Second,-1,@DateFor) and DateAdd(Day,1,DateAdd(Second,-1,@DateFor))
GO
