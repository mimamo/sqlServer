USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[vp58330_DBNav]    Script Date: 12/21/2015 14:18:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[vp58330_DBNav]
@HomeUnion varchar(10),
@WorkUnion varchar(10),
@DedId     varchar(10)
As
Select *
From UnionReciprocity
Where HomeUnion LIKE @HomeUnion
      And WorkUnion LIKE @WorkUnion
      And DedId LIKE @DedId
Order by HomeUnion, WorkUnion, DedID
GO
