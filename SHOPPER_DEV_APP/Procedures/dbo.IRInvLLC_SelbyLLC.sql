USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[IRInvLLC_SelbyLLC]    Script Date: 12/16/2015 15:55:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create procedure [dbo].[IRInvLLC_SelbyLLC] AS
Select * from IRInvLLC order by LowLevelCode
GO
