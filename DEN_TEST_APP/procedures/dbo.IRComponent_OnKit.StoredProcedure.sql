USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[IRComponent_OnKit]    Script Date: 12/21/2015 15:36:58 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[IRComponent_OnKit] @KitId VarChar(30) As
Select * from Component where KitId like @KitID Order BY LineNbr
GO
