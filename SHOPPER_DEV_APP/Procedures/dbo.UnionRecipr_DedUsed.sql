USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[UnionRecipr_DedUsed]    Script Date: 12/16/2015 15:55:35 ******/
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
