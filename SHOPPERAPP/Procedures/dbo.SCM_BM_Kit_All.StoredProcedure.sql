USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_BM_Kit_All]    Script Date: 12/21/2015 16:13:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[SCM_BM_Kit_All] @parm1 varchar (30) as
	Select * From Kit Where
		KitId LIKE @parm1 and
		KitType = 'B'
	Order By KitId
GO
