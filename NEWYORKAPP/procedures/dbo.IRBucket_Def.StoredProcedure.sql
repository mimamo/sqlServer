USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[IRBucket_Def]    Script Date: 12/21/2015 16:01:03 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[IRBucket_Def] as
Select * from IRBucket order by DateStart
GO
