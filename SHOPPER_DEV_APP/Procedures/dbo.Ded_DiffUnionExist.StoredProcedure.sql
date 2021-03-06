USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Ded_DiffUnionExist]    Script Date: 12/21/2015 14:34:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[Ded_DiffUnionExist]
@DedId     varchar(10),
@CalYr     varchar(4),
@UnionCd   varchar(10)
As
Select Top 1 cast(1 As Integer)
From Deduction
Where DedId=@DedId And CalYr<>@CalYr And Union_Cd<>@UnionCd
GO
