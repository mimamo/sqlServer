USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDPurOrdDet_CountSum]    Script Date: 12/21/2015 13:35:43 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDPurOrdDet_CountSum] @PONbr varchar(10) As
Select Count(*), Sum(QtyOrd) From PurOrdDet Where PONbr = @PONbr
GO
