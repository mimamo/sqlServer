USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDPurOrdDet_SiteId]    Script Date: 12/21/2015 14:06:04 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDPurOrdDet_SiteId] @PONbr varchar(10), @LineRef varchar(5) As
Select SiteId From PurOrdDet Where PONbr = @PONbr And LineRef = @LineRef
GO
