USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[vp58330_DedPV]    Script Date: 12/21/2015 13:35:58 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[vp58330_DedPV]
@HomeUnion varchar(10),
@WorkUnion varchar(10),
@CalYr     varchar(4),
@DedId     varchar(10)
As
Select *
From Deduction
Where Union_CD in (@HomeUnion, @WorkUnion)
      And CalYr LIKE @CalYr
      And DedId LIKE @DedId
Order by DedId
GO
