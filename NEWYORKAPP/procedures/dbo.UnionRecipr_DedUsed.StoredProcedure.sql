USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[UnionRecipr_DedUsed]    Script Date: 12/21/2015 16:01:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[UnionRecipr_DedUsed]
@DedId     varchar(10)
As
Select Top 1 cast(1 As Integer)
From UnionReciprocity
Where DedId LIKE @DedId
GO
