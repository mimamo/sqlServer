USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[IRBucket_Def]    Script Date: 12/16/2015 15:55:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[IRBucket_Def] as
Select * from IRBucket order by DateStart
GO
