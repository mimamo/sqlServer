USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[IRComponent_OnKit]    Script Date: 12/16/2015 15:55:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[IRComponent_OnKit] @KitId VarChar(30) As
Select * from Component where KitId like @KitID Order BY LineNbr
GO
