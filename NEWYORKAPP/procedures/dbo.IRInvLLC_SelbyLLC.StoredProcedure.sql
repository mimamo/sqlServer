USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[IRInvLLC_SelbyLLC]    Script Date: 12/21/2015 16:01:03 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create procedure [dbo].[IRInvLLC_SelbyLLC] AS
Select * from IRInvLLC order by LowLevelCode
GO
